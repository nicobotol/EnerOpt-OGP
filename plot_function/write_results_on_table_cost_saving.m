function write_results_on_table_cost_saving(alphabet, sol, min_value, sweep_vec, num_sim, file_name, caption, label)

  % alphabet -> letters
  % sol -> values_solution
  % num_sim -> num_sim
  % min_value -> values_minvalue

  % open a .tex file
  f_name = strcat(file_name, '.tex');
  fid = fopen(f_name, 'w');
  fprintf(fid, '\\begin{table}[h]\n');
  fprintf(fid, '\\caption{%s}\n', caption);
  fprintf(fid, '\\centering\n');
  columns_num = repmat('c', 1, num_sim);
  fprintf(fid, '\\begin{tabular}{c|%s}\n', columns_num);
  fprintf(fid, '\\toprule\n');

  fprintf(fid, ' PS \\%% & ');
  for c=1:size(sol{1}, 3)
    if c < size(sol{1}, 3)
      fprintf(fid, '%s & ', alphabet{c});
    else
      fprintf(fid, ' %s \\\\ \n ', alphabet{c});
    end
  end
  
  %% Cost and cost reduction (percentage)
  % for r=1:size(sol{1}, 2)
  %   fprintf(fid, '%.1f & ', sweep_vec(r)*100);
  %   for c=1:size(sol{1}, 3)
  %     cost = min_value{1}{1, r, c}/1e6; % cost of the solution
  %     cost_red = (min_value{1}{1, r, c} - min_value{1}{1, 1, c})/min_value{1}{1, 1, c}*100; % cost reduction wrt the case with PS=0%
  %     if c < size(sol{1}, 3)
  %       fprintf(fid, '%.0f (%.1f) & ', cost, cost_red);
  %     else
  %       fprintf(fid, '%.0f (%.1f) \\\\ \n', cost, cost_red);
  %     end
  %   end
  % end

  %% Cost reduction (percentage)
  for r=1:size(sol{1}, 2)
    fprintf(fid, '%.0f & ', sweep_vec(r)*100);
    for c=1:size(sol{1}, 3)
      cost_red = (min_value{1}{1, r, c} - min_value{1}{1, 1, c})/min_value{1}{1, 1, c}*100; % cost reduction wrt the case with PS=0%
      if c < size(sol{1}, 3)
        fprintf(fid, '%.2f & ', cost_red);
      else
        fprintf(fid, '%.2f \\\\ \n', cost_red);
      end
    end
  end

  fprintf(fid, '\\bottomrule\n');
  fprintf(fid, '\\end{tabular}\n');
  fprintf(fid, '\\label{tab:%s}\n', label);
  fprintf(fid, '\\end{table}\n');
  fclose(fid);
end