function prob = REC_constraints(prob, P_res, P_REC_max, n_REC, REC_obj, x_REC)

  prob = max_power(prob, 'REC_max_power', P_res, P_REC_max); % Maximum power produced by the REC

  for r = 1:n_REC
    name = ['REC', num2str(r), '_max_power'];
    prob = max_power(prob, name, x_REC(r)*REC_obj{r}.PowRated, REC_obj{r}.max_installed_power); % max power for each plant
  end

end