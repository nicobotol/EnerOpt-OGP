function [prob,psi] = BESS_constraints(prob, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat, theta, theta_sh, h_pla, alpha_pla, zeta_pla, zeta_psi, u_pla, y_abs, z_abs, z_max, x_deg, y_deg, z_xEssIv_theta, xEssIv_theta, x_ESS_IV_min, x_ESS_IV_max, x_ESS_presence, b_expansion, max_theta)
% E0 -> initial SOC
% Ebt -> BESS SOC
% Pch -> power charging the BESS
% Pdc -> power discharging the BESS
% Pbt -> power charging/discharging the BESS
% Uch -> charging indicator
% Udc -> discharging indicator
% PchUch -> helper variable to linearize the product Pch*Uch
% PdcUdc -> helper variable to linearize the product Pdc*Udc
% BAT -> BESS object
% x_ESS_IV -> integer number quantifying how many energy module 
% x_ESS_NIV -> power size of the BESS 
% epsilon_bat -> variable for bess size soft constraint
% theta -> degradation
% theta_sh -> shelf degradation
% u_theta -> helper variable for linearize the product theta*x_ESS_IV
% zeta_theta -> helper variable for linearize the product theta*x_ESS_IV
% Ki -> number of points for the binary expansion of the product between damage and battery module number
% h_pla -> integer helper variable for the PLA
% alpha_pla -> continuous helper variable for the PLA
% x_deg -> x-coordinate (BESS energy) of the degradation map
% y_deg -> y-coordinate (damage) of the degradation map


  if BESS_NL_model == 1
    prob = BESS_SOC_stationarity_NL_model(prob, 'Ebt', E0, Ebt, Pch*BAT.eta_ch, Pdc/BAT.eta_dc);
    prob = max_power(prob, 'PchUch_max', Pch, PchUch);
    prob = max_power(prob, 'PdcUdc_max', Pdc, PdcUdc);
    prob = max_power(prob, 'Pch_max', Pch, x_ESS_NIV);
    prob = max_power(prob, 'Pdc_max', Pdc, x_ESS_NIV);
    prob = lin_ContBin(prob, 'lin_NL_PchUch', PchUch, Pch, Uch, BAT.Pch_max, 0);
    prob = lin_ContBin(prob, 'lin_NL_PdcUdc', PdcUdc, Pdc, Udc, BAT.Pch_max, 0);
    prob = BESS_UchUdc(prob, 'avoid_ch_dc', Uch, Udc);
  else
    prob = BESS_SOC_stationarity(prob, E0, Ebt, Pbt);
    prob = BESS_P_minmax(prob, Pbt, x_ESS_NIV);
    prob = max_power(prob, 'Pch_max', Pch, x_ESS_NIV);
    prob = max_power(prob, 'Pdc_max', Pdc, x_ESS_NIV);
  end
  prob = BESS_SOC_minmax(prob,'BESS_E_initial', E0, x_ESS_IV, BAT, epsilon_bat);  % initial energy
  prob = BESS_SOC_minmax(prob,'BESS_E_gen', Ebt, x_ESS_IV, BAT, epsilon_bat);     % general energy

  if BAT.deg_cost_enable == 1
    [prob,psi] = BESS_degradation(prob, 'BESS_deg', BAT, x_ESS_IV, Ebt, theta_sh, theta, h_pla, alpha_pla, zeta_pla, zeta_psi, u_pla, y_abs, z_abs, z_max, x_deg, y_deg, x_ESS_IV_min, x_ESS_IV_max, x_ESS_presence, b_expansion, max_theta);

    prob = lin_ContInt(prob, 'xEssIv_theta', z_xEssIv_theta, theta, xEssIv_theta, u_pla, max_theta, x_ESS_IV_min, b_expansion);

  end

  % psi = 0;
end