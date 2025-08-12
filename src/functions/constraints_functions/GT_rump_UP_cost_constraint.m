function prob = GT_rump_UP_cost_constraint(prob, n_GT, T, W, P_GT, RR)
  % constraints associated to the ramp up of the GTs
  for g = 1:n_GT
    RampUp(2:T,1:W,g) = P_GT(2:T,1:W,g) - P_GT(1:T-1,1:W,g);
    rampUpPowGTCnstr_cost_1(2:T,1:W,g) =  RampUp(2:T,1:W,g) <= RR(2:T,1:W,g);
    rampUpPowGTCnstr_cost_2(2:T,1:W,g) =  -RampUp(2:T,1:W,g) <= RR(2:T,1:W,g);
  end
  prob.Constraints.rampUpPowGTCnstr_cost_1 = rampUpPowGTCnstr_cost_1;
  prob.Constraints.rampUpPowGTCnstr_cost_2 = rampUpPowGTCnstr_cost_2;
end