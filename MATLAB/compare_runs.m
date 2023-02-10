clear; clc; close all;

addpath('./Forces/');
addpath('./SimulationResults/');
addpath('./ReferenceData/');

model_parameters;
global_parameters;


filenames = {'LD-DRSoff-ref.mat'; ...
  'LD-DRSon-ref.mat'; ...
  'MD-DRSoff-ref.mat'; ...
  'MD-DRSon-ref.mat'; ...
  'HD-DRSoff-ref.mat'; ...
  'HD-DRSon-ref.mat' };


plotnames = {'LD-DRSoff.eps'; ...
  'LD-DRSon.eps'; ...
  'MD-DRSoff.eps'; ...
  'MD-DRSon.eps'; ...
  'HD-DRSoff.eps'; ...
  'HD-DRSon.eps' };

drag_loads = [0.07, 0.12, ...
  0.23, 0.35, ...
  0.95 0.77];

N   = length(filenames);
mdl = 'smlnk_mdl';
open_system(mdl);

%%

for i = 1:N 

  load(char(filenames(i)));

  in(i) = Simulink.SimulationInput(mdl);
  in(i) = in(i).setVariable('v0', ref.v0/3.6);
  in(i) = in(i).setVariable('drag_load', drag_loads(i));
  in(i) = in(i).setVariable('step_time', 20);
  in(i) = in(i).setVariable('dist_opening', ref.DRS_activation_pos);

end

% out = parsim(in, 'ShowProgress', 'on',  ...
% 'TransferBaseWorkspaceVariables', 'on');
w=warning('off','all');
out = sim(in, 'ShowProgress', 'on');
warning(w);


ind = 1;

for ind = 1:N
  load(char(filenames(ind)));

  t     = out(ind).logsout.get('theta').Values.time(:); 
  theta = out(ind).logsout.get('theta').Values.data(:); 
  vel   = out(ind).logsout.get('vel').Values.data(:);
  pos   = out(ind).logsout.get('pos').Values.data(:);
  s     = out(ind).logsout.get('s').Values.data(:);
  qi    = out(ind).logsout.get('qi').Values.data(:);
  qr    = out(ind).logsout.get('qr').Values.data(:);
  p     = out(ind).logsout.get('p').Values.data(:);

  figure;
  plot(t, vel);
  hold on;
  plot(ref.t, ref.vel);
  xlabel("t [s]");
  ylabel("vel [km/h]");
  xlim([0, 10]);
  ylim([280, 330]);
  grid on;
  legend('simulation', 'reference data', 'location', 'SouthEast');
  % title(char(filenames(ind)));
  %  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 6, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6]);
  %  exportgraphics(gca, char(plotnames(ind)));

end

%% Simulation of the overtake dynamics
clear in;

v0 = 260/3.6;
in(1) = Simulink.SimulationInput(mdl);
in(1) = in(1).setVariable('v0', v0);
in(1) = in(1).setVariable('drag_load', 0.25);
in(1) = in(1).setVariable('step_time', 2);
in(1) = in(1).setVariable('dist_opening', 1000);
in(2) = Simulink.SimulationInput(mdl);
in(2) = in(2).setVariable('v0', v0);
in(2) = in(2).setVariable('drag_load', 0.25);
in(2) = in(2).setVariable('step_time', 11);
in(2) = in(2).setVariable('dist_opening', 1000);

in(3) = Simulink.SimulationInput(mdl);
in(3) = in(3).setVariable('v0', v0);
in(3) = in(3).setVariable('drag_load', 0.75);
in(3) = in(3).setVariable('step_time', 2);
in(3) = in(3).setVariable('dist_opening', 1000);
in(4) = Simulink.SimulationInput(mdl);
in(4) = in(4).setVariable('v0', v0);
in(4) = in(4).setVariable('drag_load', 0.75);
in(4) = in(4).setVariable('step_time', 11);
in(4) = in(4).setVariable('dist_opening', 1000);

w = warning('off','all');
out = sim(in, 'ShowProgress', 'on');
warning(w);

