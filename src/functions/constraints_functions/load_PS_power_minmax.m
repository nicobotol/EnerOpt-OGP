function prob = load_PS_power_minmax(prob, Pps_add, Pps_rem, Pload_obj)
  % Constraint on the maximum and minimum power reshaped
  prob.Constraints.Pps_add_max = Pps_add <= Pload_obj.P_shaved_frac*Pload_obj.P_rated;
  prob.Constraints.Pps_rem_max = Pps_rem <= Pload_obj.P_shaved_frac*Pload_obj.P_rated;
end