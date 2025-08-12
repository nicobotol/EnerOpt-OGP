function write_results_on_table_cost_saving_horizontal(alphabet, sol, min_value, sweep_vec, num_sim, file_name, caption, label)

  % Open a .tex file
  f_name = strcat(file_name, '.tex');
  fid = fopen(f_name, 'w');
  fprintf(fid, '\\begin{table}[h]\n');
  fprintf(fid, '\\caption{%s}\n', caption);
  fprintf(fid, '\\centering\n');
  columns_num = repmat('c', 1, length(sweep_vec)); % Additional column for labels
  fprintf(fid, '\\begin{tabular}{c|%s}\n', columns_num);
  fprintf(fid, '\\toprule\n');
  
  % Header row
  fprintf(fid, 'PS \\%% ');
  for r = 1:length(sweep_vec)
    fprintf(fid, '& %.3f ', sweep_vec(r));
  end
  fprintf(fid, '\\\\ \n');
  fprintf(fid, '\\midrule\n');
  
  % Horizontal table with cost reduction percentages
  for c = 1:size(sol{1}, 3)
    fprintf(fid, '%s ', alphabet{c});
    for r = 1:length(sweep_vec)
      cost_red = (min_value{1}{1, r, c} - min_value{1}{1, 1, c}) / min_value{1}{1, 1, c} * 100;
      fprintf(fid, '& %.2f ', cost_red);
    end
    fprintf(fid, '\\\\ \n');
  end

  fprintf(fid, '\\bottomrule\n');
  fprintf(fid, '\\end{tabular}\n');
  fprintf(fid, '\\label{tab:%s}\n', label);
  fprintf(fid, '\\end{table}\n');
  fclose(fid);
end
