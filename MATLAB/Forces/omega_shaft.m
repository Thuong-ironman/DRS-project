function force = omega_shaft(vars)
  theta = vars(1); 
  v = vars(2);
  drag_load = vars(3);

  r_wheel = 0.33e0;

  force = v / r_wheel;

end
