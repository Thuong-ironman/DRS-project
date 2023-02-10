function force = F_tot_down(vars)
  theta = vars(1); 
  v = vars(2);
  drag_load = vars(3);

  rho = 0.1225e1;
  gamma_down_car_test = 0.243e1;
  gamma_rw_down_test = 0.92e0;
  rad_to_deg = 0.180e3 / pi;
  kfit2 = 0.361500000000000155e1;
  kfit3 = 0.152999999999999936e1;
  kfit9 = -0.799242424242423567e3;
  kfit10 = 0.102738095238094758e2;
  kfit11 = -0.144805194805193854e0;
  kfit12 = 0.681818181818175475e-3;
  kfit13 = -0.901515151515149711e2;
  kfit14 = -0.561904761904764438e1;
  kfit15 = -0.527056277056269021e-1;
  kfit16 = 0.219696969696968943e-2;

  t2 = kfit3 * drag_load + kfit2;
t4 = v ^ 2;
t6 = rho * gamma_rw_down_test;
t8 = 0.1e1 / gamma_down_car_test * t2;
t20 = (theta ^ 2);
t21 = (t20 * theta);
t23 = (rad_to_deg ^ 2);
t24 = (t23 * rad_to_deg);
force = t4 * t2 * rho / 0.2e1 - t4 * t8 * t6 / 0.2e1 + t4 * (kfit10 * theta * rad_to_deg + t23 * t20 * kfit11 + t24 * t21 * kfit12 + kfit14 * theta * rad_to_deg + t23 * t20 * kfit15 + t24 * t21 * kfit16 + kfit13 + kfit9) * t8 / (45 * kfit10 + 2025 * kfit11 + 91125 * kfit12 + kfit13 + 45 * kfit14 + 2025 * kfit15 + 91125 * kfit16 + kfit9) * t6 / 0.2e1;

end
