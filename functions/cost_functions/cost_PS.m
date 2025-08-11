function [qTy_w] = cost_PS(Pps_add, Pps_rem, T, load_scenarios)
  % cost related to the DR program

  qTp = [load_scenarios.Pps_add_cost*ones(T, 1); load_scenarios.Pps_rem_cost*ones(T, 1)]';
  qTy_w = qTp*[Pps_add;Pps_rem];

end
