function prob = BESS_SOC_minmax(prob, Ebt, x_ESS_IV, BAT, epsilon_bat)
  prob.Constraints.Ebt_max     = Ebt  <= x_ESS_IV*BAT.C_batt*BAT.SOC_max;
  prob.Constraints.Ebt_min     = Ebt  >= x_ESS_IV*BAT.C_batt*BAT.SOC_min - epsilon_bat;
end