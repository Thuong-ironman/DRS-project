function force = T_shaft(vars)
  theta = vars(1); 
  v = vars(2);
  drag_load = vars(3);

  r_wheel = 0.33e0;
  tau_gear = 0.48615e1;
  eta_motor = 0.95e0;
  kfit23 = 0.366013986013983128e3;
  kfit24 = 0.769766899766904794e-1;
  kfit25 = -0.495337995337997506e-5;

  t1 = r_wheel ^ 2;
t3 = pi ^ 2;
t11 = (v ^ 2);
t13 = (tau_gear ^ 2);
force = tau_gear * eta_motor / t3 * (0.30e2 * pi * kfit24 * v * tau_gear * r_wheel + t1 * kfit23 * t3 + (900 * t13 * t11 * kfit25)) / t1;

end
