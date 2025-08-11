function prob = Pv_power_constraint_linear(prob, Pv, Pv_max_inst)
  % Limit the virtual power to the decision variable Pv_max_inst

  prob.Constraints.Pv_power_constraint = Pv <= Pv_max_inst;

end