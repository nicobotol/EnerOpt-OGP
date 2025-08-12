function [opt_parameters] = set_opt_tollerance(case_sim, opt_parameters)
  % This function sets the optimization tollerance based on the simulation case
  switch case_sim
    case {'1GT+REC+DG'}
      opt_parameters.rel_gap_tol = 1.4e-2;
      opt_parameters.abs_gap_tol = 1e3;
    case {'1GT+WT+DG'}
      opt_parameters.rel_gap_tol = 2e-2;
      opt_parameters.abs_gap_tol = 1e3;
    otherwise
      opt_parameters.rel_gap_tol = 2e-2;
      opt_parameters.abs_gap_tol = 1e2;
  end

end