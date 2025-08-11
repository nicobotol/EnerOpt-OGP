close all;
clear;
% clc;

tic;
parameters_Lanzarote % load parameters related to simulation and converters

%    ____                                _                
%   / ___|___   ___  _ ____   _____ _ __| |_ ___ _ __ ___ 
%  | |   / _ \ / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__/ __|
%  | |__| (_) | (_) | | | \ V /  __/ |  | ||  __/ |  \__ \
%   \____\___/ \___/|_| |_|\_/ \___|_|   \__\___|_|  |___/
                  
define_converters % define the converters and their parameters

%   ____        _                 _       
%  |  _ \  __ _| |_ __ _ ___  ___| |_ ___ 
%  | | | |/ _` | __/ _` / __|/ _ \ __/ __|
%  | |_| | (_| | || (_| \__ \  __/ |_\__ \
%  |____/ \__,_|\__\__,_|___/\___|\__|___/

% import_datasets_dulang % load the datasets of the different resources
% import_datasets_denmark % dataset denmark
% import_datasets % dataset lanzarote
% import_datasets_mixed % denmark wind + dulang wave
import_datasets_norway % denmark wind + dulang wave
                         
%   ___ ____ ____        _        _     _ _ _ _         
%  |_ _/ ___/ ___|   ___| |_ __ _| |__ (_) (_) |_ _   _ 
%   | |\___ \___ \  / __| __/ _` | '_ \| | | | __| | | |
%   | | ___) |__) | \__ \ || (_| | |_) | | | | |_| |_| |
%  |___|____/____/  |___/\__\__,_|_.__/|_|_|_|\__|\__, |
%                                                 |___/ 
%%
% run the optimization for different number of scenarios and different seeds
clear min_values min_values_vector values_minvalue time_opt min_values_mat values_minvalue_mat time_mat
seed_vec    = 1;
InScenNum_vec = size(wind.iniVec, 2); % number of scenarios to be used for the optimization

clc

load_scenarios.NS_fraction = 0.10;
load_scenarios.LPSP_target    = 0.001;

scenario.T = 24*1;
InScenNum = 730*24/scenario.T;
    
WT.iniVec               = reshape(wind.iniVec, [], 1);
WT.WindValue            = [];
WT.Power            = [];
WT.WindValue            = WT.GroupSamplesBy(scenario.T);
WT.DoWindPower;
if sum(all(WT.Power < 1e-2, 1)) > 0
  WT.Power(:, all(WT.Power < 1e-2, 1)) = 1e-2*ones(scenario.T, sum(all(WT.Power < 1e-2, 1)));
end

PV.iniVec               = reshape(irradiance.iniVec, [], 1);
PV.RadiationValue       = [];
PV.Power              = [];
PV.RadiationValue       = PV.GroupSamplesBy(scenario.T);
PV.DoPVPower;
PV.Power(PV.Power<=1e-5) = 1e-5;

WEC.iniVec              = reshape(SWH.iniVec, [], 1);
WEC.SWH                 = [];
WEC.SWH                 = WEC.GroupSamplesBy(scenario.T);
WEC.iniVec              = reshape(W_period.iniVec, [], 1);
WEC.W_period            = [];
WEC.W_period            = WEC.GroupSamplesBy(scenario.T);
WEC.PowRated            = max(WEC.PowerMatrix, [], 'all');
WEC.DoWECPowerCorpower;

load_scenarios.iniVec = [Pload;Pload];
LscensProbVec_N = 1/InScenNum*ones(InScenNum,1);
load_scenarios.iniVec = load_scenarios.GroupSamplesBy(scenario.T);
load_scenarios.iniVec(load_scenarios.iniVec <= load_scenarios.NS_fraction*load_scenarios.P_rated) = load_scenarios.NS_fraction*load_scenarios.P_rated; 
load_scenarios.Pps_add_cost = 1e-6;
load_scenarios.Pps_rem_cost = 1e-6;

% Collect all the Renewable Energy Converters (REC) in one structure
REC     = RECX();
REC.WT  = WT; 
REC.PV  = PV;
REC.WEC = WEC;

% Solve the optimization
tic;
gamma = 24/scenario.T; 
i=1;j=1;
[min_values{i,j}, min_values_vector{i,j}, values_minvalue{i,j}] = CVaR_optimization_obj6(LscensProbVec_N, REC, ESS, DL, load_scenarios, GRID, opt_parameters, gamma);
% [min_values{i,j}, min_values_vector{i,j}, values_minvalue{i,j}] = CVaR_optimization_obj8(LscensProbVec_N, REC, GT, ESS, DL, load_scenarios, GRID, opt_parameters, gamma);
% min_values{1,1}{1}.x_REC

time_opt{i,j} = toc;

%% Re-arrange results in matrices
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
    min_values_mat(i, j) = min_values{i,j}{1};
    values_minvalue_mat(i, j) = values_minvalue{i,j}{1};
    time_mat(i, j) = time_opt{i,j};
  end
end

%   ____  _           _             
%  |  _ \(_)___ _ __ | | __ _ _   _ 
%  | | | | / __| '_ \| |/ _` | | | |
%  | |_| | \__ \ |_) | | (_| | |_| |
%  |____/|_|___/ .__/|_|\__,_|\__, |
%              |_|            |___/ 
%%
write_on_file.flag = 0;
write_on_file.name = '../report/figure/vectorial/results_2024_10_24.txt';
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
    display_results(min_values{i,j}{1},values_minvalue{i,j}{1},PV,WT,WEC, i, j, write_on_file);
  end
end

%   ____  _        _   _     _   _          
%  / ___|| |_ __ _| |_(_)___| |_(_) ___ ___ 
%  \___ \| __/ _` | __| / __| __| |/ __/ __|
%   ___) | || (_| | |_| \__ \ |_| | (__\__ \
%  |____/ \__\__,_|\__|_|___/\__|_|\___|___/
%% Compute statistic s of the cost fuction  

statistic.mean_F = mean(values_minvalue_mat, 1); % mean of the cost function
statistic.std_F = std(values_minvalue_mat, 1); % standard deviation of the cost function
statistic.median_F = median(values_minvalue_mat, 1); % median of the cost function
statistic.iqr_F = iqr(values_minvalue_mat, 1); % interquartile range of the cost function
statistics.range_F = range(values_minvalue_mat, 1); % range of the cost function

%   ___ ____ ____          _       _    
%  |_ _/ ___/ ___|   _ __ | | ___ | |_  
%   | |\___ \___ \  | '_ \| |/ _ \| __| 
%   | | ___) |__) | | |_) | | (_) | |_  
%  |___|____/____/  | .__/|_|\___/ \__| 
%                   |_|                 
%% Std deviation of the cost function std(F) and time
fig = figure('Color', 'w'); hold on; grid on; box on
yyaxis left
pl_l = plot(InScenNum_vec, statistic.std_F);
pl_l.Marker = 'o';
pl_l.Color = color(1);
pl_l.LineWidth = 2;
ay_l = ylabel('$\sigma\left(F(x, \Omega_{s})\right)$');
ay_l.Interpreter = 'latex';
ay_l.FontSize = 6.5;
ay_l = gca;
ay_l.FontSize = 6.5;

ay_l.YColor = color(1); 
yyaxis right
pl_r = plot(InScenNum_vec, mean(time_mat, 1));
pl_r.LineStyle = '--';
pl_r.Marker = 'x';
pl_r.MarkerSize = 10;
pl_r.Color = color(2);
pl_r.LineWidth = 1.5;
ay_r = ylabel('Minimization time [s]');
ay_r.Interpreter = 'latex';
ay_r.FontSize = 6.5;
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = color(2);
xl = xlabel('$ |\Omega_{s}| $');
xl.Interpreter = 'latex';
xl.FontSize = 6.5;
tl = title('Final cost and time of the optimization');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];

if plot_param.print_figure == 1
  export_figure(fig, 'scenario_number_select_2024_11_08.pdf', '..\report\figure');
end

%% Value of the cost F and time
fig = figure('Color', 'w'); hold on; grid on; box on;
yyaxis left
for j=1:length(InScenNum_vec)
  errorbar(InScenNum_vec(j), statistic.mean_F(j), 1.5*std(values_minvalue_mat(:,j)), 'Marker', '_', 'MarkerSize',10)
  pl_l = plot(InScenNum_vec(j), values_minvalue_mat(:,j), 'o', 'Color', color(1), 'LineWidth', 1.5, 'MarkerSize',5);
end
ay_l = ylabel('$F(x, \Omega_{s})$');
ay_l.Interpreter = 'latex';
ay_l.FontSize = 6.5;
ay_l = gca;
ay_l.FontSize = 6.5;
ay_l.YColor = color(1); 
yyaxis right
pl_r = plot(InScenNum_vec, mean(time_mat, 1));
pl_r.LineStyle = '--';
pl_r.Marker = 'x';
pl_r.MarkerSize = 10;
pl_r.Color = color(2);
pl_r.LineWidth = 1.5;
ay_r = ylabel('Minimization time [s]');
ay_r.Interpreter = 'latex';
ay_r.FontSize = 6.5;
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = color(2);
xl = xlabel('$ |\Omega_{s}| $');
xl.Interpreter = 'latex';
xl.FontSize = 6.5;

set(gca,'TickLabelInterpreter','latex')
tl = title('Final cost and time of the optimization');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];


if plot_param.print_figure == 1
  export_figure(fig, 'scenario_number_select_errorbar_2024_11_08.pdf', '..\report\figure');
end

%% (Partial) Stability of the solution of the optimiazation
fig = figure('Color', 'w'); hold on; grid on; box on
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
    
    yyaxis left
    pl_l = plot(InScenNum_vec(j), min_values{i,j}{1}.x_REC(1)); % PV
    pl_l.Marker = 'o';
    pl_l.Color = color(1);
    pl_l.LineWidth = 2;
    
    yyaxis right
    pl_r = plot(InScenNum_vec(j), min_values{i,j}{1}.x_ESS_IV); % ESS energy size
    pl_r.Marker = 'x';
    pl_r.Color = color(2);
    pl_r.LineWidth = 2;
  end
end

yyaxis left
ay_l = ylabel('PV number');
ay_l.Interpreter = 'latex';
ay_l.FontSize = 6.5;
ay_l = gca;
ay_l.FontSize = 6.5;
ay_l.YColor = color(1);
xl = xlabel('$ |\Omega_{s}| $');
xl.Interpreter = 'latex';
xl.FontSize = 6.5;

yyaxis right
ay_r = ylabel('ESS energy size [Wh]');
ay_r.Interpreter = 'latex';
ay_r.FontSize = 6.5;
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = color(2);

set(gca,'TickLabelInterpreter','latex')
tl = title('Study on the stability of the solution');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];

if plot_param.print_figure == 1
  export_figure(fig, 'solution_stability_2024_11_08.pdf', '..\report\figure');
end

%% (Complete) Stability of the solution of the optimiazation
scale = [PV.PowRated, WT.PowRated, WEC.PowRated];

fig = figure('Color','w');
subplot(4,1,1); hold on; grid on; box on;
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
      pl = plot(InScenNum_vec(j), values_minvalue_mat(i,j));
      pl.Marker = marker_vec(1);
      pl.Color = 'k';%color(i);
      pl.LineStyle = 'none';
  end
end
% lg = legend('Seed 1', 'Seed 2', 'Seed 3', 'Seed 4');
% lg.Interpreter = 'latex';
% lg.NumColumns = 2;
% lg.Location = 'southeast';
yl = ylabel('ISS cost');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
xl = xlabel('$|\Omega_s|$');
xl.FontSize = 6.5;
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

subplot(4,1,2);hold on; grid on; box on;
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
    for k=1:3
      pl = plot(InScenNum_vec(j), min_values{i, j}{1}.x_REC(k)*scale(k)/1e6);
      pl.Marker = marker_vec(k);
      pl.Color = 'k';%color(i);
      pl.LineStyle = 'none';
    end
  end
end
lg = legend('PV', 'WT', 'WEC');
lg.Interpreter = 'latex';
lg.NumColumns = 3;
lg.Location = 'northeast';
ax = gca;
ax.FontSize = 6.5;
yl = ylabel('REC installed power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

subplot(4,1,3);hold on; grid on; box on;
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
      plot(InScenNum_vec(j), min_values{i, j}{1}.x_ESS_IV/1e6, 'Marker',marker_vec(1), 'Color','k');%color(i))
  end
end
ax = gca;
ax.FontSize = 6.5;
yl = ylabel('$E_{BESS} [MWh]$');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

subplot(4,1,4);hold on; grid on; box on;
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
      pl = plot(InScenNum_vec(j), min_values{i, j}{1}.x_ESS_NIV/1e6);
      pl.Marker = marker_vec(1);
      pl.Color = 'k';%color(i);
      pl.LineStyle = 'none';
  end
end
% lg = legend('Seed 1', 'Seed 2', 'Seed 3', 'Seed 4');
% lg.Interpreter = 'latex';
% lg.NumColumns = 2;
% lg.Location = 'southeast';
yl = ylabel('$P_{BESS} [MW]$');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
xl = xlabel('$|\Omega_s|$');
xl.FontSize = 6.5;
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

tl = sgtitle('Convergence of the solution');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 8.8 3*5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_2024_11_08.pdf', '..\report\figure');
end

%% Convergence of the statistics
fig = figure('Color','w'); grid on; box on; hold on;
% plot(InScenNum_vec, statistic.mean_F, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$');
% plot(InScenNum_vec, statistic.median_F, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$');
% plot(InScenNum_vec, statistic.iqr_F, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');
% plot(InScenNum_vec, statistic.std_F, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$');
% plot(InScenNum_vec, statistics.range_F, 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$');
plot(InScenNum_vec, statistic.mean_F/statistic.mean_F(1), 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$');
plot(InScenNum_vec, statistic.median_F/statistic.median_F(1) , 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$');
plot(InScenNum_vec, statistic.iqr_F/statistic.iqr_F(1), 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');
plot(InScenNum_vec, statistic.std_F/statistic.std_F(1), 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$');
plot(InScenNum_vec, statistics.range_F/statistics.range_F(1), 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northeast';
lg.FontSize = 6.5;
yl = ylabel('Normalized');
yl.Interpreter = 'latex';
xl = xlabel('$|\Omega_s|$');
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_statistics_2024_11_08.pdf', '..\report\figure');
end


%    ___        _                                  _            _        _     
%   / _ \ _   _| |_      ___  __ _ _ __ ___  _ __ | | ___   ___| |_ __ _| |__  
%  | | | | | | | __|____/ __|/ _` | '_ ` _ \| '_ \| |/ _ \ / __| __/ _` | '_ \ 
%  | |_| | |_| | ||_____\__ \ (_| | | | | | | |_) | |  __/ \__ \ || (_| | |_) |
%   \___/ \__,_|\__|    |___/\__,_|_| |_| |_| .__/|_|\___| |___/\__\__,_|_.__/ 
%                                           |_|                                
%%
% Re-compute the values of the cost function using the solution of an optimization but with scenarios not used for finding it
clc
clear min_values_2stage min_values_vector_2stage values_minvalue_2stage 
plot_param.print_figure = 0;

for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)

    % WT.iniVec               = cellScenGenSetRes{1}.iniVec;
    WT.iniVec               = met_data_wind.wind_100m;
    WT.iniVec               = reshape(WT.iniVec, [], 1);
    WT.WindValue            = [];
    WT.Power            = [];
    WT.WindValue            = WT.GroupSamplesBy(scenario.T);
    WT.DoWindPower;

    % PV.iniVec               = cellScenGenSetRes{2}.iniVec;
    PV.iniVec               = met_data_irr.irradiance_direct*1e3;
    PV.iniVec               = reshape(PV.iniVec, [], 1);
    PV.RadiationValue       = [];
    PV.Power              = [];
    PV.RadiationValue       = PV.GroupSamplesBy(scenario.T);
    PV.DoPVPower;

    % WEC.iniVec              = cellScenGenSetRes{3}.iniVec;
    WEC.iniVec              = met_data_swh;
    WEC.iniVec               = reshape(WEC.iniVec, [], 1);
    WEC.SWH                 = [];
    WEC.SWH                 = WEC.GroupSamplesBy(scenario.T);
    % WEC.iniVec              = cellScenGenSetRes{4}.iniVec;
    WEC.iniVec              = met_data_mwp;
    WEC.iniVec              = reshape(WEC.iniVec, [], 1);
    WEC.W_period            = [];
    WEC.W_period            = WEC.GroupSamplesBy(scenario.T);
    WEC.PowRated            = max(WEC.PowerMatrix, [], 'all');
    WEC.DoWECPower;

    % load_scenarios.iniVec = scenGenSetLoad.iniVec;
    load_scenarios.iniVec = [Pload; Pload];
    load_scenarios.iniVec = load_scenarios.GroupSamplesBy(scenario.T);
    min_load        = load_scenarios.NS_fraction*load_scenarios.P_rated;
    load_scenarios.iniVec(load_scenarios.iniVec <= min_load) = min_load;

    LscensProbVec_N = 1/(size(load_scenarios.iniVec, 2))*ones(size(load_scenarios.iniVec, 2), 1);
    % Solve the optimization
    tic;
    [min_values_2stage{i,j}, min_values_vector_2stage{i,j}, values_minvalue_2stage{i,j}] = CVaR_optimization_second_stage_obj6(LscensProbVec_N, REC, ESS, DL, load_scenarios, GRID, opt_parameters, min_values{i, j}, 1);
%     [min_values_2stage_noCritical{i,j}, min_values_vector_2stage_noCritical{i,j}, values_minvalue_2stage_noCritical{i,j}] = CVaR_optimization_second_stage_obj6_noCritical(LscensProbVec_N, REC, ESS, DL, load_scenarios, GRID, opt_parameters, min_values{i, j}); % optimization without considering the possibility to add power for compensating the power balance and supporting the frequency
    time_opt_2stage{i,j} = toc;

    fprintf('Ended simulation 2nd stage scenario %d, seed %d\n', j, i);
  end
end

%% Re-arrange results in matrices
values_minvalue_mat_2stage  = zeros(length(seed_vec), length(InScenNum_vec));
min_values_mat_2stage       = zeros(length(seed_vec), length(InScenNum_vec));
time_mat_2stage             = zeros(length(seed_vec), length(InScenNum_vec));
values_minvalue_mat_2stage_noCritical  = zeros(length(seed_vec), length(InScenNum_vec));
min_values_mat_2stage_noCritical       = zeros(length(seed_vec), length(InScenNum_vec));
time_mat_2stage_noCritical             = zeros(length(seed_vec), length(InScenNum_vec));

for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
    if size(values_minvalue_2stage{i,j}{1}, 1) == 0 % Case in which optimization failed
      values_minvalue_mat_2stage(i, j) = 0;
    else
      values_minvalue_mat_2stage(i, j) = values_minvalue_2stage{i,j}{1};
    end
    % if size(values_minvalue_2stage_noCritical{i,j}{1}, 1) == 0 % Case in which optimization failed
    %   values_minvalue_mat_2stage_noCritical(i, j) = 0;
    % else
    %   values_minvalue_mat_2stage_noCritical(i, j) = values_minvalue_2stage_noCritical{i,j}{1};
    % end
    time_mat_2stage(i, j) = time_opt_2stage{i,j};
  end
end

%    ___  ____ ____          _       _   
%   / _ \/ ___/ ___|   _ __ | | ___ | |_ 
%  | | | \___ \___ \  | '_ \| |/ _ \| __|
%  | |_| |___) |__) | | |_) | | (_) | |_ 
%   \___/|____/____/  | .__/|_|\___/ \__|
%                     |_|                
%%
% values_minvalue_mat_2stage

% %% Heatmap visualizing which minimization failed (ie results from the simulation not considering the possibility to add power for compensating the balances)
% clc 
% tmp_mat = values_minvalue_mat_2stage;
% tmp_mat(tmp_mat == 0) = NaN;
% % tmp_mat_noCritical = values_minvalue_mat_2stage_noCritical;
% % tmp_mat_noCritical(tmp_mat_noCritical == 0) = NaN;

% fig = figure('Color','w'); box on;
% h = heatmap(InScenNum_vec,seed_vec,tmp_mat/1e10);
% % h = heatmap(InScenNum_vec,seed_vec,tmp_mat_noCritical/1e10);
% h.MissingDataLabel = 'NF'; % Label for NaN cells
% h.MissingDataColor = color(2); 
% h.xlabel('Scenario size');
% h.Interpreter = 'latex';
% h.FontSize = 6.5;
% h.ylabel('Seed');
% h.Title = 'Feasibility and cost of the OSS (x$10^{10}$)';
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% if plot_param.print_figure == 1
%   export_figure(fig, 'OSS_heatmap_2024_11_08.pdf', '..\report\figure');
% end

% %% Heatmap visulizing which OSS test failed and how many additional energy were required for satisfyiung the load and the frequency
% clear ES_mat
% for j = 1:length(InScenNum_vec)
%     for i = 1:length(seed_vec)
%       ES_mat(i, j) = min_values_2stage{i,j}{1}.Ens_critical + min_values_2stage{i,j}{1}.Ens_critical_s; % total energy not satisfied
%     end
% end
% ES_mat_norm = ES_mat/max(ES_mat, [], 'all');
% 
% % Create heatmap
% fig = figure('Color','w');box on
% % im = imagesc(InScenNum_vec,seed_vec, log10(ES_mat_norm), [1e-7, max(log10(ES_mat_norm), [], 'all')]);
% im = imagesc(InScenNum_vec,seed_vec, log10(ES_mat_norm), [-5, 0]);
% colormap(customColormap);
% im.AlphaData= 1;
% ay = gca;
% ay.YTick = seed_vec;
% ay.TickLabelInterpreter = 'latex';
% ay.FontSize = 6.5;
% xl = xlabel('$|\Omega_s|$');
% xl.Interpreter = 'latex'; 
% xl.FontSize = 6.5;
% yl = ylabel('Seed');
% yl.Interpreter = 'latex';
% yl.FontSize = 6.5;
% tl = title('Additional energy for satisfying OSS');
% tl.FontSize = 6.5;
% tl.Interpreter = 'latex';
% % Add text annotations
% for j = 1:length(InScenNum_vec)
%   for i = 1:length(seed_vec)
%     xpos = InScenNum_vec(j);
%     ypos = seed_vec(i); 
%     z_value = ES_mat_norm(i, j);
%     w_value = min_values_2stage{i,j}{1}.Ens_critical / ES_mat(i, j);
%     if isnan(w_value)
%       tx = text(xpos, ypos, sprintf('NP \n (NP)'));
%     else
%       tx = text(xpos, ypos, sprintf('%.2f \n (%.3f)', z_value, w_value));
%     end
%     tx.Interpreter = 'latex';
%     tx.HorizontalAlignment = 'center';
%     tx.Color = 'k';
%     tx.FontSize = 6.5;
%   end
% end
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% if plot_param.print_figure == 1
%   export_figure(fig, 'OSS_energy_2024_11_08.pdf', '..\report\figure');
% end

%% Heatmap of the maximum power that should be added for having the OSS
clear max_virtual_power_mat ES_max_virtual_power_s_mat
max_virtual_power_mat = zeros(length(seed_vec), length(InScenNum_vec));
for j = 1:length(InScenNum_vec)
    for i = 1:length(seed_vec)
      Pres_virtual = min_values_vector_2stage{i,j}{1}.Pres_virtual;
      Pres = min_values_vector_2stage{i,j}{1}.P_res;
      Pdc = min_values_vector_2stage{i,j}{1}.Pdc;

      % den = Pres + Pdc;    % total injected power on the system (RES + battery output)
      % idx = den > 0;          % consider as denominator just the non-zero power
      % tmp = Pres_virtual(idx);
      % [max_virtual_power_mat(i, j), idx2] = max(Pres_virtual(idx)./den(idx), [], 'all'); % maximum power that should be added to satisfying the load 
       [max_virtual_power_mat(i, j), idx2] = max(Pres_virtual, [], 'all'); % maximum power that should be added to satisfying the load 
    end
end

% Create heatmap with the power for the power balance
fig = figure('Color','w');box on
im = heatmap( InScenNum_vec,seed_vec,max_virtual_power_mat);%, 'ColorVariable',log10(max_virtual_power_mat));
im.Colormap = customColormap;
im.ColorScaling = 'log';
im.CellLabelFormat = '%0.1f';
im.XLabel = '$|\Omega_s|$';
im.YLabel = 'Seed';
im.Interpreter = 'latex';
im.FontSize = 6.5;
im.Title = 'Additional power for satisfying OSS';
im.ColorbarVisible='off'; % remove the colorbar on the side
fig.Units = "centimeters";
fig.Position = [0 0 12 5];
if plot_param.print_figure == 1
  export_figure(fig, 'OSS_max_power_2024_11_08.pdf', '..\report\figure');
end

%% Value of the cost F and (eventual) additional power
fig = figure('Color', 'w'); hold on; grid on; box on;
yyaxis left
for j=1:length(InScenNum_vec)
  errorbar(InScenNum_vec(j), mean(values_minvalue_mat_2stage(:,j)), 1.5*std(values_minvalue_mat_2stage(:,j)), 'Marker', '_', 'MarkerSize',10, 'HandleVisibility','off');
  for i=1:length(seed_vec)
    pl_l = plot(InScenNum_vec(j), values_minvalue_mat_2stage(i,j), 'o', 'LineWidth', 1.5, 'MarkerSize',5,  'HandleVisibility','off', 'Color','k');% color(i));
  end
end
ay_l = ylabel('$F(x, \Omega_{s})$');
ay_l.Interpreter = 'latex';
ay_l.FontSize = 6.5;
ay_l = gca;
ay_l.FontSize = 6.5;
ay_l.YColor = 'k'; 
yyaxis right
for j=1:length(InScenNum_vec)
  for i=1:length(seed_vec)
    pl_r = plot(InScenNum_vec(j), max_virtual_power_mat(i,j), 'x', 'LineWidth', 1.5, 'MarkerSize',5, 'HandleVisibility','off', 'Color', 'k');% color(i));
  end
end
ay_r = ylabel('$\Delta P_{OSS}$');
ay_r.Interpreter = 'latex';
ay_r.FontSize = 6.5;
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = 'k';
xl = xlabel('$ |\Omega_{s}| $');
xl.Interpreter = 'latex';
xl.FontSize = 6.5;

plot(NaN, NaN, 'Color','k','LineStyle','none','Marker','o','DisplayName','Cost')
plot(NaN, NaN, 'Color','k','LineStyle','none','Marker','x','DisplayName','$\frac{P_{v}}{P_{inj}}$')

lg = legend();
lg.Interpreter = 'latex';

set(gca,'TickLabelInterpreter','latex')
tl = title('Final cost and additional power for the $2^{nd}$ stage');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];


if plot_param.print_figure == 1
  export_figure(fig, 'scenario_number_select_errorbar_2ndstage_2024_11_08.pdf', '..\report\figure');
end


%% 
% % Create heatmap for the power missing for freq support
% fig = figure('Color','w');box on
% % im = imagesc(InScenNum_vec,seed_vec, log10(ES_mat_norm), [1e-7, max(log10(ES_mat_norm), [], 'all')]);
% im = imagesc(InScenNum_vec,seed_vec, log10(ES_max_virtual_power_s_mat), [-5, 0]);
% colormap(customColormap);
% im.AlphaData= 1;
% ay = gca;
% ay.YTick = seed_vec;
% ay.TickLabelInterpreter = 'latex';
% ay.FontSize = 6.5;
% xl = xlabel('$|\Omega_s|$');
% xl.Interpreter = 'latex'; 
% xl.FontSize = 6.5;
% yl = ylabel('Seed');
% yl.Interpreter = 'latex';
% yl.FontSize = 6.5;
% tl = title('Additional power for satisfying OSS');
% tl.FontSize = 6.5;
% tl.Interpreter = 'latex';
% % Add text annotations
% for j = 1:length(InScenNum_vec)
%   for i = 1:length(seed_vec)
%     xpos = InScenNum_vec(j);
%     ypos = seed_vec(i); 
%     z_value = ES_max_virtual_power_s_mat(i, j);
%     % w_value = min_values_2stage{i,j}{1}.Ens_critical / ES_mat(i, j);
%     if isnan(w_value)
%       tx = text(xpos, ypos, sprintf('NP \n (NP)'));
%     else
%       tx = text(xpos, ypos, sprintf('%.2f', z_value));
%     end
%     tx.Interpreter = 'latex';
%     tx.HorizontalAlignment = 'center';
%     tx.Color = 'k';
%     tx.FontSize = 6.5;
%   end
% end
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% if plot_param.print_figure == 1
%   export_figure(fig, 'OSS_max_power_s_2024_11_08.pdf', '..\report\figure');
% end

% 
% % Create heatmap for the power missing for freq support
% fig = figure('Color','w');box on
% % im = imagesc(InScenNum_vec,seed_vec, log10(ES_mat_norm), [1e-7, max(log10(ES_mat_norm), [], 'all')]);
% im = imagesc(InScenNum_vec,seed_vec, log10(0.5*(ES_max_virtual_power_mat + ES_max_virtual_power_s_mat)), [-5, 0]);
% colormap(customColormap);
% im.AlphaData= 1;
% ay = gca;
% ay.YTick = seed_vec;
% ay.TickLabelInterpreter = 'latex';
% ay.FontSize = 6.5;
% xl = xlabel('$|\Omega_s|$');
% xl.Interpreter = 'latex'; 
% xl.FontSize = 6.5;
% yl = ylabel('Seed');
% yl.Interpreter = 'latex';
% yl.FontSize = 6.5;
% tl = title('Additional power for satisfying OSS');
% tl.FontSize = 6.5;
% tl.Interpreter = 'latex';
% % Add text annotations
% for j = 1:length(InScenNum_vec)
%   for i = 1:length(seed_vec)
%     xpos = InScenNum_vec(j);
%     ypos = seed_vec(i); 
%     z_value = ES_max_virtual_power_mat(i, j);
%     w_value = ES_max_virtual_power_s_mat(i, j);
%     if w_value <= 1e-7 && z_value <= 1e-7
%       tx = text(xpos, ypos, sprintf('NP \n NP'));
%     elseif w_value <= 1e-7 && z_value >= 1e-7
%       tx = text(xpos, ypos, sprintf('%.2f \n NP', z_value));
%     elseif w_value >= 1e-7 && z_value <= 1e-7
%       tx = text(xpos, ypos, sprintf('NP \n %.2f', w_value));
%     else
%       tx = text(xpos, ypos, sprintf('%.2f \n %.2f', z_value, w_value));
%     end
%     tx.Interpreter = 'latex';
%     tx.HorizontalAlignment = 'center';
%     tx.Color = 'k';
%     tx.FontSize = 6.5;
%   end
% end
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% if plot_param.print_figure == 1
%   export_figure(fig, 'OSS_average_max_power_2024_11_08.pdf', '..\report\figure');
% end

% %% Power supplement
% fig = figure('Color', 'w');grid on;hold on;box on;
% for j=1:length(InScenNum_vec)
%   for i=1:length(seed_vec)
%     if isfield(min_values_2stage{i,j}{1}, 'Ens_critical')
%       yyaxis left
%       plot(InScenNum_vec(j), min_values_2stage{i,j}{1}.Ens_critical, 'o', 'Color', color(i), 'LineWidth', 1.5, 'MarkerSize',5);
%       % yyaxis right
%       % plot(InScenNum_vec(j), min_values_2stage{i,j}{1}.Ens_critical_s, 'x', 'Color', color(i), 'LineWidth', 1.5, 'MarkerSize',5);
%     else
%       yyaxis left
%       plot(InScenNum_vec(j), 0, 'o', 'Color', color(i), 'LineWidth', 1.5, 'MarkerSize',5);
%       % yyaxis right
%       % plot(InScenNum_vec(j), 0, 'x', 'Color', color(i), 'LineWidth', 1.5, 'MarkerSize',5);
%     end
%   end
% end