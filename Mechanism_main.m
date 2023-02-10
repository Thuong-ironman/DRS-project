clc;
close all;
clear;

% ODE initialization
Mechanism_parameters;
Mechanism_initial;
ode = Mechanism(params);

% Set solver and time map
solver = Heun();
solver.setODE(ode);

Tmax  = 3;
tstep = 0.01;
tt    = 0:tstep:Tmax;
e_th  = 1e-6;  % threshold for the error for the constraint validation

% Check that the constraints are satisfied
err = ode.h(0, initial_conditions);
if(max(abs(err)) > e_th)
  disp('Attention, the initial condition do not match the initial conditions');
  disp(['Maximum value of the constraint map: ', num2str(max(abs(err)))]);
  disp(['Maximum allowed error: ', num2str(e_th)]);
  return;
else
  disp('Initial condition satisfies the constraints');
end

% Solve the ODE
sol = solver.advance(tt, initial_conditions);

% Extraction of the data from the solutions
sol_x = sol(1,:);
sol_y = sol(2,:);
sol_lambda = sol(3,:);
sol_x__dot = sol(4,:);
sol_y__dot = sol(5,:);

figure;
hold on;
plot(tt, sol(1,:));
plot(tt, sol(2,:));
plot(tt, sol(3,:));
legend('x1', 'x2', 'y2');
grid on;
