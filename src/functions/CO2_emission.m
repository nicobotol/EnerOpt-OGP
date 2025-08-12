function CO2_emitted = CO2_emission(objData, n_NREC, P, u)
  
  for g = 1:n_NREC
    mu = objData{g}.mu; % ideal combustion coefficient of fuel
    alpha_g = objData{g}.alpha_g; % coeff for estimating modeling fuel consumption [kg/W]
    beta_g = objData{g}.beta_g; % coeff for estimating modeling fuel consumption [kg/h]

    CO2_emitted_g(g) = mu*sum(alpha_g*P(:,:,g) + beta_g*u(:,:,g));
  end

  CO2_emitted = sum(CO2_emitted_g);
end