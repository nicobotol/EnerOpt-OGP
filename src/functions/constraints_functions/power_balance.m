function prob = power_balance(prob, P_generators, Pbt, Pns, Pct, Pv, Pload_PS)
  % power balance
  prob.Constraints.pwr_bln    = P_generators  + Pns + Pv + Pbt == Pload_PS + Pct ;
end