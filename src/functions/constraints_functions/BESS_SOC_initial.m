function prob = BESS_SOC_initial(prob, E0, x_ESS_IV, BAT)
  prob.Constraints.E0_max     = E0  <= x_ESS_IV*BAT.C_batt*BAT.SOC_max;
  prob.Constraints.E0_min     = E0  >= x_ESS_IV*BAT.C_batt*BAT.SOC_min - epsilon_bat;
end