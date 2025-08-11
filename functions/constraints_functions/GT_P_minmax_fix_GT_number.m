function prob = GT_P_minmax_fix_GT_number(prob, n_GT, T, W, P_GT, GT_obj, u_GT)
  % GT power output constraints
  for g=1:n_GT
    PowRated = GT_obj{g}.PowRated;
    GT_gamma = GT_obj{g}.gamma;
    P_GT_max = PowRated.*u_GT(1:T,1:W,g); 
    GT_power_max(1:T,1:W,g)   = P_GT(1:T,1:W,g) <= P_GT_max; % maximum power output of the GT
    GT_power_min(1:T,1:W,g)   = P_GT(1:T,1:W,g) >= P_GT_max*GT_gamma; % minimum power output of the GT
  end
  prob.Constraints.GT_power_max = GT_power_max;
  prob.Constraints.GT_power_min = GT_power_min;
end