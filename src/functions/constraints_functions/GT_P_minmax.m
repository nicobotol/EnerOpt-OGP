function prob = GT_P_minmax(prob, n_GT, T, W, P_GT, x_GT, GT_obj, u_GT, z_help)
  % GT power output constraints
  for g=1:n_GT
    PowRated = GT_obj{g}.PowRated;
    GT_gamma = GT_obj{g}.gamma;
    P_GT_max = PowRated.*z_help(1:T,1:W,g); 
    GT_power_max(1:T,1:W,g)   = P_GT(1:T,1:W,g) <= P_GT_max; % maximum power output of the GT
    GT_power_min(1:T,1:W,g)   = P_GT(1:T,1:W,g) >= P_GT_max*GT_gamma; % minimum power output of the GT
    z_help_cnstr(1:T,1:W,g)   = z_help(1:T,1:W,g) >= u_GT(1:T,1:W,g) + x_GT(g) - 1;
    z_help_cnstr_1(1:T,1:W,g) = z_help(1:T,1:W,g) <=  x_GT(g);
    z_help_cnstr_2(1:T,1:W,g) = z_help(1:T,1:W,g) <=  u_GT(1:T,1:W,g);
  end
  prob.Constraints.GT_power_max = GT_power_max;
  prob.Constraints.GT_power_min = GT_power_min;
  prob.Constraints.z_help       = z_help_cnstr;
  prob.Constraints.z_help_1     = z_help_cnstr_1;
  prob.Constraints.z_help_2     = z_help_cnstr_2;
end