function prob = Pv_BESS_constraint(prob, num_ESS, x_ESS_NIV, x_ESS_IV, Pv, Pv_max, BAT, delta_ESS_Pmax, delta_ESS_Emax, epsilon)

  for b=1:num_ESS
    % max power from battery
    PowRated  = BAT.Pch_max; 
    Pow       = x_ESS_NIV(b);
    prob      = Pv_max_plant_size(prob, ['BESS_P', num2str(b)], Pv, Pv_max, PowRated, Pow, delta_ESS_Pmax(:,:,b), 1.1*PowRated, -1, epsilon); % Pv only if the REC installation is maximum

    % max energy of the battery
    PowRated  = floor(BAT.E_max/BAT.C_batt)*BAT.C_batt; 
    Pow       = x_ESS_IV(b)*BAT.C_batt;
    prob      = Pv_max_plant_size(prob, ['BESS_E', num2str(b)], Pv, Pv_max, PowRated, Pow, delta_ESS_Emax(:,:,b), 1.1*PowRated, -1, epsilon); % Pv only if the REC installation is maximum
  end

end