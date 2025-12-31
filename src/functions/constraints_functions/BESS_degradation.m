function [prob,psi] = BESS_degradation(prob, name, BAT, x_ESS_IV, Ebt, theta_sh, theta, h_pla, alpha_pla, zeta_pla, zeta_psi, u_pla, y_abs, z_abs, z_max, x_deg, y_deg, x_ESS_IV_min, x_ESS_IV_max, x_ESS_presence, b_expansion, max_theta)
  % Constraints to model the ageing of the BESS, and linearize the product between the degradation and the BESS energy
  % prob -> optimization problem
  % name -> constraint name
  % theta_sh -> shelf damage
  % theta -> total damage
  % psi -> degradation function
  
  [T, W] = size(Ebt);
  
  [prob, psi] = PLA_approximation_rescaled(prob, [name,'_PLA'], h_pla, alpha_pla, zeta_pla, zeta_psi, u_pla, x_ESS_IV, x_ESS_IV_min, x_ESS_IV_max, x_ESS_presence, BAT.C_batt, b_expansion, x_deg, y_deg, Ebt);

  prob.Constraints.([name, '_shelf_ageing'])          = theta >= x_ESS_presence*theta_sh;
  prob.Constraints.([name, '_cycle_ageing_module_1']) = theta >= 0.5*(psi(2:end,:) - psi(1:end-1,:)); % linearization of the module
  prob.Constraints.([name, '_cycle_ageing_module_2']) = theta >= 0.5*(psi(1:end-1,:) - psi(2:end,:)); % linearization of the module

  % % absolute value: y_abs(t) = abs( psi(t) - psi(t-1) )
  % prob = abs_Cont(prob, [name, '_abs_deg'], y_abs, psi(2:end,:) - psi(1:end-1,:), z_abs, max_theta);

  % % maximum: theta = max(y_abs/2, theta_sh)
  % prob = max_Cont(prob, [name, '_max_deg'], 2, theta, {y_abs/2, x_ESS_presence*theta_sh*ones(T-1,W)}, zeros(T-1,W,2), max_theta*ones(T-1,W,2), z_max);

  % max daily damage
  prob.Constraints.([name, '_max_daily_degradation']) = ones(T-1, 1)'*theta <= BAT.max_day_deg;

end