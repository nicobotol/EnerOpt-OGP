% Compute the installed power in any case
values_solution.P_GT_inst = 0;
values_solution.P_PV_inst = 0;
values_solution.P_WT_inst = 0;
values_solution.P_WEC_inst = 0;
values_solution.P_DG_inst = 0;
values_solution.P_TOT_REC = 0;
switch case_constraint
  case {'GT24', 'GT365'} % GT only
    for g = 1:REC.GT.n_NREC
      values_solution.P_GT_inst = values_solution.P_GT_inst + values_solution.x_GT(g)*GT_obj{g}.PowRated;
    end
    values_solution.x_ESS_IV = 0;
    values_solution.x_ESS_NIV = 0;
  
  case {'1GT+WT+DG'} % 1 GT + WT + BESS
    values_solution.P_GT_inst = GT_obj{1}.PowRated;
    values_solution.P_WT_inst = values_solution.x_REC(1)*REC.WT.PowRated;
  
  case {'2GT+WT+DG'} % 2 GT + WT + BESS
    values_solution.P_GT_inst = 2*GT_obj{1}.PowRated;
    values_solution.P_WT_inst = values_solution.x_REC(1)*REC.WT.PowRated;

  case {'1GT+REC+DG'} % 1 GT + REC + BESS
    values_solution.P_GT_inst = GT_obj{1}.PowRated;
    values_solution.P_PV_inst = values_solution.x_REC(1)*REC.PV.PowRated;
    values_solution.P_WT_inst = values_solution.x_REC(2)*REC.WT.PowRated;
    values_solution.P_WEC_inst = values_solution.x_REC(3)*REC.WEC.PowRated;

  case {'2GT+REC+DG'} % 1 GT + REC + BESS
    values_solution.P_GT_inst = 2*GT_obj{1}.PowRated;  
    values_solution.P_PV_inst = values_solution.x_REC(1)*REC.PV.PowRated;
    values_solution.P_WT_inst = values_solution.x_REC(2)*REC.WT.PowRated;
    values_solution.P_WEC_inst = values_solution.x_REC(3)*REC.WEC.PowRated;
    
  case{'WT+DG'}
    values_solution.P_WT_inst = values_solution.x_REC(1)*REC.WT.PowRated;

  case {'REC-U', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365'}
    values_solution.P_PV_inst = values_solution.x_REC(1)*REC.PV.PowRated;
    values_solution.P_WT_inst = values_solution.x_REC(2)*REC.WT.PowRated;
    values_solution.P_WEC_inst = values_solution.x_REC(3)*REC.WEC.PowRated;
    
  case {'DG+REC24', 'DG+REC365'}
    for g = 1:REC.DG.n_NREC
      values_solution.P_DG_inst = values_solution.P_DG_inst + values_solution.x_DG(g)*DG_obj{g}.PowRated;
    end 
    values_solution.P_PV_inst = values_solution.x_REC(1)*REC.PV.PowRated;
    values_solution.P_WT_inst = values_solution.x_REC(2)*REC.WT.PowRated;
    values_solution.P_WEC_inst = values_solution.x_REC(3)*REC.WEC.PowRated;

  otherwise
    error('Case not defined')
end
values_solution.P_TOT_REC = values_solution.P_PV_inst + values_solution.P_WT_inst + values_solution.P_WEC_inst;

% maximum virtual power
if isfield(values_solution, 'P_DGv')
  values_solution.P_DGv_max = max(values_vector.P_DGv, [], 'all'); 
  values_solution.Ev = sum(values_vector.P_DGv*scenario.tau, 'all');
else
  values_solution.P_DGv_max = 0;
  values_solution.Ev = 0;
end

