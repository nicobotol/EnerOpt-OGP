function prob = max_power(prob, name, value, bound)
  % generic upper bound
  prob.Constraints.(name) = value <= bound;
end