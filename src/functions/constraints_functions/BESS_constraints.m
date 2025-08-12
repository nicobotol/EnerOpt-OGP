function prob = BESS_constraints(prob, scenario, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat)

  if BESS_NL_model == 1
    prob = BESS_SOC_stationarity_NL_model(prob, E0, Ebt, Pch, Pdc, scenario.tau);
    prob = max_power(prob, 'PchUch_max', Pch, PchUch);
    prob = max_power(prob, 'PdcUdc_max', Pdc, PdcUdc);
    prob = max_power(prob, 'Pch_max', Pch, x_ESS_NIV);
    prob = max_power(prob, 'Pdc_max', Pdc, x_ESS_NIV);
    prob = lin_ContBin(prob, 'lin_NL_PchUch', PchUch, Pch, Uch, BAT.Pch_max, 0);
    prob = lin_ContBin(prob, 'lin_NL_PdcUdc', PdcUdc, Pdc, Udc, BAT.Pch_max, 0);
    prob = BESS_UchUdc(prob, Uch, Udc);
  else
    prob = BESS_SOC_stationarity(prob, E0, Ebt, Pbt);
    prob = BESS_P_minmax(prob, Pbt, x_ESS_NIV);
    prob = max_power(prob, 'Pch_max', Pch, x_ESS_NIV);
    prob = max_power(prob, 'Pdc_max', Pdc, x_ESS_NIV);
  end
  prob = BESS_SOC_minmax(prob, E0, x_ESS_IV, BAT, epsilon_bat);   % initial energy
  prob = BESS_SOC_minmax(prob, Ebt, x_ESS_IV, BAT, epsilon_bat);  % general energy

end