function prob = load_PS_minmax(prob, Pload_PS, Pload_obj)
  prob.Constraints.min_load = Pload_PS >= Pload_obj.NS_fraction*Pload_obj.P_rated;
  prob.Constraints.max_load = Pload_PS <= Pload_obj.P_shaved_overpower*Pload_obj.P_rated; % Max power not exceed the rated power too much 
end