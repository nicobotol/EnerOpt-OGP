function prob = PvDelta_constraint(prob, name, Pv, delta, Pv_max)
  % Impose that the virtual power is non zero only if the condition given by delta is satisfied

  prob.Constraints.(name) = Pv <= Pv_max*delta;

end