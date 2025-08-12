% This function displays the result of the optimization on terminal
function display_results(min_values, minimized_cost, PV, WT, WEC, i, j, write_on_file)
  n_PV  = min_values.x_REC(1);
  n_WT  = min_values.x_REC(2);
  n_WEC = min_values.x_REC(3);
  P_PV  = min_values.x_REC(1) * PV.PowRated * 1e-6;
  P_WT  = min_values.x_REC(2) * WT.PowRated * 1e-6;
  P_WEC = min_values.x_REC(3) * WEC.PowRated * 1e-6;

  fprintf('======== RESULTS SIM %d SEED %d ========\n', j, i);
  fprintf('PV:  \t %d \t (%.2f [MW])  \n',  n_PV,   P_PV);
  fprintf('WT:  \t %d \t (%.2f [MW])  \n',  n_WT,   P_WT);
  fprintf('WEC: \t %d \t (%.2f [MW])  \n',  n_WEC,  P_WEC);
  fprintf('ESS energy:\t %.2f [MWh]\n',     min_values.x_ESS_IV / 1e6);
  fprintf('ESS power:\t %.2f [MW]\n',       min_values.x_ESS_NIV / 1e6);
  fprintf('Total installed power (PV+WT+WEC): %.2f [MW]\n', P_PV + P_WT + P_WEC);
  fprintf('Cost of the minimization: %.2f [M$]\n', minimized_cost/1e6);
  fprintf('=======================================\n');

  if write_on_file.flag == 1
    fileID = fopen(write_on_file.name, 'a');

    % Write the formatted content to the file
    fprintf(fileID, '======== RESULTS SIM %d SEED %d ========\n', j, i);
    fprintf(fileID, 'PV:  \t %d \t (%.2f [MW])  \n',  n_PV,   P_PV);
    fprintf(fileID, 'WT:  \t %d \t (%.2f [MW])  \n',  n_WT,   P_WT);
    fprintf(fileID, 'WEC: \t %d \t (%.2f [MW])  \n',  n_WEC,  P_WEC);
    fprintf(fileID, 'ESS energy:\t %.2f [MWh]\n',     min_values.x_ESS_IV / 1e6);
    fprintf(fileID, 'ESS power:\t %.2f [MW]\n',       min_values.x_ESS_NIV / 1e6);
    fprintf(fileID, 'Total installed power (PV+WT+WEC): %.2f [MW]\n', P_PV + P_WT + P_WEC);
    fprintf(fileID, 'Cost of the minimization: %.2f [M$]\n', minimized_cost/1e6);
    fprintf(fileID, '=======================================\n');

    % Close the file
    fclose(fileID);
  end
end