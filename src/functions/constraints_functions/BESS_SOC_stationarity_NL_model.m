function prob = BESS_SOC_stationarity_NL_model(prob, name, E0, Ebt, Pch, Pdc)
  % prob.Constraints.Ebt_dyn    = Ebt(1:end, :) == E0 + cumsum(Pch(1:end, :) - Pdc(1:end, :));

  prob.Constraints.([name, '_initial']) = Ebt(1, :) == E0;
  prob.Constraints.([name, '_dyn'])    = Ebt(2:end, :) == Ebt(1:end-1, :) + Pch(1:end-1, :) - Pdc(1:end-1, :);
  
  prob.Constraints.([name, '_cycl'])    = sum(Pch - Pdc) == 0;

end