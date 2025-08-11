function prob = BESS_SOC_stationarity_NL_model(prob, E0, Ebt, Pch, Pdc, tau)
  % prob.Constraints.Ebt_dyn    = Ebt(1:end, :) == E0 + cumsum(Pch(1:end, :) - Pdc(1:end, :));

  prob.Constraints.Ebt_initial = Ebt(1, :) == E0;
  prob.Constraints.Ebt_dyn    = Ebt(2:end, :) == Ebt(1:end-1, :) + (Pch(1:end-1, :) - Pdc(1:end-1, :)) * tau;
  
  prob.Constraints.Pbt_cycl   = sum(Pch - Pdc) == 0;

end