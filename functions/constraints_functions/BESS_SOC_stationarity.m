function prob = BESS_SOC_stationarity(prob, E0, Ebt, Pbt)

  prob.Constraints.Ebt_initial = Ebt(1, :) == E0;
  prob.Constraints.Ebt_dyn    = Ebt(2:end, :) == Ebt(1:end-1, :) - Pbt(1:end-1, :);

  prob.Constraints.Pbt_cycl   = sum(Pbt) == 0;
end