% close all; clc;

%   ____    _  _____   _____                            
%  | __ )  / \|_   _| | ____|_ __   ___ _ __ __ _ _   _ 
%  |  _ \ / _ \ | |   |  _| | '_ \ / _ \ '__/ _` | | | |
%  | |_) / ___ \| |   | |___| | | |  __/ | | (_| | |_| |
%  |____/_/   \_\_|   |_____|_| |_|\___|_|  \__, |\__, |
%                                           |___/ |___/ 
name = {'with freq. constraints', 'without freq. constraints'};
line_style = {'-', '--'};
figure(); hold on; grid on;
for j=1:size(T_vec, 2)
  for i=1:2
    pl_ES = plot(min_values_vector_store{j}{i}.Ebt/min_values_store{j}{i}.Ebt_max);
    pl_ES.LineWidth = plot_param.line_width;
    pl_ES.DisplayName =  name{i};
    pl_ES.Color = color(j);
    pl_ES.LineStyle = line_style{i};

    %% Plot the energy reserve 
    % if i == 1
    %   pl_ES_upper = plot(min_values_vector{i}.E_ES_upper/min_values{i}.Ebt_max);
    %   pl_ES_upper.LineWidth = plot_param.line_width;
    %   pl_ES_upper.DisplayName = 'Freq reserve';
    %   pl_ES_upper.Color = color(i);
    %   pl_ES_upper.LineStyle = '--';
      
    %   pl_ES_lower = plot(min_values_vector{i}.E_ES_lower/min_values{i}.Ebt_max);
    %   pl_ES_lower.LineWidth = plot_param.line_width;
    %   pl_ES_lower.DisplayName = name{i};
    %   pl_ES_lower.Color = color(i);
    %   pl_ES_lower.LineStyle = '--';
    %   pl_ES_lower.HandleVisibility = 'off';
      
    %   x_tmp = 1:1:size(min_values_vector{i}.Ebt, 1);
    %   x_axis = [x_tmp, flip(x_tmp)]';
    %   inBetween = [min_values_vector{i}.E_ES_upper/min_values{i}.Ebt_max; flip(min_values_vector{i}.E_ES_lower/min_values{i}.Ebt_max)];
    %   fill_energy = fill(x_axis, inBetween, color(i));  % plot filled area
    %   fill_energy.FaceAlpha = 0.1;
    %   fill_energy.DisplayName = 'Freq reserve';
    %   fill_energy.EdgeColor = 'none';
      
    % end

    yl = yline(min_values_store{j}{i}.E0/min_values_store{j}{i}.Ebt_max);
    yl.LineWidth = 0.5*plot_param.line_width;
    yl.Color = color(j);
    yl.LineStyle = '--';
    yl.DisplayName = 'Initial energy';
    yl.HandleVisibility = 'off';

  end
  xline(0:T_vec(j):scenario.InScenNum*scenario.T, '--', 'Color', color(j), 'LineWidth', 0.5*plot_param.line_width, 'HandleVisibility', 'off' )
end
title('Battery energy', 'FontSize', plot_param.font_size);
ylabel('[%]')
xlabel('Time [h]')
legend();

figure(); hold on; grid on;
for j=1:size(T_vec, 2)
  for i=1:2
    pl_ES = plot(min_values_vector_store{j}{i}.Ebt);
    pl_ES.LineWidth = plot_param.line_width;
    pl_ES.DisplayName =  name{i};
    pl_ES.Color = color(j);
    pl_ES.LineStyle = line_style{i};
    yl_max = yline(min_values_store{j}{i}.Ebt_max);
    yl_max.LineWidth = 0.5*plot_param.line_width;
    yl_max.Color = color(i);
    yl_max.LineStyle = '--';
    yl_max.DisplayName = 'Battery size max';
    yl_min = yline(min_values_store{j}{i}.Ebt_min);
    yl_min.LineWidth = 0.5*plot_param.line_width;
    yl_min.Color = color(j);
    yl_min.LineStyle  = line_style{i};
    yl_min.DisplayName = 'Battery size min';
    yl_min.HandleVisibility = 'Off';
  end
  xline(0:T_vec(j):scenario.InScenNum*scenario.T, '--', 'Color', color(j), 'LineWidth', 0.5*plot_param.line_width, 'HandleVisibility', 'off' )
end
title('Battery energy', 'FontSize', plot_param.font_size);
ylabel('Energy in the battery [Wh]')
xlabel('Time [h]')
legend();

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|

figure(); hold on; grid on;
for i=1:2
  plot(min_values_vector{i}.Pload*1e-6, 'linewidth', plot_param.line_width);
end
title('Load power', 'FontSize', plot_param.font_size);
% xline(1:scenario.T:met_data_param.tot_dataset_item, 'r--', 'LineWidth', 0.5*plot_param.line_width, 'HandleVisibility', 'off' )
ylabel('[MW]')
xlabel('Time [h]')

%    ____ _                     _             
%   / ___| |__   __ _ _ __ __ _(_)_ __   __ _ 
%  | |   | '_ \ / _` | '__/ _` | | '_ \ / _` |
%  | |___| | | | (_| | | | (_| | | | | | (_| |
%   \____|_| |_|\__,_|_|  \__, |_|_| |_|\__, |
%                         |___/         |___/ 

figure(); hold on; grid on;
for j =1:size(T_vec, 2)
  for i=1:2
    pl = plot(min_values_vector_store{j}{i}.Pbt*1e-6);
    pl.LineWidth = plot_param.line_width;
    pl.DisplayName = 'Charging battery';
    pl.Color = color(j);
    pl.LineStyle = line_style{i};

  end
  % xline(1:T_vec(j):met_data_param.tot_dataset_item, 'r--', 'LineWidth', 0.5*plot_param.line_width, 'HandleVisibility', 'off' )
end
legend();
title('Battery power', 'FontSize', plot_param.font_size);
ylabel('[MW]')
xlabel('Time [h]')

%    ____           _        _ _          _ 
%   / ___|   _ _ __| |_ __ _(_) | ___  __| |
%  | |  | | | | '__| __/ _` | | |/ _ \/ _` |
%  | |__| |_| | |  | || (_| | | |  __/ (_| |
%   \____\__,_|_|   \__\__,_|_|_|\___|\__,_|

figure(); hold on; grid on;
for j=1:size(T_vec, 2)
  for i=1:2
    pl = plot(min_values_vector_store{j}{i}.Pct*1e-6);
    pl.LineWidth = plot_param.line_width;
    pl.DisplayName = 'Curtailed';
    pl.Color = color(j);
    pl.LineStyle = line_style{i};
  end
  % xline(1:T_vec(j):met_data_param.tot_dataset_item, 'r--', 'LineWidth', 0.5*plot_param.line_width, 'HandleVisibility', 'off' )
end
legend();
ylabel('[MW]')
xlabel('Time [h]')

%   ____  _____ ____  
%  |  _ \| ____/ ___| 
%  | |_) |  _| \___ \ 
%  |  _ <| |___ ___) |
%  |_| \_\_____|____/ 

figure(); hold on; grid on;
for j=1:size(T_vec, 2)
  for i=1:1
    plot(min_values_vector_store{j}{i}.Pres*1e-6, '-', 'linewidth', plot_param.line_width, 'DisplayName', 'Total', 'Color', color(j));
    plot(min_values_vector_store{j}{i}.P_PV*1e-6, '--', 'linewidth', plot_param.line_width, 'DisplayName', 'PV', 'Color', color(j));
    plot(min_values_vector_store{j}{i}.P_WT*1e-6, '-.', 'linewidth', plot_param.line_width, 'DisplayName', 'WT', 'Color', color(j));
    plot(min_values_vector_store{j}{i}.P_WEC*1e-6, ':', 'linewidth', plot_param.line_width, 'DisplayName', 'WEC', 'Color', color(j));
  end
  plot(min_values_vector_store{j}{i}.Pload*1e-6, '-x', 'linewidth', plot_param.line_width, 'DisplayName', 'Load', 'Color', color(j));
  title('RES power', 'FontSize', plot_param.font_size);
  legend();
  % xline(1:scenario.T:met_data_param.tot_dataset_item, 'r--', 'LineWidth', 0.5*plot_param.line_width, 'HandleVisibility', 'off' )
end
ylabel('[MW]')
xlabel('Time [h]')

%   ____    _  _____        _                          
%  | __ )  / \|_   _|   ___| |__   __ _ _ __ __ _  ___ 
%  |  _ \ / _ \ | |    / __| '_ \ / _` | '__/ _` |/ _ \
%  | |_) / ___ \| |   | (__| | | | (_| | | | (_| |  __/
%  |____/_/   \_\_|    \___|_| |_|\__,_|_|  \__, |\___|
%                                           |___/      

