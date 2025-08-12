function prob = Pv_power_constraint(prob, Pv, Pv_max_inst, u_Pv, zeta_Pv, Pv_max)
  % Limit the virtual power to the decision variable Pv_max_inst, considering also to have the DG operating or not

  prob.Constraints.Pv_power_constraint = Pv <= zeta_Pv; %Pv_max_inst*u_Pv;
  prob = lin_ContBin(prob, 'Pv_zeta_Pv', zeta_Pv, Pv_max_inst, u_Pv, Pv_max, 0);

end