c1 = out(1).logsout.get('vel').Values;
c2 = out(2).logsout.get('vel').Values;
c3 = out(3).logsout.get('vel').Values;
c4 = out(4).logsout.get('vel').Values;

disp("sim1");
figure;
hold on;
plot(c1.Time(:), c1.Data(:), 'Color', '#0072BD');
plot(c2.Time(:), c2.Data(:), '--', 'Color', '#0072BD');
xlabel("Time [s]");
ylabel("Speed [km/h");
ylim([260, 340]);
grid;
title("Simulation - drag load 25%");
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6])
%  exportgraphics(gca, 'lowspeed-1.eps')
disp(num2str( out(1).logsout.get('pos').Values.Data(end) ));
disp(num2str( out(1).logsout.get('pos').Values.Data(end) - out(2).logsout.get('pos').Values.Data(end) ));

figure;
hold on;
plot(c3.Time(:), c3.Data(:), 'Color', '#0072BD');
plot(c4.Time(:), c4.Data(:), '--', 'Color', '#0072BD');
xlabel("Time [s]");
ylabel("Speed [km/h");
ylim([260, 340]);
grid;
title("Simulation - drag load 75%");
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6])
%  exportgraphics(gca, 'lowspeed-2.eps')
disp(num2str( out(3).logsout.get('pos').Values.Data(end) ));
disp(num2str( out(3).logsout.get('pos').Values.Data(end) - out(4).logsout.get('pos').Values.Data(end) ));


v0 = 290/3.6;
in(1) = Simulink.SimulationInput(mdl);
in(1) = in(1).setVariable('v0', v0);
in(1) = in(1).setVariable('drag_load', 0.25);
in(1) = in(1).setVariable('step_time', 2);
in(1) = in(1).setVariable('dist_opening', 1000);
in(2) = Simulink.SimulationInput(mdl);
in(2) = in(2).setVariable('v0', v0);
in(2) = in(2).setVariable('drag_load', 0.25);
in(2) = in(2).setVariable('step_time', 11);
in(2) = in(2).setVariable('dist_opening', 1000);

in(3) = Simulink.SimulationInput(mdl);
in(3) = in(3).setVariable('v0', v0);
in(3) = in(3).setVariable('drag_load', 0.75);
in(3) = in(3).setVariable('step_time', 2);
in(3) = in(3).setVariable('dist_opening', 1000);
in(4) = Simulink.SimulationInput(mdl);
in(4) = in(4).setVariable('v0', v0);
in(4) = in(4).setVariable('drag_load', 0.75);
in(4) = in(4).setVariable('step_time', 11);
in(4) = in(4).setVariable('dist_opening', 1000);

w = warning('off','all');
out = sim(in, 'ShowProgress', 'on');
warning(w);

c1 = out(1).logsout.get('vel').Values;
c2 = out(2).logsout.get('vel').Values;
c3 = out(3).logsout.get('vel').Values;
c4 = out(4).logsout.get('vel').Values;

disp("sim2");
figure;
hold on;
plot(c1.Time(:), c1.Data(:), 'Color', '#0072BD');
plot(c2.Time(:), c2.Data(:), '--', 'Color', '#0072BD');
xlabel("Time [s]");
ylabel("Speed [km/h");
ylim([290, 330]);
grid;
title("Simulation - drag load 25%");
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6])
%  exportgraphics(gca, 'mediumspeed-1.eps')
disp(num2str( out(1).logsout.get('pos').Values.Data(end) ));
disp(num2str( out(1).logsout.get('pos').Values.Data(end) - out(2).logsout.get('pos').Values.Data(end) ));

figure;
hold on;
plot(c3.Time(:), c3.Data(:), 'Color', '#0072BD');
plot(c4.Time(:), c4.Data(:), '--', 'Color', '#0072BD');
xlabel("Time [s]");
ylabel("Speed [km/h");
grid;
title("Simulation - drag load 75%");
ylim([290, 330]);
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6]);
%  exportgraphics(gca, 'mediumspeed-2.eps');
disp(num2str( out(3).logsout.get('pos').Values.Data(end) ));
disp(num2str( out(3).logsout.get('pos').Values.Data(end) - out(4).logsout.get('pos').Values.Data(end) ));