function prob = power_balance_NL_model(prob, P_generators, Pch, Pdc, Pns, Pct, Pv, Pload_PS)
  % power balance
  prob.Constraints.pwr_bln    = P_generators + Pdc + Pns + Pv == Pload_PS + Pch + Pct;
end