function prob = Pv_DG_constraint(prob, n_DG, Pv, Pv_max, DG_obj, P_DG, delta_DG_Pmax, epsilon)

  for g=1:n_DG
    prob = Pv_max_plant_size(prob, ['DG', num2str(g)], Pv, Pv_max, DG_obj{g}.PowRated, P_DG(:, :, n_DG), delta_DG_Pmax(:, :, n_DG), DG_obj{g}.PowRated, -1, epsilon); % Pv only if the DG is producing its maximum power
  end

end