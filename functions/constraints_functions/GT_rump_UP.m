function prob = GT_rump_UP(prob, n_GT, T, W, P_GT, GT_obj)
  % GT ramp rate constraints
  for g = 1:n_GT
    GT_T = GT_obj{g}.R;
    RampUp(2:T,1:W,g) = P_GT(2:T,1:W,g) - P_GT(1:T-1,1:W,g);
    rampUpPowGTCnstr(2:T,1:W,g) =  RampUp(2:T,1:W,g) <= GT_T;
    rampDownPowGTCnstr(2:T,1:W,g) = P_GT(2:T,1:W,g) - P_GT(1:T-1,1:W,g) >= -GT_T;
  end
  prob.Constraints.rampUpPowGTCnstr = rampUpPowGTCnstr;
  prob.Constraints.rampDownPowGTCnstr = rampDownPowGTCnstr;
end