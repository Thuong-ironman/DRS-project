function force = P_motor(vars)
  theta = vars(1); 
  v = vars(2);
  drag_load = vars(3);

  r_wheel = 0.33e0;
  tau_gear = 0.48615e1;
  kfit23 = 0.366013986013983128e3;
  kfit24 = 0.769766899766904794e-1;
  kfit25 = -0.495337995337997506e-5;

  t1 = r_wheel ^ 2;
t5 = pi ^ 2;
t13 = (v ^ 2);
t15 = (tau_gear ^ 2);
force = 0.1e1 / t5 * (0.30e2 * pi * kfit24 * v * tau_gear * r_wheel + t1 * kfit23 * t5 + (900 * t15 * t13 * kfit25)) * tau_gear / t1 / r_wheel * v;

end
