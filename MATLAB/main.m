clc;
close all;
clear;

solver = Heun();
ode    = PendulumCart();
solver.setODE(ode);

Tmax = 3;
h    = 0.01;
tt   = 0:h:Tmax;

PendulumCart_initial;

sol = solver.advance(tt, initial_conditions);

figure;
hold on;
plot(tt, sol(1,:));
plot(tt, sol(2,:));
plot(tt, sol(3,:));
legend('x1', 'x2', 'y2');
grid on;

figure;
plot(tt, sol(8,:));