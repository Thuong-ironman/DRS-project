function force = F_roll(vars)
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
  m_car = 900;
  g = 0.981e1;
  f0 = 0.25e-1;
  K0 = 0.65e-5;

  t2 = kfit3 * drag_load + kfit2;
t4 = v ^ 2;
t7 = rho * gamma_rw_down_test;
t9 = 0.1e1 / gamma_down_car_test * t2;
t22 = (theta ^ 2);
t23 = (t22 * theta);
t25 = (rad_to_deg ^ 2);
t26 = (t25 * rad_to_deg);
force = (t4 * K0 + f0) * (t4 * t2 * rho / 0.2e1 - t4 * t9 * t7 / 0.2e1 + t4 * (kfit10 * theta * rad_to_deg + t25 * t22 * kfit11 + t26 * t23 * kfit12 + kfit14 * theta * rad_to_deg + t25 * t22 * kfit15 + t26 * t23 * kfit16 + kfit13 + kfit9) * t9 / (45 * kfit10 + 2025 * kfit11 + 91125 * kfit12 + kfit13 + 45 * kfit14 + 2025 * kfit15 + 91125 * kfit16 + kfit9) * t7 / 0.2e1 + m_car * g);

end
