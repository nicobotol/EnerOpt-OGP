function prob = Pv_constraint(prob, Pv, Pv_max, Pload, Pload_obj, P_REC_max, x_REC, x_ESS_NIV, x_ESS_IV,  n_REC, REC_obj, P_GT, GT_obj, n_GT, Pv_max_inst, delta_Pv_max, delta_ESS_Pmax, delta_ESS_Emax, delta_GT_Pmax, delta_REC_Pmax, z_Pv_max, BAT, T, epsilon)
	
	% Use Pv only if the energy from resources is less than the one required by the load
	prob = Pv_energy_constraint(prob, n_REC, n_GT, T, Pv, Pv_max_inst, Pload, P_REC_max, P_GT, REC_obj, GT_obj, Pload_obj, delta_Pv_max, z_Pv_max, epsilon);
	
	prob = Pv_power_constraint(prob, n_GT, n_REC, x_REC, x_ESS_NIV, x_ESS_IV, Pv, Pv_max, GT_obj, REC_obj, BAT, P_GT, delta_GT_Pmax, delta_REC_Pmax, delta_ESS_Pmax, delta_ESS_Emax, epsilon);

end