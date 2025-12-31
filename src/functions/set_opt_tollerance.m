function [opt_parameters] = set_opt_tollerance(case_sim, sweep_case, opt_parameters)
  % This function sets the optimization tollerance based on the simulation case and the type of sweep that is being performed
  

  switch sweep_case 
    case 'None'
      switch case_sim
        case {'1GT+REC+DG', '1GT+WT+DG'}
          opt_parameters.rel_gap_tol = 3.65e-2;
          opt_parameters.rel_gap_tol = 1e-2;
        case {'GT24', 'GT365'}
          opt_parameters.rel_gap_tol = 0.1e-2;
        case {'WT+DG'}
          opt_parameters.rel_gap_tol = 1e-2;
        case {'REC-U+DG', 'REC-U'}
          opt_parameters.rel_gap_tol = 0.5e-2;
          % opt_parameters.rel_gap_tol = 0.2e-2;
        case {'REC-C+DG24', 'REC-C+DG365'}
          opt_parameters.rel_gap_tol = 0.5e-2;
          % opt_parameters.rel_gap_tol = 0.05e-2;
        otherwise
          error('Case not set yet');
      end
    
    case 'PS'
      opt_parameters.rel_gap_tol = 0.5e-3;
    
    case 'PVCost'
      opt_parameters.rel_gap_tol = 1.76e-2;  % South China Sea
      opt_parameters.rel_gap_tol = 2.5e-2;  % South China Sea
      % opt_parameters.rel_gap_tol = 0.5e-2; % North sea
      opt_parameters.rel_gap_tol = 1.5e-2;
    
    case 'WECCost'
      opt_parameters.rel_gap_tol = 0.5e-2; % Norway
      % opt_parameters.rel_gap_tol = 1.4e-2; % South China Sea

    case 'Carbon_tax'
      switch case_sim
        case {'WT+DG'}
          opt_parameters.rel_gap_tol = 0.4e-2;
        otherwise
          opt_parameters.rel_gap_tol = 0.85e-2;
      end

    case 'beta'
      opt_parameters.rel_gap_tol = 1.75e-2;
      opt_parameters.rel_gap_tol = 0.5e-2;

    otherwise 
      error('case not defined yet')
  end
  
end