clear; clc; close all;

perform_simulations = true;

addpath('./Forces/');
addpath('./SimulationResults/');

model_parameters;
global_parameters;

dist_opening=10000;
drag_load = 10;
v0 = 270/3.6;   % 270km/h initial velocity in m/s
step_time = 2;

%% Simulations given different initial conditions and drag load coefficients
if perform_simulations == true 

  v0_vect        = 260:5:310; % velocity in km/h
  drag_load_vect = 0:0.1:1;

  mdl = 'smlnk_mdl';
  open_system(mdl);

  for k = 1:length(v0_vect)
    for i = 1:length(drag_load_vect)
      in(k,i) = Simulink.SimulationInput(mdl);
      in(k,i) = in(k,i).setVariable('v0', v0_vect(k)/3.6);
      in(k,i) = in(k,i).setVariable('drag_load', drag_load_vect(i));
      in(k,i) = in(k,i).setVariable('step_time', 2);
    end
  end

  out = parsim(in, 'ShowProgress', 'on',  ...
    'TransferBaseWorkspaceVariables', 'on');
  % out = sim(in);

  % Extraction of the results
  strcat(['iv', num2str(v0_vect(1)), '-dl', num2str(100*drag_load_vect(2))]);
  clc; close all;

  for k = 1:length(v0_vect)
    for i = 1:length(drag_load_vect)

      v0        = v0_vect(k);
      drag_load = drag_load_vect(i);

      t     = out(k,i).logsout.get('theta').Values.time(:); 
      theta = out(k,i).logsout.get('theta').Values.data(:); 
      vel   = out(k,i).logsout.get('vel').Values.data(:);
      pos   = out(k,i).logsout.get('pos').Values.data(:);
      s     = out(k,i).logsout.get('s').Values.data(:);
      qi    = out(k,i).logsout.get('qi').Values.data(:);
      qr    = out(k,i).logsout.get('qr').Values.data(:);
      p     = out(k,i).logsout.get('p').Values.data(:);
      file  = string(strcat(['SimulationResults/iv', num2str(v0), '-dl', num2str(100*drag_load)]));
      save(file, 'v0', 'drag_load', 't', 'theta', 'vel', 'pos', 's', 'qi', 'qr', 'p' );
    end
  end

end % simulate only if needed

