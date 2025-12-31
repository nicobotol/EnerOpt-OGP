function prob = Pv_power_constraint_linear(prob, Pv, Pv_max_inst, T, W, DG_obj, u_DG)
  % Limit the virtual power to the decision variable Pv_max_inst

  prob.Constraints.Pv_power_constraint = Pv <= Pv_max_inst;

  if ~isempty(DG_obj)
    if DG_obj{1}.Toff >= 1 
      prob = GT_offtime(prob, 1, T, W, DG_obj, u_DG);
    end
  end

end