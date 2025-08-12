function Pload_min = load_PS_min(Pload_obj)
  % Minimum load power that should always be provided
  Pload_min = Pload_obj.NS_fraction*Pload_obj.P_rated; 
end