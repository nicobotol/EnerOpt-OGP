function prob = Pv_max_plant_size(prob, cstr_name, Pv, Pv_max, PowRated, Pow, delta, M,  m, epsilon )
  % Impose the constrain that there is virtual power iff the plant reaches the maximum size
  % prob -> optimproblem
  % cstr_name -> constraint name
  % Pv -> Virtual power
  % Pv_max -> Maximum virtual power
  % PowRated -> Rated power of the generator
  % Pow -> Power output of the generator
  % delta -> binary variable, delta=1 <=> Pow = PowRated 
  % epsilon -> tolerance
  
  name = [cstr_name, '_delta'];
  condition = PowRated - Pow;
  prob = IfOnlyIf_ContBin(prob, name, condition, delta, M, m, epsilon); % Set the binary variable delta to 1 if the generator is producing its maximum power

  name_2 = [cstr_name, '_PvDelta'];
  prob = PvDelta_constraint(prob, name_2, Pv, delta, Pv_max); % have Pv iff the generator is producing its maximum power

end