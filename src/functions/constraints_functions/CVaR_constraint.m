function prob = CVaR_constraint(prob, cvar_zeta, cvar_s, cTx, qTy_w, gamma, wTz)

  % % cvar constraints
  % for w = 1:num_scenarios
  %   cvarCnstr(w) = cTx + gamma*sum(sum(BAT.C_charge*Pch(:,w) + BAT.C_discharge*Pdc(:,w) + DL.C_OeM*Pct(:,w) + Pload_obj.NS_cost*Pns(:,w) + Pload_obj.Pps_add_cost*Pps_add(:,w) + Pload_obj.Pps_rem_cost*Pps_rem(:,w))) - cvar_zeta <= cvar_s(w);
  % end

  % prob.Constraints.cvarCnstr  = cvarCnstr;

  cvarCnstr =  (cTx + wTz + gamma*qTy_w') - cvar_zeta <= cvar_s;

  prob.Constraints.cvarCnstr  = cvarCnstr;
end