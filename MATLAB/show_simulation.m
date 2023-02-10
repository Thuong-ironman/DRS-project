clear; close all; clc;
addpath('./SimulationResults/');

% Simulation set
load('iv290-dl30.mat');

disp(['Initial velocity: ', num2str(v0), 'km/h']);
disp(['Drag load condition: ', num2str(drag_load*100), '%']);

% time vs velocity
figure;
plot(t, vel);
xlabel("time [s]");
ylabel("velocity [km/h]");
title("Velocity vs time");
grid on;
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6]);
%  exportgraphics(gca, 'simout-1.eps');


% time vs position
figure;
plot(t, pos);
xlabel("time [s]");
ylabel("position [m]");
title("Position vs time");
grid on;
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6]);
%  exportgraphics(gca, 'simout-2.eps');


% time vs cylinder stroke
figure;
plot(t, s);
xlabel("time [s]");
ylabel("s [mm]");
title("Cylinder stroke vs time");
grid on;
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6]);
%  exportgraphics(gca, 'simout-3.eps');

% flap angle vs cylinder stroke
figure;
plot(s, theta);
xlabel("s [mm]");
ylabel("\theta [°]");
title("Flap angle vs cylinder stroke");
grid on;

% flow vs time
figure;
plot(qr, t);
hold on;
plot(qi, t);
xlabel("t [s]");
ylabel("Q [l/min]");
title("Flow vs time");
legend('to cylinder', 'Generated');
grid on;
hold off;

% pressure vs time
figure;
plot(t, p);
xlabel("t [s]");
ylabel("p [bar]");
title("Pressure vs time");
grid on;
%  set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 9, 6], 'PaperUnits', 'centimeters', 'PaperSize', [9, 6]);
%  exportgraphics(gca, 'simout-4.eps');


