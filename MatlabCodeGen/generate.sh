echo "Compiling the code"
g++ MatlabCodeGen/codegen.cpp -o MatlabCodeGen/codegen

echo "Running the code:"
MatlabCodeGen/codegen $1

[ -d MATLAB ] || mkdir MATLAB

# echo "Moving generated file into MATLAB folder"
# mv $1* MATLAB/
# mv MapleGeneratedCodes/$1* MATLAB/