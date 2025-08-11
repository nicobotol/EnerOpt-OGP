function write_results_on_table_ParamVariation(alphabet, sol, min_value, CO2_emitted, time, case_sim_vec, sweep_vec, file_name, caption, label)

  % alphabet -> letters
  % sol -> values_solution
  % num_sim -> case
  % min_value -> values_minvalue
  
  num_sim = size(case_sim_vec, 2);

  % open a .tex file
  f_name = strcat(file_name, '.tex');
  fid = fopen(f_name, 'w');
  fprintf(fid, '\\begin{table*}[h]\n');
  fprintf(fid, '\\caption{%s}\n', caption);
  fprintf(fid, '\\centering\n');
  fprintf(fid, '\\begin{tabular}{ccccccccccccc}\n');
  fprintf(fid, '\\toprule\n');
  fprintf(fid, 'Case & Factor & $CO_2$ & F & GT & PV & WT & WEC & TOT & $E_{BESS}$ & $P_{BESS}$ & $ P_{DG}$ & $ E_{DG}$ (\\%%)  \\\\ \n');
  fprintf(fid, ' & & $\\left[\\si{\\mega\\gram}\\right]$ & $\\left[\\text{M}\\$\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt\\hour}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt}\\right]$ & $\\left[\\si{\\mega\\watt\\hour}\\right]$ \\\\ \n');
  fprintf(fid, '\\midrule\n');
  % write the results 
  num_sweep = size(sweep_vec, 2);
  for j = 1:num_sim
    fprintf(fid,'\\multirow{%i}{*}{%s}', num_sweep, case_sim_vec{j} ); 
    for i=1:num_sweep
      alphabet_tmp = alphabet{i};
      CO2_emitted_tmp = CO2_emitted{1, i, j}/1e6;
      min_value_tmp = min_value{1, i, j}/1e6;
      P_GT_tmp = sol{1, i, j}.P_GT_inst;
      P_DG_tmp = sol{1, i, j}.P_DG_inst;
      P_PV_tmp = sol{1, i, j}.P_PV_inst;
      P_WT_tmp = sol{1, i, j}.P_WT_inst;
      P_WEC_tmp = sol{1, i, j}.P_WEC_inst;
      P_TOT_REC_tmp = sol{1, i, j}.P_TOT_REC;
      BESS_capacity = sol{1, i, j}.Ebt_max;
      x_ESS_NIV_tmp= sol{1, i, j}.x_ESS_NIV;
      Pv = max(sol{1, i, j}.Pv_max);
      Ev = sol{1, i, j}.Ev;
      E_frac = Ev / (sol{1, i, j}.Eload)*100;
      time_tmp = time{1, i, j};
      rel_gap_tol = sol{1, i, j}.min_info.relativegap;
      abs_gap_tol = sol{1, i, j}.min_info.absolutegap;

      P_PV_tmp = check_one(P_PV_tmp, 0.1, 1);
      P_WT_tmp = check_one(P_WT_tmp, 0.1, 1);
      P_WEC_tmp = check_one(P_WEC_tmp, 0.1, 1);
      BESS_capacity = check_one(BESS_capacity, 0.1, 1);
      x_ESS_NIV_tmp = check_one(x_ESS_NIV_tmp, 0.1, 1);
      rel_gap_tol = check_one(rel_gap_tol, 0, 0.1);
      % abs_gap_tol = check_one(abs_gap_tol, 0, 0.1);
      
      fprintf(fid, ' & %s & %.f & %.2f & %.f & %s & %s & %s & %.f & %s & %s & %.2f & %.f (%.1f)  \\\\ \n', alphabet_tmp, CO2_emitted_tmp, min_value_tmp, P_GT_tmp,  P_PV_tmp, P_WT_tmp, P_WEC_tmp, P_TOT_REC_tmp, BESS_capacity, x_ESS_NIV_tmp, Pv, Ev, E_frac); 
    end
    if j ~= num_sim
      fprintf(fid, '\\midrule\n');
    end
  end
  fprintf(fid, '\\bottomrule\n');
  fprintf(fid, '\\end{tabular}\n');
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