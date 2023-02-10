clear; clc; close all;

addpath('./Forces/');
addpath('./SimulationResults/');
addpath('./ReferenceData/');

model_parameters;
global_parameters;

v0 = 270;
dl = 0.5; % drag load

mdl = 'smlnk_mdl';

dist_opening = 1000;

in = Simulink.SimulationInput(mdl);
in = in.setVariable('v0', v0/3.6);
in = in.setVariable('drag_load', dl);
in = in.setVariable('step_time', 2);

out = sim(in);

t     = out.logsout.get('theta').Values.time(:); 
theta = out.logsout.get('theta').Values.data(:); 
vel   = out.logsout.get('vel').Values.data(:);
pos   = out.logsout.get('pos').Values.data(:);
s     = out.logsout.get('s').Values.data(:);
qi    = out.logsout.get('qi').Values.data(:);
qr    = out.logsout.get('qr').Values.data(:);
p     = out.logsout.get('p').Values.data(:);

figure;
plot(t, p);

figure
plot(t, s);
      