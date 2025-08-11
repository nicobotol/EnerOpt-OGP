function prob = LPSP_target(prob, Pns, Pload, Pload_obj)
  % Load Power Supply Probability
  prob.Constraints.LPSP       = sum(sum(Pns)) <= Pload_obj.LPSP_target * sum(sum(Pload)); 
end