function prob = load_PS_energy(prob, Pps_add, Pps_rem)
  prob.Constraints.sum_shifted_power  = sum(Pps_add - Pps_rem) == 0;
end