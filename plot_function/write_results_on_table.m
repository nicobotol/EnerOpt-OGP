function write_results_on_table(alphabet, sol, min_value, CO2_emitted, time, num_sim, file_name, caption, label)

  % alphabet -> letters
  % sol -> values_solution
  % num_sim -> num_sim
  % min_value -> values_minvalue

  % open a .tex file
  f_name = strcat(file_name, '.tex');
  fid = fopen(f_name, 'w');
  fprintf(fid, '\\begin{table*}[h]\n');
  fprintf(fid, '\\caption{%s}\n', caption);
  fprintf(fid, '\\centering\n');
  fprintf(fid, '\\resizebox{\\textwidth}{!}{\n');
  fprintf(fid, '\\begin{tabular}{ccccccccccccccc}\n');
  fprintf(fid, '\\toprule\n');
  fprintf(fid, 'Case & $CO_2$ & F & GT & PV & WT & WEC & TOT & $\bar{E}$ & $\bar{P}_{BESS}$ & $ \bar{P}_{DG}$ & $ \\frac{E_{DG}}{E_{LOAD}}$ & Time & RGT & AGT \\\\ \n');
  fprintf(fid, ' & $\\left[\\si{\\mega\\gram}\\right]$ & $\\left[\\text{M}\\$\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt\\hour}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\%%\\right]$ & $\\left[\\si{\\second}\\right]$ & $\\left[\\%%\\right]$ & $\\left[\\$\\right]$\\\\ \n');
  fprintf(fid, '\\midrule\n');
  % write the results 
  for i=1:num_sim
    alphabet_tmp = alphabet{i};
    CO2_emitted_tmp = CO2_emitted{i}/1e6;
    min_value_tmp = min_value{i}/1e6;
    P_GT_tmp = sol{i}.P_GT_inst;
    P_DG_tmp = sol{i}.P_DG_inst;
    P_PV_tmp = sol{i}.P_PV_inst;
    P_WT_tmp = sol{i}.P_WT_inst;
    P_WEC_tmp = sol{i}.P_WEC_inst;
    P_TOT_REC_tmp = sol{i}.P_TOT_REC;
    BESS_capacity = sol{i}.Ebt_max;
    x_ESS_NIV_tmp= sol{i}.x_ESS_NIV;
    Pv = max(sol{i}.Pv_max);
    Ev = sol{i}.Ev;
    E_frac = Ev / (sol{i}.Eload)*100;
    time_tmp = time{i};
    rel_gap_tol = sol{i}.min_info.relativegap;
    abs_gap_tol = sol{i}.min_info.absolutegap;

    P_PV_tmp = check_one(P_PV_tmp, 0.1, 1);
    P_WT_tmp = check_one(P_WT_tmp, 0.1, 1);
    P_WEC_tmp = check_one(P_WEC_tmp, 0.1, 1);
    BESS_capacity = check_one(BESS_capacity, 0.1, 1);
    x_ESS_NIV_tmp = check_one(x_ESS_NIV_tmp, 0.1, 1);
    rel_gap_tol = check_one(rel_gap_tol, 0, 0.1);
    % abs_gap_tol = check_one(abs_gap_tol, 0, 0.1);
    
    fprintf(fid, '%s & %.f & %.3f & %.f & %s & %s & %s & %.f & %s & %s & %.2f & %.1f & %.f & %s & %.f \\\\ \n', alphabet_tmp, CO2_emitted_tmp, min_value_tmp, P_GT_tmp,  P_PV_tmp, P_WT_tmp, P_WEC_tmp, P_TOT_REC_tmp, BESS_capacity, x_ESS_NIV_tmp, Pv, E_frac, time_tmp, rel_gap_tol, abs_gap_tol); 
  end
  fprintf(fid, '\\bottomrule\n');
  fprintf(fid, '\\end{tabular}\n');
  fprintf(fid, '}\n');
  fprintf(fid, '\\label{tab:%s}\n', label);
  fprintf(fid, '\\end{table*}\n');
  fclose(fid);
end


function str = check_one(num, l_th, u_th)
  if num < u_th && num >= l_th
    str = ['$\leq $', num2str(u_th)];
  else 
    str = num2str(num, '%.1f');
  end
end