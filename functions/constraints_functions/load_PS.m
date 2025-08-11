function Pload_PS = load_PS(Pload, Pps_rem, Pps_add)
  % define how the load should be reshaped
  Pload_PS = Pload - Pps_rem + Pps_add; % Load after the load shifting mechanism
end