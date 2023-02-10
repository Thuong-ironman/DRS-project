function force = omega_motor(vars)
  theta = vars(1); 
  v = vars(2);
  drag_load = vars(3);

  r_wheel = 0.33e0;
  tau_gear = 0.48615e1;

  force = v / r_wheel * tau_gear;

end
