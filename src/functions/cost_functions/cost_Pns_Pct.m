function [qTy_w] = cost_Pns_Pct(Pns, Pct, T, load_scenarios)
  % cost related to the GTs

  % 1st stage variable cost
  
  % 2nd stage variable cost
  
  % cost of curtailed and not supplied power

  qTp = [load_scenarios.NS_cost*ones(T, 1)]';
  qTy_w = qTp*[Pns];

end
