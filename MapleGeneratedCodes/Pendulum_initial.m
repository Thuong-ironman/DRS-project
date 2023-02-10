%% Independent coordinates
x0 = 0;
x__vel0 = 0;

%% Positions
t1 = ell ^ 2;
t2 = x0 ^ 2;
y0 = sqrt(t1 - t2);

%% Velocity
y__vel0 = -x0 * x__vel0 / y0;

%% Force models
