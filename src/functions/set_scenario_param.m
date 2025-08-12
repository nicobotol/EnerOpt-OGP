function scenario = set_scenario_param(scenario, case_sim, use_generate_dataseries, loop_type_1, h)

  if use_generate_dataseries == 1
    scenario.hours_start  = 0;
    scenario.hours_stop   = scenario.InScenNum * scenario.T_copula - 1; 
  end

  % This functions set the values related to the scenario             
  scenario.d_o        = 1/365; % scaling factor from annual to daily cost 
  scenario.tau        = 1; % minimum time resolution for the optimization problem (in hours)
  scenario.h_star     = 24; % time horizon for the optimization problem (in hours)
 
  switch case_sim
    case {'GT24', '1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG', 'GT+REC+DG', 'WT+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24', 'DG+REC24'}
      if strcmp(loop_type_1, 'scenario_len')
        scenario.h = h;
      else
        scenario.h          = 24; % time horizon for the optimization problem (in hours)
      end
      scenario.T          = scenario.h/scenario.tau;   % numbers of unit of time in a scenario
      
    case {'GT365', 'REC-C+DG365', 'DG+REC365'}
      scenario.h          = (scenario.hours_stop - scenario.hours_start + 1); % time horizon for the optimization problem (in hours)
      scenario.T          = scenario.h/scenario.tau;   % numbers of unit of time in a scenario
      
    otherwise
      error('Case not implemented yet!')
  end
        
  switch scenario.simulation_type
      case 1 % optimize 1st and 2nd stages
        scenario.W          = floor((scenario.hours_stop - scenario.hours_start + 1)/scenario.h); % number of scenarios
      case 2 % optimization only 2nd stage considering one day long operation
        scenario.h          = (scenario.hours_stop - scenario.hours_start + 1); % time horizon for the optimization problem (in hours)
        scenario.T          = scenario.h/scenario.tau;   % numbers of unit of time in a scenario
        scenario.W = 1;
      otherwise
        error('Case not implemented yet!')
  end
end