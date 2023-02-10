
#include <algorithm>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <string.h>
#include <sstream>

using namespace std;

string maplePath = "MapleGeneratedCodes/";


string processLine(string& line);
string generateConstructor();
void generateCommonBlock();
void generateParamFile(string);
void generateMainFile(string);
// constexpr int str_2_int(const string str);

int main(int argc, char *argv[]){

  string name;
  if(argc <= 1){
    name = "generated";
  } else {
    name = string(argv[1]);
  }
  cout << "NAME: " << name << endl;

  ifstream skeleton("MatlabCodeGen/skeleton.m");
  ofstream generated(name + ".m");

  if(!skeleton.is_open()){
    cout << "Coult not open \"skeleton.m\"" << endl;
    return 1;
  }

  
  generated << generateConstructor();
  generated << endl;
  generateCommonBlock();

  string line;
  while(getline(skeleton, line)){    
    generated << processLine(line);
  }
  
  generateParamFile(name + "_parameters.m");
  generateMainFile(name);

  skeleton.close();
  generated.close();
  return 0;

}


constexpr int str_2_int(const char* str) {

  int res = 0;
  const char * c = str;
  while(*c != '\0'){
    res += (int)*c;
    c++;
  }

  return res;
}


string generateConstructor(){
  
  int n_ode, n_inv;
  string spaces = "    ";
  string DAE_name;
  string str;
  ofstream file(maplePath + "constructor.txt");
  ifstream vars(maplePath + "var-names.txt");
  ifstream DAEd(maplePath + "DAE-data.txt");

  DAEd >> DAE_name >> n_ode >> n_inv;
  printf("DAE name: %s\n", DAE_name.c_str());
  cout << "n. ODE: " << n_ode << "; n. INVS: " << n_inv << endl;

  file << spaces << "function self = "<< DAE_name << "(pars)" << endl << endl;
  file << spaces << "  n_ODE = " << n_ode << ";" << endl;
  file << spaces << "  n_INV = " << n_inv << ";" << endl << endl;
  file << spaces << "  self@DAC_ODEclass('" << DAE_name << "', n_ODE, n_INV);" << endl << endl;
  
  int index = 1;
  while(getline(vars, str)){    
    str = str.substr(0, str.length()-1);
    file << spaces << "  self." << str << " = pars(" << index << ");"  << endl;
    index++;
  }

  file << endl << spaces << "end" << endl;

  DAEd.close();
  vars.close();
  file.close();

  return "classdef " + DAE_name + " < DAC_ODEclass";
  
}


void generateCommonBlock(){

  ofstream file(maplePath + "common.txt");
  ifstream vars(maplePath + "var-names.txt");

  file << endl << "% parameters" << endl;
  string str;
  while(getline(vars, str)){
    str.pop_back();
    file << str << " = self." << str << ";" << endl;
  }

  vars.close();
  file.close();
}


string processLine(string& line){

  size_t commentpos = line.find("%%%");
  if(commentpos == string::npos)
    return line;

  string file_name;
    
  line.erase(0, commentpos+3);
  auto newlineend = remove(line.begin(), line.end(), ' ');
  line.erase(newlineend-1, line.end());
  file_name = line;

  string filesource = maplePath + file_name;
  ifstream infile(filesource);
  cout << "Reading from \"" << filesource << "\"" << endl;
  if(infile.fail())
    cout << "FAILURE while loading the file" << endl;

  string commonsource = maplePath + "common.txt";
  ifstream commonfile(commonsource);
  if(commonfile.fail())
    cout << "Common block file read failed" << endl;

  string forcesource = maplePath + "forces.txt";
  ifstream forcefile(forcesource);
  if(forcefile.fail())
    cout << "Force file read failed" << endl;

  stringstream ss;
  string current_line;
  string spaces = string(commentpos, ' ');
  
  // char fn[file_name.length() + 1];
  
  switch(str_2_int(file_name.c_str())){
    
    case str_2_int("var-names.txt"):
      ss << spaces << "%% Copying model parameters from " << file_name << endl;
      while(getline(infile, current_line))
        ss << spaces << "  "<< current_line << endl;
      break;

    case str_2_int("invariants.txt"):
    case str_2_int("jacobian-invariants.txt"):
      ss << spaces << "%% Generating from " << file_name << endl;
      getline(infile, current_line);
      ss << current_line << endl;

      while(getline(commonfile, current_line))
        ss << spaces << "  " << current_line << endl;
      ss << endl;
      
      while(getline(infile, current_line) && current_line.find("evaluate") == string::npos)
        ss << current_line << endl;

      ss << spaces << "  % forces definition" << endl;
      while(getline(forcefile, current_line))
        ss << spaces << "  " << current_line << endl;
        
      ss << endl << spaces << "  % evaluate function" << endl;
      while(getline(infile, current_line))
        ss << current_line << endl;
      break;

    case str_2_int("constructor.txt"):
      while(getline(infile, current_line))
        ss << current_line << endl;
      break;    

    default:
      while(getline(infile, current_line)){
        ss << spaces << current_line << endl;
        if(current_line.find("Forces") != string::npos){
          while(getline(forcefile, current_line))
            ss << spaces << "  " << current_line << endl;
        }
      }
      
      break;    
  }

  forcefile.close();
  commonfile.close();
  infile.close();

  return ss.str();

}

void generateParamFile(string outname){
  
  ofstream out(outname);
  ifstream values(maplePath + "var-values.txt");
  ifstream names(maplePath + "var-names.txt");
  string str;

  out << "%% Copyied Maple parameters" << endl;
  while(getline(values, str))
    out << str << endl;

  out << endl;
  out << "%% Substitution vector" << endl;
  getline(names, str);
  str = str.substr(0, str.length()-1);
  out << "params = [" << str;
  while(getline(names, str)){
    str = str.substr(0, str.length()-1);
    out << ", " << str;
  }
  out << "];";
  

  out.close();
  values.close();
  names.close();
}

void generateMainFile(string outname){
  
  ofstream out(outname + "_main.m");
  ifstream in("MatlabCodeGen/main_skeleton.m");
  string str;
  
  cout << "Generating main file:" << endl;
  if(out.fail())
    cout << "FAILURE while opening output file" << endl;
  if(in.fail())
    cout << "FAILURE while loading input file" << endl;

  while(getline(in, str)){

    if(str.find("% INIT") != string::npos){
      out << outname << "_parameters;" << endl;
      out << outname << "_initial;" << endl;
      out << "ode = " << outname << "(params);" << endl;
    } else if (str.find("% EXTRACT") != string::npos){
      
      ifstream vars(maplePath + "DAE-vars.txt");
      int ind = 1;
      while(getline(vars, str)){
      str = str.substr(0, str.length()-1);
        out << "sol_" << str << " = sol(" << ind << ",:);" << endl;
        ind++;
      }

    } else {
      out << str << endl;
    }

  }

  out.close();
  in.close();
}