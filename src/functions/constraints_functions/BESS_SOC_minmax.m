function prob = BESS_SOC_minmax(prob, name, Ebt, x_ESS_IV, BAT, epsilon_bat)
  prob.Constraints.([name,'_max'])     = Ebt  <= x_ESS_IV*BAT.C_batt*BAT.SOC_max;
  prob.Constraints.([name,'_min'])     = Ebt  >= x_ESS_IV*BAT.C_batt*BAT.SOC_min - epsilon_bat;
end