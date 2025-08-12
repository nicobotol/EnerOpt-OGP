function prob = Pv_energy_constraint(prob, T, Pv, Pv_max_inst, x_Pv_max, P_max_feasibility, Pload_obj, delta_Pv_max, z_Pv_max, epsilon)

  % Constraints related to the conditions that should happen in order to have the virtual power Pv  

  name = ['Pv_delta'];
  condition = -x_Pv_max;
  m = -T*P_max_feasibility;
  M = T*Pload_obj.P_shaved_overpower*Pload_obj.P_rated;

  prob = IfOnlyIf_ContBin(prob, name, condition, delta_Pv_max, -m, -M, epsilon); % Set the binary variable delta to 1 if the load energy >= generator energy

  prob = lin_ContBin(prob, 'lin_Pvdelta_Pv_max', z_Pv_max, x_Pv_max, delta_Pv_max, 1e6, -1e6);
  % prob = lin_ContBin(prob, 'lin_Pvdelta_Pv_max', z_Pv_max, x_Pv_max, delta_Pv_max, M, m);
  % prob.Constraints.max_Pv_energy = sum(Pv) <= z_Pv_max ;

  % prob.Constraints.PvPch = Pv <= Pv_max_inst;

end