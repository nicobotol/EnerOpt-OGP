function [opt_parameters] = set_max_time(loop_type_2, opt_parameters, case_sim)
  % This function sets the optimization tolerance based on the simulation case

  switch case_sim
    case {'GT24', 'GT365', '1GT+WT+DG', '1GT+REC+DG', 'WT+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24','REC-C+DG365'}
      max_time = 8*3600;
  otherwise
    error('case not implemented yet')

  end

  opt_parameters.max_time = max_time;
end