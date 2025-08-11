function prob = Pv_REC_constraint(prob, n_REC, x_REC, Pv, Pv_max, REC_obj, delta_REC_Pmax, epsilon)

  for r=1:n_REC
    PowRated  = floor(REC_obj{r}.max_installed_power/REC_obj{r}.PowRated)*REC_obj{r}.PowRated; % max power for each plant
    Pow       = x_REC(r)*REC_obj{r}.PowRated;
    prob      = Pv_max_plant_size(prob, ['REC', num2str(r)], Pv, Pv_max, PowRated, Pow, delta_REC_Pmax(:,:,r), PowRated, -1, epsilon); % Pv only if the REC installation is maximum
  end

end