figure(); hold on; grid on;
for j=1:size(T_vec, 2)
  for i=1:2
    plot(min_values_vector_store{j}{i}.Pch*1e-6, '-', 'linewidth', plot_param.line_width, 'DisplayName', 'Charging', 'Color', color(j));
    plot(min_values_vector_store{j}{i}.Pdc*1e-6, '--', 'linewidth', plot_param.line_width, 'DisplayName', 'Discharging', 'Color', color(j));
  end
end
title('Battery power', 'FontSize', plot_param.font_size);
legend();

%   _____                                    _      
%  | ____|_ __   ___ _ __ __ _ _   _   _ __ (_) ___ 
%  |  _| | '_ \ / _ \ '__/ _` | | | | | '_ \| |/ _ \
%  | |___| | | |  __/ | | (_| | |_| | | |_) | |  __/
%  |_____|_| |_|\___|_|  \__, |\__, | | .__/|_|\___|
%                        |___/ |___/  |_|           

energy_title = {'With freq. constraints', 'Without freq. constraints'};
figure(); 
tiledlayout(size(T_vec, 2), 2)
for j=1:size(T_vec, 2)
  for i=1:2
    nexttile
    data = [min_values_store{j}{i}.E_PV, min_values_store{j}{i}.E_WT, min_values_store{j}{i}.E_WEC];
    name = ["PV", "WT", "WEC"];
    piechart(data, name)
    title(energy_title{i})
  end
end
sgtitle('Energy source')

%    ____                       _ _            __            _   
%   / ___|__ _ _ __   __ _  ___(_) |_ _   _   / _| __ _  ___| |_ 
%  | |   / _` | '_ \ / _` |/ __| | __| | | | | |_ / _` |/ __| __|
%  | |__| (_| | |_) | (_| | (__| | |_| |_| | |  _| (_| | (__| |_ 
%   \____\__,_| .__/ \__,_|\___|_|\__|\__, | |_|  \__,_|\___|\__|
%             |_|                     |___/                      
%%
clear CF_mat
for j =1:size(T_vec, 2)
  CF_mat{1}(j, :) = [min_values_store{j}{1}.PV_CF, min_values_store{j}{1}.WT_CF, min_values_store{j}{1}.WEC_CF, min_values_store{j}{1}.Ect/min_values_store{j}{1}.E_REC, min_values_store{j}{1}.BAT_CF];
  CF_mat{2}(j, :) = [min_values_store{j}{2}.PV_CF, min_values_store{j}{2}.WT_CF, min_values_store{j}{2}.WEC_CF, min_values_store{j}{2}.Ect/min_values_store{j}{2}.E_REC, min_values_store{j}{2}.BAT_CF];

  CF_mat{1}(isnan(CF_mat{1})) = 0;
  CF_mat{2}(isnan(CF_mat{2})) = 0;
end
CF_name = ["PV", "WT", "WEC", "DUMP", "BESS"];
% CF_name = ["PV", "WT", "WEC", "$\frac{E_{ct}}{E_{REC}}$", "BESS"];

titles = {'With freq. constraints', 'Without freq. constraints'};
figure(); hold on; grid on;
for i=1:2
  subplot(1, 2, i)
  b = bar(CF_name, CF_mat{i});
  ax = gca;
  ax.FontSize = plot_param.font_size;
  ax.TickLabelInterpreter = 'latex';
  legend(energy_title)
  tit = title(titles{i});
  tit.FontSize = 1.1*plot_param.font_size;
  tit.Interpreter = 'latex';
  yl = ylabel('Capacity factor [\%]');
  yl.FontSize = plot_param.font_size;
  yl.Interpreter = 'latex';
end

%   _   _       _               _   _      __ _          _ 
%  | \ | | ___ | |_   ___  __ _| |_(_)___ / _(_) ___  __| |
%  |  \| |/ _ \| __| / __|/ _` | __| / __| |_| |/ _ \/ _` |
%  | |\  | (_) | |_  \__ \ (_| | |_| \__ \  _| |  __/ (_| |
%  |_| \_|\___/ \__| |___/\__,_|\__|_|___/_| |_|\___|\__,_|

if isfield(min_values_vector{1}, 'Pns')
  figure('Color', 'w'); hold on; grid on;
  for j=1:size(T_vec, 2)
    for i=1:2
      pl = plot(min_values_vector_store{j}{i}.Pns*1e-6);
      pl.LineStyle = line_style{i};
      pl.LineWidth = plot_param.line_width;
      pl.DisplayName = 'NS';
      pl.Color = color(j);
    end
  end
  title('Not satisfied power')
end

                                     