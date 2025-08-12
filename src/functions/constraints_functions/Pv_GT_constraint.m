function prob = Pv_GT_constraint(prob, n_GT, Pv, Pv_max, GT_obj, P_GT, delta_GT_Pmax, epsilon)
% Use the Pv only if the GT installed power is maximum

  for g=1:n_GT
    prob = Pv_max_plant_size(prob, ['GT', num2str(g)], Pv, Pv_max, GT_obj{g}.PowRated, P_GT(:, :, g), delta_GT_Pmax(:,:,g), 1.1*GT_obj{g}.PowRated, -1, epsilon); % Pv only if the GT is producing its maximum power
  end

end