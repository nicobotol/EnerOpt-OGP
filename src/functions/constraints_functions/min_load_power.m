function prob = min_load_power(prob, Pns, Pload_PS, Pload_min)
  % Power that should always be provided
  prob.Constraints.Pload_min  = Pload_PS - Pns >=  Pload_min; 
end