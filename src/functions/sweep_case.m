function [REC, load_scenarios, opt_parameters] = sweep_case(loop_type_1, loop_vec_1, loop_type_2, loop_vec_2, a, b, REC, base_CO2_tax, CAPEX_ref, OPEX_ref, load_scenarios_old, opt_parameters_old)
  % This function sets the parameters according to the different kind of sweep that should be performed 

  % Initialize the values that don't have to be changed
  opt_parameters = opt_parameters_old;
  opt_parameters.alpha          = 0;
  opt_parameters.beta           = 0;
  load_scenarios = load_scenarios_old;
  load_scenarios.LPSP_target    = 0;
  load_scenarios.P_shaved_frac  = 0;

  switch loop_type_1
    case {'None', 'scenario_num', 'scenario_len'}

    case 'alpha'
      opt_parameters.alpha = loop_vec_1(a);
      
    otherwise
      error('Unknown sweep type') 
  end



  switch loop_type_2
    case {'None', 'seed'}

    case 'beta'
      opt_parameters.beta = loop_vec_2(b);

    case 'LPSP'
      load_scenarios.LPSP_target = loop_vec_2(b);

    case 'PS'
      load_scenarios.P_shaved_frac = loop_vec_2(b);

    case 'Carbon_tax'
      for g=1:REC.GT.n_NREC
        REC.GT.GT_obj{g}.C_CO2 = loop_vec_2(b)*base_CO2_tax; % tax per kg of CO2 [$/kg]
        REC.GT.GT_obj{g}.ComputeCosts;
      end
      for d=1:REC.DG.n_NREC
        REC.DG.DG_obj{d}.C_CO2 = loop_vec_2(b)*base_CO2_tax; % tax per kg of CO2 [$/kg]
        REC.DG.DG_obj{d}.ComputeCosts;
      end
      REC.DGv.DGv_obj{1}.C_CO2 = loop_vec_2(b)*base_CO2_tax; % tax per kg of CO2 [$/kg]
      REC.DGv.DGv_obj{1}.ComputeCosts;
    
    case 'DGpower'
      for d=1:REC.DG.n_NREC
        REC.DG.DG_obj{d}.PowRated     = loop_vec_2(b)*REC.DG.DG_obj{d}.base_power;   % Rated power of the GT [W]
        REC.DG.DG_obj{d}.R            = REC.DG.DG_obj{d}.PowRated*60;               % Ramping rate
        REC.DG.DG_obj{d}.ComputeCosts;
      end

    case 'PVCost'
      REC.PV.C_CAPEX  = CAPEX_ref*loop_vec_2(b);
      REC.PV.C_OPEX   = OPEX_ref*loop_vec_2(b);
    
    case 'WECCost'
      REC.WEC.C_CAPEX  = CAPEX_ref*loop_vec_2(b);
      REC.WEC.C_OPEX   = OPEX_ref*loop_vec_2(b);

    otherwise
      error('Unknown sweep type')

  end

  % write which loop is performed
  opt_parameters.loop_type_2 = loop_type_2;

end