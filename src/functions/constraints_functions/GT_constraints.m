function prob = GT_constraints(prob, n_GT, T, W, GT_obj, u_GT, z_GT, x_GT, P_GT, RR, z_help, case_constraint)
% Constraints related to the GT

  switch case_constraint
    case  {'GT24','GT365'}
      prob = GT_offtime(prob, n_GT, T, W, GT_obj, u_GT);
      prob = GT_startUP(prob, n_GT, T, W, z_GT, u_GT);
      prob = GT_P_minmax(prob, n_GT, T, W, P_GT, x_GT, GT_obj, u_GT, z_help);
      prob = GT_rump_UP(prob, n_GT, T, W, P_GT, GT_obj);
      prob = GT_rump_UP_cost_constraint(prob, n_GT, T, W, P_GT, RR); 

    case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'}
      prob = GT_offtime(prob, n_GT, T, W, GT_obj, u_GT);
      prob = GT_startUP(prob, n_GT, T, W, z_GT, u_GT);
      prob = GT_P_minmax_fix_GT_number(prob, n_GT, T, W, P_GT, GT_obj, u_GT);
      prob = GT_rump_UP(prob, n_GT, T, W, P_GT, GT_obj);
      prob = GT_rump_UP_cost_constraint(prob, n_GT, T, W, P_GT, RR); 

  end

end