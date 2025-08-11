CO2_emitted = 0;
CO2_emitted_GT = 0;
CO2_emitted_DG = 0;
CO2_emitted_Pv = 0;
switch case_constraint
  case {'GT24', 'GT365', '1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'} % cases with GT
    CO2_emitted_GT = CO2_emission(GT_obj, REC.GT.n_NREC, values_vector.P_GT,  values_vector.u_GT);
    % Virtual power
    CO2_emitted_Pv = CO2_emission(DGv_obj, REC.DGv.n_NREC, values_vector.P_DGv,  zeros(size(values_vector.P_DGv)));

  case {'WT+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365'} % cases with only REC
    % Virtual power
    CO2_emitted_Pv = CO2_emission(DGv_obj, REC.DGv.n_NREC, values_vector.P_DGv,  zeros(size(values_vector.P_DGv)));

  case {'DG+REC24', 'DG+REC365'} % cases with GT and DG
    CO2_emitted_DG = CO2_emission(DG_obj, REC.DG.n_NREC, values_vector.P_DG,  zeros(size(values_vector.P_DG)));

    % Virtual power
    CO2_emitted_Pv = CO2_emission(DGv_obj, REC.DGv.n_NREC, values_vector.P_DGv,  zeros(size(values_vector.P_DGv)));

  otherwise
    error('Case name not implemented yet\n');
      
end
CO2_emitted = CO2_emitted_GT + CO2_emitted_DG + CO2_emitted_Pv;
values_solution.CO2_emitted = CO2_emitted;
values_solution.CO2_emitted_GT = CO2_emitted_GT;
values_solution.CO2_emitted_DG = CO2_emitted_DG;
values_solution.CO2_emitted_Pv = CO2_emitted_Pv;  