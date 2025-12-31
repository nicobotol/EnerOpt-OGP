function prob = HSS_constraints(prob, E_H0, E_H, Pel, Pfc, PelUel, PfcUfc, Uel, Ufc, HSS, x_HSS_IV, x_HSS_fc, x_HSS_el, rev_FC)

  eta_ch = HSS.eta_el; % HSStery cherging efficiency  
  eta_dc = HSS.eta_fc; % HSStery discharging efficiency
  
  if rev_FC == 0 % independent fuel cell and electrolyzer

    % charging/discharging dynamic (mass balance)
    prob = BESS_SOC_stationarity_NL_model(prob, 'HSS', E_H0, E_H, Pel*eta_ch, Pfc/eta_dc);

    % maximum power charging and discharging the fuel cell and the electrolyzer
    prob = max_power(prob, 'Pfc_max', Pfc, x_HSS_fc);
    prob = max_power(prob, 'Pel_max', Pel, x_HSS_el);

    % Constraint the power and energy to the one of the device
    prob.Constraints.device_Pel = x_HSS_el*HSS.C_unitaryP_el <= HSS.Pel_max;
    prob.Constraints.device_Pfc = x_HSS_fc*HSS.C_unitaryP_fc <= HSS.Pfc_max;
    prob.Constraints.device_E_H = x_HSS_IV*HSS.C_storage_u <= HSS.E_H_max;
    
  elseif  rev_FC == 1 % reversible fuel cell and electrolyzer
    
    prob = BESS_SOC_stationarity_NL_model(prob, 'HSS', E_H0, E_H, Pel*eta_ch, Pfc/eta_dc);
    prob = max_power(prob, 'PelUel_max', Pel, PelUel);
    prob = max_power(prob, 'PfcUfc_max', Pfc, PfcUfc);
    prob = max_power(prob, 'Pel_max', Pel, x_HSS_fc*HSS.C_unitaryP_fc);
    prob = max_power(prob, 'Pfc_max', Pfc, x_HSS_fc*HSS.C_unitaryP_fc);
    prob = lin_ContBin(prob, 'lin_NL_PelUel', PelUel, Pel, Uel, HSS.Pel_max, 0);
    prob = lin_ContBin(prob, 'lin_NL_PfcUfc', PfcUfc, Pfc, Ufc, HSS.Pel_max, 0);
    prob = BESS_UchUdc(prob, 'UelUfc', Uel, Ufc);
  end

  prob = HSS_SOC_minmax(prob, 'E_H', E_H, x_HSS_IV, HSS);   % general energy
  prob = HSS_SOC_minmax(prob, 'E_H0', E_H0, x_HSS_IV, HSS);  % initial energy

end