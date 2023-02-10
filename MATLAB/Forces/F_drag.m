function force = F_drag(vars)
  theta = vars(1); 
  v = vars(2);
  drag_load = vars(3);

  rho = 0.1225e1;
  gamma_drag_car_test = 0.925e0;
  gamma_rw_drag_test = 0.235e0;
  rad_to_deg = 0.180e3 / pi;
  kfit0 = 0.107833333333333381e1;
  kfit1 = 0.529999999999999694e0;
  kfit4 = -0.306666666666666572e2;
  kfit5 = -0.184523809523809756e0;
  kfit6 = -0.236624999999999744e3;
  kfit7 = 0.174464285714284628e1;
  kfit8 = 0.191071428571429683e-1;

  t1 = (rho ^ 2);
t13 = (theta ^ 2);
t15 = (rad_to_deg ^ 2);
t20 = (v ^ 2);
force = (t20 * (kfit7 * theta * rad_to_deg + t15 * t13 * kfit8 + kfit6) * (kfit1 * drag_load + kfit0) / gamma_drag_car_test / (kfit4 + 45 * kfit5 + kfit6 + 45 * kfit7 + 2025 * kfit8) * gamma_rw_drag_test * t1) / 0.4e1;

end
