function [REC_tmp] = do_power(REC_tmp, ResselScens_N)
  % This function computes the power of the converters based on the environmental data
  REC_tmp.WT.WindValue            = ResselScens_N{1};
  REC_tmp.PV.RadiationValue       = ResselScens_N{2};
  REC_tmp.WEC.SWH                 = ResselScens_N{3};
  REC_tmp.WEC.W_period            = ResselScens_N{4};

  REC_tmp.WT.DoWindPower;
  REC_tmp.WT.Power(REC_tmp.WT.Power < 1e-5) = 1e-5;
  
  REC_tmp.PV.DoPVPower;
  REC_tmp.PV.Power(REC_tmp.PV.Power<=1e-8) = 1e-8;
  
  REC_tmp.WEC.PowRated  = REC_tmp.WEC.WEC_coefficient*max(REC_tmp.WEC.PowerMatrix, [], 'all');
  REC_tmp.WEC.DoWECPowerCorpower; 
  
end