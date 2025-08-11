marker_vec = {'x', 'o', 'd'};

switch sweep_type
  case 'None'
    sweep_name = {'None'};
  case 'beta'
    sweep_name = {'$\beta$'};
  case 'LPSP'
    sweep_name = {'$LPSP^{*}$'};
  case 'PS'
    sweep_name = {'PS'};
  case 'Carbon_tax'
    sweep_name = {'$\eta_{CO_2}$'};
  case 'DGpower'
    sweep_name = {'$\eta_{DG}$'};
  case 'PVCost'
  sweep_name = {'$\eta_{PV}$'};
end

if plot_param.print_figure == 1
  set(0,'DefaultFigureWindowStyle','normal');
else
  set(0,'DefaultFigureWindowStyle','docked');
end

%% Cost F
fig = figure('Color', 'w'); hold on; grid on; box on;
for b=1:num_sweep
  for i=1:num_sim
    plot(i, values_minvalue{1, b, i}, '-x', 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
  end
  if  ~(strcmp(sweep_type, 'None'))
    plot(NaN,NaN, 'x', 'LineWidth', 1.5, 'Color', color(b), 'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))])
  end
end
tl = title('Total cost');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
if  strcmp(sweep_type, 'None') else %|| strcmp(sweep_type, 'Carbon_tax') else
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'best';
  lg.ItemTokenSize = [10 10];
end
ay_r = ylabel('$F [\$]$');
ay_r.Interpreter = 'latex';
ay_r.FontSize = 6.5;
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = 'k';
% xl = xlabel('Case');
% xl.Interpreter = 'latex';
% xl.FontSize = 6.5;
xticks([1:1:num_sim]);
xticklabels(case_sim_vec);
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'cost_F_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
end

%% Cost primary and secondary stages
fig = figure('Color', 'w'); hold on; grid on; box on;
for b=1:num_sweep
  for i=1:num_sim
    yyaxis left
    plot(i, values_solution{1, b, i}.cTx, 'Marker', marker_vec{1}, 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
    
    yyaxis right
    plot(i, values_solution{1, b, i}.qTy, 'Marker', marker_vec{2}, 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
  end
end
yyaxis left
plot(NaN, NaN, 'x', 'LineWidth', 1.5, 'Color', 'k', 'Marker', marker_vec{1}, 'DisplayName', '$(1-\beta)c^{T}x$', 'LineWidth', 1.5, 'LineStyle','none');
yyaxis right
plot(NaN, NaN, 'o', 'LineWidth', 1.5, 'Color', 'k', 'Marker', marker_vec{2}, 'DisplayName', '$(1-\beta)q^{T}y$', 'LineWidth', 1.5, 'LineStyle','none');
if  strcmp(sweep_type, 'None') || strcmp(sweep_type, 'Carbon_tax')
  for b=1:num_sweep
      plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(b), 'Marker', 's', 'DisplayName', [sweep_name{1}, ' = ', num2str(sweep_vec(b))], 'LineStyle', 'none', 'MarkerFaceColor',color(b));
  end
end
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'bestoutside';
lg.ItemTokenSize = [10 10];
yyaxis left
ay_l = ylabel('$(1-\beta) c^{T}x$ [\$]');
ay_l.Interpreter = 'latex';
ay_l = gca;
ay_l.YColor = 'k';
yyaxis right
ay_r = ylabel('$(1-\beta) q^{T}y$  $[\$]$');
ay_r.Interpreter = 'latex';
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = 'k';
% xl = xlabel('Case');
% xl.Interpreter = 'latex';
% xl.FontSize = 6.5;
xticks([1:1:num_sim]);
xticklabels(case_sim_vec);
tl = title('Costs');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'cost_cTx_qTy_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
end


% fig = figure('Color', 'w'); hold on; grid on; box on;
% plot(sum(values_vector{1, 1,i}.P_GT, 3), '-', 'LineWidth', 1.5, 'Color', color(i));
% title('Total GT output power')
% 
% fig = figure('Color', 'w'); hold on; grid on; box on;
% plot(sum(values_vector{1, 1,i}.P_GT, 3), '-', 'LineWidth', 1.5, 'Color', color(1));
% plot(values_vector{1, 1,i}.Pload, '-', 'LineWidth', 1.5, 'Color', color(2));
% title('GT power and load')

%% CO2 emitted
fig = figure('Color', 'w'); hold on; grid on; box on;
for b=1:num_sweep
  for i=1:num_sim
    plot(i, CO2_emitted{1, b, i}/1e6, 'o', 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
  end
  if  ~(strcmp(sweep_type, 'None'))
    plot(NaN,NaN,'Color',color(b),'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))], 'LineWidth', 1.5, 'LineStyle','none', 'Marker','o');
  end
end
xticks([1:1:num_sim]);
xticklabels(case_sim_vec);
if  ~(strcmp(sweep_type, 'None'))
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'best';
  lg.ItemTokenSize = [10 10];
end
% xl = xlabel('Case');
% xl.Interpreter = 'latex';
% xl.FontSize = 6.5;
ay = ylabel('$CO_{2}$ [Mkg]');
ay.Interpreter = 'latex';
ay.FontSize = 6.5;
ay = gca;
ay.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
tl = title('Produced  $CO_{2}$');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'CO2_emitted_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
end

%% Cost fraction
if  (strcmp(sweep_type, 'None'))
num_costs =  size([values_solution{1,1,1}.cost_fraction(:).val], 2);

cost_frac = zeros(num_sim, num_costs, num_sweep);
  for b=1:num_sweep
    for i=1:num_sim
      cost_frac(i,1:num_costs,b) = [values_solution{:,b,i}.cost_fraction(:).val]*100;
    end
  end

fig = figure('Color', 'w'); hold on; grid on; box on;
for b=1:num_sweep
  subplot(num_sweep, 1, b)
  if num_sim > 1
    b_plot = bar(cost_frac(:,1:end,b), 'stacked');
  else 
    b_plot = bar(1, cost_frac(:,1:end,b), 'stacked');
  end
  for i=1:size(b_plot, 2)
    b_plot(i).FaceColor = color(i);
  end
  set(gca,'xtick',[])
  set(gca,'xticklabel',[])
  ylim([0, 105])
  set(gca,'TickLabelInterpreter','latex')
  if sweep_name{1} == 'None'
    ay = ylabel('$\left[\%\right]$');
  else
    ay = ylabel([sweep_name{1}, ' = ', num2str(sweep_vec(b))]);
  end
  ay.Interpreter = 'latex';
  ay.FontSize = 6.5;
  ay = gca;
  ay.FontSize = 6.5;
end
xticks([1:1:num_sim]);
xticklabels(case_sim_vec);
lg = legend({values_solution{1,1,1}.cost_fraction(:).name});%, '$q^{T}y_{P_DGv}$');
lg.Interpreter = 'latex';
lg.NumColumns = 6;
lg.ItemTokenSize = [10 10];
lg.Location = 'southoutside';
set(gca,'TickLabelInterpreter','latex')
tl = sgtitle('Contribution to the cost $F$');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 7];
if plot_param.print_figure == 1
  export_figure(fig, 'cost_fraction_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
end

%% CO2 fraction
num_costs =  size([values_solution{1,1,1}.cost_fraction(:).val], 2);

for b=1:num_sweep
  for i=1:num_sim
    CO2_DG = values_solution{1,b,i}.Ev * (REC.DGv.DGv_obj{1}.mu*REC.DGv.DGv_obj{1}.alpha_g);
    CO2_GT = CO2_emitted{1,b,i} - CO2_DG;
    CO2(i,1:2,b) = [CO2_DG, CO2_GT];
  end
end

for i=1:num_sim
  numerator = 0;
  numerator = sum(values_vector{1,b,i}.P_DGv);
  if isfield(values_vector{1,b,i}, 'P_GT')
    numerator = numerator + sum(values_vector{1,b,i}.P_GT,'all');
  end
  E_NREC_frac(i) = numerator / sum(values_vector{1,b,i}.Pload) *100; % fraction of load energy produced by non-renewable sources
end

fig = figure('Color', 'w'); hold on; grid on; box on;
br = bar(CO2/1e6, 'stacked');
br(1).FaceColor = color(1);
if length(br) >= 2
  br(2).FaceColor = color(12);
end
ylim([0, 1.05*max(sum(CO2,2)/1e6)])
yyaxis right
plot(E_NREC_frac, 'o--', 'Color', color(2), 'LineWidth', 1.5)
xticks([1:1:num_sim]);
xticklabels(case_sim_vec);
if  ~(strcmp(sweep_type, 'None'))
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'best';
  lg.ItemTokenSize = [10 10];
end

yyaxis left
ay = ylabel('$CO_{2}$ [Mkg]');
ay.Interpreter = 'latex';
ay.FontSize = 6.5;
ay = gca;
ay.FontSize = 6.5;
yyaxis right
ay = ylabel('$\frac{E_{NREC}}{E_{LOAD}} [\%]$');
ay.Interpreter = 'latex';
ay.FontSize = 6.5;
ay = gca;
ay.FontSize = 6.5;
ay.YColor = color(2);
ylim([0,105])

% legend
if length(br) == 1
  lg = legend('$CO_2$ from DG','Fraction of fossil');
else
  lg = legend('$CO_2$ from DG','$CO_2$ from GT','Fraction of fossil');
end
lg.Interpreter = 'latex';
lg.NumColumns = 1;
lg.ItemTokenSize = [10 10];
lg.Location = 'NorthEast';

set(gca,'TickLabelInterpreter','latex')
tl = title('$CO_{2}$ prodution repartition and non renewable energy fraction');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'CO2_fraction_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
end
end
%% Installed power

if  ~(strcmp(sweep_type, 'None'))
  for i=1:num_sim
    for b=1:num_sweep
      P_TOT_REC(b, i) = values_solution{1,b,i}.P_TOT_REC;
      P_PV_inst_frac(b, i) = values_solution{1,b,i}.P_PV_inst/P_TOT_REC(b, i)*100;
      P_WT_inst_frac(b, i) = values_solution{1,b,i}.P_WT_inst/P_TOT_REC(b, i)*100;
      P_WEC_inst_frac(b, i) = values_solution{1,b,i}.P_WEC_inst/P_TOT_REC(b, i)*100;
      E_BESS_inst(b, i) = values_solution{1,b,i}.Ebt_max;
      P_BESS_inst(b, i) = values_solution{1,b,i}.x_ESS_NIV;
      P_DGv_max(b, i) = max(values_solution{1,b,i}.P_DGv_max);
      Ev_max(b, i) = values_solution{1,b,i}.Ev;
    end
  end
  
%% Installed power and percentages  
  fig = figure('Color', 'w'); 
  for i=1:num_sim
    if rem(num_sim,2) == 0
     subplot(ceil(num_sim/2)+1, 2, i);
    else
      subplot(ceil(num_sim/2), 2, i);
    end
    hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    yyaxis left
    plot(sweep_vec, P_TOT_REC(:,i)/1e6, 'o-', 'LineWidth', 1.5, 'DisplayName', 'TOT', 'Color', color(1))
    yyaxis right
    plot(sweep_vec, P_PV_inst_frac(:,i), 'x-', 'LineWidth', 1.5, 'DisplayName', 'PV', 'Color', color(2))
    plot(sweep_vec, P_WT_inst_frac(:,i), 'd-', 'LineWidth', 1.5, 'DisplayName', 'WT+DG', 'Color', color(2))
    plot(sweep_vec, P_WEC_inst_frac(:,i), 's-', 'LineWidth', 1.5, 'DisplayName', 'WEC', 'Color', color(2))
    yyaxis left
    ay = ylabel('$[MW]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    ay.YColor = color(1); % set y label color
    yyaxis right
    ar = ylabel('\%');
    ar.Interpreter = 'latex';
    ar.FontSize = 6.5;
    ar = gca;
    ar.FontSize = 6.5;
    ar.YColor = color(2); % set y label color
    if i==num_sim || i==num_sim-1 
      xl = xlabel(sweep_name);
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
  end
  if rem(num_sim,2) == 0
     subplot(ceil(num_sim/2)+1, 2, num_sim+1.5);
  else
    subplot(ceil(num_sim/2), 2, num_sim+1);
  end
  hold on;
  plot(NaN, NaN, 'o-', 'LineWidth', 1.5, 'DisplayName', 'TOT', 'Color', color(1))
  plot(NaN, NaN, 'x-', 'LineWidth', 1.5, 'DisplayName', 'PV', 'Color', color(2))
  plot(NaN, NaN, 'd-', 'LineWidth', 1.5, 'DisplayName', 'WT+DG', 'Color', color(2))
  plot(NaN, NaN, 's-', 'LineWidth', 1.5, 'DisplayName', 'WEC', 'Color', color(2))
  axis off; % Turn off the axis
  lg = legend();
  lg.Interpreter = 'latex';
  lg.NumColumns = 6;
  lg.ItemTokenSize = [10 10];
  lg.Location = 'best';
  set(gca,'TickLabelInterpreter','latex')
  tl = sgtitle('Installed REC power and composition');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8*2 5*ceil(num_sim/2)];
  if plot_param.print_figure == 1
    export_figure(fig, 'installed_power_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end
  
  %% Installed BESS power and energy
  fig = figure('Color', 'w'); 
  for i=1:num_sim
    if strcmp(sweep_type, 'DGpower') 
      subplot(2, ceil(num_sim/2), i);
    else 
      if rem(num_sim,2) == 0
        subplot(ceil(num_sim/2)+1, 2, i);
      else
        subplot(ceil(num_sim/2), 2, i);
      end
    end
    hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    yyaxis left
    if strcmp(sweep_type, 'DGpower')
      plot(sweep_vec'*REC.DG.DG_obj{1}.base_power/1e6, P_BESS_inst(:, i)/1e6, '-', 'LineWidth', 1.5, 'DisplayName', 'Power', 'Color', color(1),'HandleVisibility','off')
    else
      plot(sweep_vec, P_BESS_inst(:, i)/1e6, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Power', 'Color', color(1))
    end
    yt = yticks;
    rounded_yt = round(yt, 2);
    if all(rounded_yt == rounded_yt(1)) % all elements are equal
      rounded_yt = rounded_yt(1);
    end
    yticks(rounded_yt);
    yticklabels(string(rounded_yt));
    yyaxis right
    if strcmp(sweep_type, 'DGpower')
      plot(sweep_vec'*REC.DG.DG_obj{1}.base_power/1e6, E_BESS_inst(:, i)/1e6, '-', 'LineWidth', 1.5, 'DisplayName', 'Energy', 'Color', color(2),'HandleVisibility','off')
    else
      plot(sweep_vec,  E_BESS_inst(:, i)/1e6, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Energy', 'Color', color(2))
    end
    yyaxis left
    ay = ylabel('$[MW]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    ay.YColor = color(1); % set y label color
    yyaxis right
    ar = ylabel('$[MWh]$');
    ar.Interpreter = 'latex';
    ar.FontSize = 6.5;
    ar = gca;
    ar.FontSize = 6.5;
    ar.YColor = color(2); % set y label color
    if i==num_sim || i==num_sim-1 
      if strcmp(sweep_type, 'DGpower')
        xl = xlabel('$P_{DG} [MW]$');
      else
        xl = xlabel(sweep_name);
      end
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
  end
  
  if strcmp(sweep_type, 'DGpower')
    plot(NaN, NaN, '-', 'LineWidth', 1.5, 'DisplayName', 'Power', 'Color', color(1))
    plot(NaN, NaN, '-', 'LineWidth', 1.5, 'DisplayName', 'Energy', 'Color', color(2))
  else
    if rem(num_sim,2) == 0
     subplot(ceil(num_sim/2)+1, 2, num_sim+1.5);
    else
      subplot(ceil(num_sim/2), 2, num_sim+1);
    end
    plot(NaN, NaN, 'o-', 'LineWidth', 1.5, 'DisplayName', 'Power', 'Color', color(1))
    plot(NaN, NaN, 'x-', 'LineWidth', 1.5, 'DisplayName', 'Energy', 'Color', color(2))
    axis off; % Turn off the axis
  end
  lg = legend();
  lg.Interpreter = 'latex';
  lg.NumColumns = 6;
  lg.ItemTokenSize = [10 10];
  lg.Location = 'best';
  set(gca,'TickLabelInterpreter','latex')
  tl = sgtitle('Installed BESS power and energy');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  if strcmp(sweep_type, 'DGpower') 
    fig.Position = [0 0 8.8*ceil(num_sim/2) 5*2];
  else
    fig.Position = [0 0 8.8*2 5*ceil(num_sim/2)];
  end
  if plot_param.print_figure == 1
    export_figure(fig, 'BESS_energy_power_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end
  
  %% CVaR 
  fig = figure('Color', 'w'); hold on; grid on; box on;
  for b=1:num_sweep
    for i=1:num_sim
      plot(i, values_solution{1, b, i}.CVaR, 'o', 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
    end
    plot(NaN,NaN,'Color',color(b),'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))], 'LineWidth', 1.5, 'LineStyle','none', 'Marker','o');
  end
  xticks([1:1:num_sim]);
  xticklabels(case_sim_vec);
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'northwest';
  lg.ItemTokenSize = [10 10];
  % xl = xlabel('Case');
  % xl.Interpreter = 'latex';
  % xl.FontSize = 6.5;
  ay = ylabel('$CVaR \ [\$]$');
  ay.Interpreter = 'latex';
  ay.FontSize = 6.5;
  ay = gca;
  ay.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex', 'YScale', 'log')
  tl = title('$CVaR$');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8 5];
  if plot_param.print_figure == 1
    export_figure(fig, 'CVaR_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end

  %% beta*CVaR 
  fig = figure('Color', 'w'); hold on; grid on; box on;
  for b=1:num_sweep
    for i=1:num_sim
      plot(i, values_solution{1, b, i}.cvar, 'o', 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
    end
    plot(NaN,NaN,'Color',color(b),'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))], 'LineWidth', 1.5, 'LineStyle','none', 'Marker','o');
  end
  xticks([1:1:num_sim]);
  xticklabels(case_sim_vec);
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'northwest';
  lg.ItemTokenSize = [10 10];
  % xl = xlabel('Case');
  % xl.Interpreter = 'latex';
  % xl.FontSize = 6.5;
  ay = ylabel('$\beta CVaR \ [\$]$');
  ay.Interpreter = 'latex';
  ay.FontSize = 6.5;
  ay = gca;
  ay.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex', 'YScale', 'log')
  tl = title('$\beta CVaR$');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8 5];
  if plot_param.print_figure == 1
    export_figure(fig, 'betaCVaR_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end

end

%% Effective LPSP
if strcmp(sweep_type, 'LPSP')

  fig = figure('Color', 'w'); hold on; grid on; box on;
  for b=1:num_sweep
    for i=1:num_sim
      plot(i, values_solution{1, b, i}.LPSP_eff*100, 'o', 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
    end
    plot(NaN,NaN,'Color',color(b),'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b)*100), ' \%'], 'LineWidth', 1.5, 'LineStyle','none', 'Marker','o');
  end
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'northwest';
  lg.ItemTokenSize = [10 10];
  % xl = xlabel('Case');
  % xl.Interpreter = 'latex';
  % xl.FontSize = 6.5;
  xticks([1:1:num_sim]);
  xticklabels(case_sim_vec);
  ay = ylabel('LPSP [\%]');
  ay.Interpreter = 'latex';
  ay.FontSize = 6.5;
  ay = gca;
  ay.FontSize = 6.5;
  set(gca, 'TickLabelInterpreter', 'latex')
  tl = title('Effective and maximum LPSP');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8 5];
  if plot_param.print_figure == 1
    export_figure(fig, 'LPSP_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end
  
end

%% VaR
% fig = figure('Color', 'w'); hold on; grid on; box on;
% for b=1:num_sweep
%   for i=1:num_sim
%     plot(i, values_solution{1, b, i}.cvar_zeta/1e6, 'o', 'LineWidth', 1.5, 'Color', color(b), 'HandleVisibility', 'off');
%   end
%   plot(NaN,NaN,'Color',color(b),'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))], 'LineWidth', 1.5, 'LineStyle','none', 'Marker','o');
% end
% lg = legend();
% lg.Interpreter = 'latex';
% lg.Location = 'northwest';
% lg.ItemTokenSize = [10 10];
% % xl = xlabel('Case');
% % xl.Interpreter = 'latex';
% % xl.FontSize = 6.5;
% xticks([1:1:num_sim]);
% xticklabels(case_sim_vec);
% ay = ylabel('VaR [M\$]');
% ay.Interpreter = 'latex';
% ay.FontSize = 6.5;
% ay = gca;
% ay.FontSize = 6.5;
% set(gca, 'TickLabelInterpreter', 'latex')
% tl = title('VaR');
% tl.Interpreter = 'latex';
% tl.FontSize = 6.5;
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% if plot_param.print_figure == 1
%   export_figure(fig, 'VaR_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
% end


%% Virtual power
if strcmp(sweep_type, 'DGpower')
  fig = figure('Color', 'w'); 
  for i=1:num_sim
    subplot(2, ceil(num_sim/2), i);
    hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    yyaxis left
    plot(sweep_vec'*REC.DG.DG_obj{1}.base_power/1e6, P_DGv_max(:, i)/1e6, '-', 'LineWidth', 1.5, 'DisplayName', 'Power', 'Color', color(1),'HandleVisibility', 'off')
    plot(sweep_vec'*REC.DG.DG_obj{1}.base_power/1e6, (sweep_vec'*REC.DG.DG_obj{1}.base_power + P_DGv_max(:, i))/1e6, '--', 'LineWidth', 1.5, 'DisplayName', 'Power', 'Color', color(3),'HandleVisibility', 'off')
    
    tmp = P_DGv_max(:, i) <= 1;
    if sum(tmp) >= 1
      idx = find(tmp == 1, 1);
      xline(sweep_vec(idx)'*REC.DG.DG_obj{1}.base_power/1e6, 'r--', 'HandleVisibility','off')
    end
    yt = yticks;
    rounded_yt = round(yt, 2);
    if all(rounded_yt == rounded_yt(1)) % all elements are equal
      rounded_yt = rounded_yt(1);
    end
    yticks(rounded_yt);
    yticklabels(string(rounded_yt));
    yyaxis right
    plot(sweep_vec'*REC.DG.DG_obj{1}.base_power/1e6,  Ev_max(:, i)/1e6, '-', 'LineWidth', 1.5, 'DisplayName', 'Energy', 'Color', color(2),'HandleVisibility', 'off')
    yyaxis left
    ay = ylabel('$\Delta P_{v}, \Delta P_{v}+P_{DG} [MW]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    ay.YColor = color(1); % set y label color
    yyaxis right
    ar = ylabel('$E_{v} [MWh]$');
    ar.Interpreter = 'latex';
    ar.FontSize = 6.5;
    ar = gca;
    ar.FontSize = 6.5;
    ar.YColor = color(2); % set y label color
    if i==num_sim || i==num_sim-1 
      xl = xlabel('$P_{DG}$ [MW]');
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
  end
  plot(NaN, NaN, '-', 'LineWidth', 1.5, 'DisplayName', '$\Delta P_{v}$', 'Color', color(1))
  plot(NaN, NaN, '-', 'LineWidth', 1.5, 'DisplayName', '$\Delta E_{v}$', 'Color', color(2))
  plot(NaN, NaN, '--', 'LineWidth', 1.5, 'DisplayName', '$\Delta P_{v} + P_{DG}$', 'Color', color(3))
  lg = legend();
  lg.Interpreter = 'latex';
  lg.NumColumns = 1;
  lg.ItemTokenSize = [12 10];
  lg.Location = 'southeast';
  set(gca,'TickLabelInterpreter','latex')
  tl = sgtitle('Virtual power and energy');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8*ceil(num_sim/2) 5*2];
  if plot_param.print_figure == 1
    export_figure(fig, 'virtual_power_energy_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end
end

%%
%  __        __    _ _                        __ _ _      
%  \ \      / / __(_) |_ ___    ___  _ __    / _(_) | ___ 
%   \ \ /\ / / '__| | __/ _ \  / _ \| '_ \  | |_| | |/ _ \
%    \ V  V /| |  | | ||  __/ | (_) | | | | |  _| | |  __/
%     \_/\_/ |_|  |_|\__\___|  \___/|_| |_| |_| |_|_|\___|
                                                        
if plot_param.print_figure == 1
  file_name = 'results/res_table_2025_03_05_365_varPS';
  caption = 'Results of the optimization for the decarbonization problem';
  label = 'table_results_2025_03_05_365_varPS';

  switch sweep_type
    case 'None'
      write_results_on_table(case_sim_vec, {values_solution{:,1,:}}, {values_minvalue{:,1,:}}, {CO2_emitted{:,1,:}}, {time_sim{:,1,:}}, num_sim, file_name, caption, label); % sim variations
    otherwise
      write_results_on_table_ParamVariation(string(sweep_vec), values_solution, values_minvalue, CO2_emitted, time_sim, case_sim_vec, sweep_vec, file_name, caption, label);
  end
  file_name = 'results/cost_red_table_2025_03_05_365_varPS';
  caption = 'Cost variation with respect to the case with PS=0\%';
  label = 'cost_red_table_2025_03_05_365_varPS';
  write_results_on_table_cost_saving_horizontal(case_sim_vec, {values_solution(1,:,:)}, {values_minvalue(1,:,:)}, sweep_vec, num_sim, file_name, caption, label);

end

%%
%   _   _       _                        _ 
%  | \ | | ___ | |_   _   _ ___  ___  __| |
%  |  \| |/ _ \| __| | | | / __|/ _ \/ _` |
%  | |\  | (_) | |_  | |_| \__ \  __/ (_| |
%  |_| \_|\___/ \__|  \__,_|___/\___|\__,_|
                                         

if figure_enable == 1

  %% GT power
  if  strcmp(case_sim, 'GT24') ||  strcmp(case_sim, 'GT365') ||  strcmp(case_sim, '1GT+WT+DG')
    fig = figure('Color', 'w'); hold on; grid on; box on; box on;
    for g=1:REC.GT.n_NREC
      plot(reshape(values_solution.P_GT(:,:,g), [],1), 'DisplayName',['GT', num2str(g)], 'LineWidth',1.5)
    end
    plot(values_vector.Pns, 'DisplayName','NS', 'LineWidth',1.5)
    plot(values_vector.Pct,'DisplayName','PCT', 'LineWidth',1.5)
    plot(values_vector.Pload, '--', 'DisplayName','LOAD', 'LineWidth',1.5)
    xline([1:size(Pload,1):size(Pload,1)*size(Pload,2)], 'r--', 'HandleVisibility','off')
    lg = legend();
    lg.Interpreter = 'latex';
    lg.Location = 'northeast';
    ay = ylabel('Power $\left[W\right]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    xl = xlabel('$ t \left[s\right] $');
    xl.Interpreter = 'latex';
    xl.FontSize = 6.5;
    tl = title('Powers');
    tl.Interpreter = 'latex';
    tl.FontSize = 6.5;
    set(gca,'TickLabelInterpreter','latex')
    fig.Units = "centimeters";
    fig.Position = [0 0 8.8 5];
    if plot_param.print_figure == 1
      export_figure(fig, 'GT_power_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
    end
  end
  
  %% GT + REC power 
  if strcmp(case_sim, '1GT+WT+DG')
    fig = figure('Color', 'w');hold on; grid on; box on; box on;
    plot(sum(values_vector.P_GT, 3), 'DisplayName', 'Tot GT', 'LineWidth', 1.5) % Total GT power
    plot(sum(values_vector.P_GT, 3) + values_vector.P_res, 'DisplayName', 'Tot GT + REC', 'LineWidth', 1.5) % Total GT power
    plot(sum(values_vector.P_GT, 3) - values_vector.Pbt, 'DisplayName','P_GT - Pbt', 'LineWidth', 1.5)
    plot(values_vector.P_res, 'DisplayName','REC', 'LineWidth', 1.5)
    plot(reshape(Pload, [],1), '--', 'DisplayName','LOAD', 'LineWidth', 1.5)
    % xline([1:size(Pload,1):size(Pload,1)*size(Pload,2)], 'r--', 'HandleVisibility','off')
    lg = legend();
    lg.Interpreter = 'latex';
    lg.Location = 'northeast';
    ay = ylabel('Power $\left[W\right]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    xl = xlabel('$ t \left[s\right] $');
    xl.Interpreter = 'latex';
    xl.FontSize = 6.5;
    tl = title('Powers');
    tl.Interpreter = 'latex';
    tl.FontSize = 6.5;
    set(gca,'TickLabelInterpreter','latex')
    fig.Units = "centimeters";
    fig.Position = [0 0 8.8 5];
    if plot_param.print_figure == 1
      export_figure(fig, 'GT_REC_power_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
    end
  end
  
  %% REC power
  if strcmp(case_sim, '1GT+WT+DG' )|| strcmp(case_sim, '1GT+REC+DG')
    fig = figure('Color', 'w');hold on; grid on; box on; box on;
    plot(values_vector.P_res, 'DisplayName','REC', 'LineWidth', 1.5)
    plot(values_vector.Pns, 'DisplayName','NS', 'LineWidth', 1.5)
    plot(values_vector.Pct,'DisplayName','PCT', 'LineWidth', 1.5)
    plot(values_vector.Pload, '--', 'DisplayName','LOAD', 'LineWidth', 1.5)
    xline([1:size(Pload,1):size(Pload,1)*size(Pload,2)], 'r--', 'HandleVisibility','off')
    lg = legend();
    lg.Interpreter = 'latex';
    lg.Location = 'northeast';
    ay = ylabel('Power $\left[W\right]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    xl = xlabel('$ t \left[s\right] $');
    xl.Interpreter = 'latex';
    xl.FontSize = 6.5;
    tl = title('Powers');
    tl.Interpreter = 'latex';
    tl.FontSize = 6.5;
    set(gca,'TickLabelInterpreter','latex')
    fig.Units = "centimeters";
    fig.Position = [0 0 8.8 5];
    if plot_param.print_figure == 1
      export_figure(fig, 'REC_power_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
    end
  end 
  
  %% Diesel + REC
  if strcmp(case_sim, 'WT+DG') || strcmp(case_sim, 'REC-U')
    fig = figure('Color', 'w');hold on; grid on; box on; box on;
    plot(values_vector.P_res, 'DisplayName','REC', 'LineWidth', 1.5)
    plot(values_vector.Pns, 'DisplayName','NS', 'LineWidth', 1.5)
    plot(values_vector.Pct,'DisplayName','PCT', 'LineWidth', 1.5)
    plot(values_vector.Pload, '--', 'DisplayName','LOAD', 'LineWidth', 1.5)
    plot(values_vector.P_DG, 'DisplayName','DG', 'LineWidth', 1.5)
    xline([1:size(Pload,1):size(Pload,1)*size(Pload,2)], 'r--', 'HandleVisibility','off')
    lg = legend();
    lg.Interpreter = 'latex';
    lg.Location = 'northeast';
    ay = ylabel('Power $\left[W\right]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    xl = xlabel('$ t \left[s\right] $');
    xl.Interpreter = 'latex';
    xl.FontSize = 6.5;
    tl = title('Powers');
    tl.Interpreter = 'latex';
    tl.FontSize = 6.5;
    set(gca,'TickLabelInterpreter','latex')
    fig.Units = "centimeters";
    fig.Position = [0 0 8.8 5];
    if plot_param.print_figure == 1
      export_figure(fig, 'DIESEL_REC_power_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
    end
  end
  
  %% ESS energy
  if strcmp(case_sim, '1GT+WT+DG') || strcmp(case_sim, '1GT+REC+DG') || strcmp(case_sim, '2GT+REC+DG') || strcmp(case_sim, 'WT+DG') || strcmp(case_sim, 'REC-U') || strcmp(case_sim, 'REC-C+DG24')
    fig = figure('Color', 'w');hold on; grid on; box on; box on;
    plot(values_vector.Ebt, 'DisplayName','Ebt', 'LineWidth', 1.5)
    yline(values_solution.E0, 'LineWidth', 1.5, 'LineStyle', '--', 'DisplayName', 'E0')
    xline([1:size(Pload,1):size(Pload,1)*size(Pload,2)], 'r--', 'HandleVisibility','off')
    lg = legend();
    lg.Interpreter = 'latex';
    lg.Location = 'northeast';
    ay = ylabel('Energy $\left[Wh\right]$');
    ay.Interpreter = 'latex';
    ay.FontSize = 6.5;
    ay = gca;
    ay.FontSize = 6.5;
    xl = xlabel('$ t \left[s\right] $');
    xl.Interpreter = 'latex';
    xl.FontSize = 6.5;
    tl = title('BESS energy');
    tl.Interpreter = 'latex';
    tl.FontSize = 6.5;
    set(gca,'TickLabelInterpreter','latex')
    fig.Units = "centimeters";
    fig.Position = [0 0 8.8 5];
    if plot_param.print_figure == 1
      export_figure(fig, 'BESS_energy_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
    end
  end

  %% Virtual power
  fig = figure('Color', 'w'); 
  for i=1:num_sim
    subplot(ceil(num_sim/2), 2, i); hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    for b=1:num_sweep
      plot(reshape(values_vector{a,b,i}.P_DGv/1e6, [],1), 'LineWidth',1.5, 'Color',color(b), 'HandleVisibility','off')
    end
    if i==num_sim || i==num_sim-1 
      xl = xlabel('$ t \left[s\right] $');
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
  end
  % subplot(ceil(num_sim/2), 2, num_sim+1); hold on; 
  % axis off
  for b=1:num_sweep
    plot(NaN, NaN, 'LineWidth',1.5, 'Color',color(b), 'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))])
  end
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'best';
  tl = sgtitle('$P_v$ power [MW]');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8*2 5*ceil(num_sim/2)];
  if plot_param.print_figure == 1
    export_figure(fig, 'P_DGv_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end

  %% Not satisfied power
  fig = figure('Color', 'w'); hold on; grid on; box on;
  for i=1:num_sim
    subplot(ceil(num_sim/2), 2, i); hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    for b=num_sweep:-1:1
      plot(values_vector{1, b, i}.Pns/1e6, 'LineWidth',1.5, 'Color',color(b),'HandleVisibility','off')
    end
    if i==num_sim || i==num_sim-1 
      xl = xlabel('$ t \left[s\right] $');
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
  end
  % subplot(ceil(num_sim/2), 2, num_sim+1); hold on; 
  % axis off
  for b=num_sweep:-1:1
    plot(NaN, NaN, 'LineWidth',1.5, 'Color',color(b), 'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))])
  end
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'northeast';
  tl = sgtitle('$P_{ns}$ [MW]');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8*2 5*ceil(num_sim/2)];
  if plot_param.print_figure == 1
    export_figure(fig, 'Pns_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end
  
  %% Totoal REC power
  fig = figure('Color', 'w'); hold on; grid on; box on;
  for i=1:num_sim
    subplot(ceil(num_sim/2), 2, i); hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    for b=num_sweep:-1:1
      plot(values_vector{1,b,i}.P_res/1e6, 'LineWidth',1.5, 'Color',color(b), 'HandleVisibility','off')
    end
    if i==num_sim || i==num_sim-1 
      xl = xlabel('$ t \left[s\right] $');
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
  end
  % subplot(ceil(num_sim/2), 2, num_sim+1); hold on; 
  % axis off
  for b=num_sweep:-1:1
    plot(NaN, NaN, 'LineWidth',1.5, 'Color',color(b), 'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))])
  end
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'northeast';
  tl = sgtitle('$P_{REC,tot}$ [MW]');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8*2 5*ceil(num_sim/2)];
  if plot_param.print_figure == 1
    export_figure(fig, 'P_TOT_REC_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end

%%
num_sim = 2;
num_sweep=4;
  fig = figure('Color', 'w'); hold on; grid on; box on;
  for i=1:num_sim
    subplot(ceil(num_sim/2), 2, i); hold on; grid on; box on;
    title(case_sim_vec{i}, 'Interpreter', 'latex', 'FontSize', 6.5)
    for b=num_sweep:-1:1
      plot((values_vector{1,b,i}.P_res+values_vector{1,b,i}.Pdc+values_vector{1,b,i}.P_DG)/1e6, 'LineWidth',1.5, 'Color',color(b), 'HandleVisibility','off')
      plot(values_vector{1,b,i}.Pdc/1e6, '--', 'Color', color(b))
      plot(values_vector{1,b,i}.Ebt/1e6/3, '-.', 'Color', color(b))
      plot(values_vector{1,b,i}.Pload/1e6, ':', 'Color',color(b))
    end
    if i==num_sim || i==num_sim-1 
      xl = xlabel('$ t \left[s\right] $');
      xl.Interpreter = 'latex';
      xl.FontSize = 6.5;
    end
    set(gca,'TickLabelInterpreter','latex')
    plot(values_vector{1,b,i}.Pload/1e6, 'LineWidth',1.5, 'LineStyle','--', 'Color', color(num_sim + 1))
  end
  % subplot(ceil(num_sim/2), 2, num_sim+1); hold on; 
  % axis off
  for b=num_sweep:-1:1
    plot(NaN, NaN, 'LineWidth',1.5, 'Color',color(b), 'DisplayName',[sweep_name{1}, ' = ', num2str(sweep_vec(b))])
  end
  lg = legend();
  lg.Interpreter = 'latex';
  lg.Location = 'northeast';
  tl = sgtitle('$P_{REC,tot}$ [MW]');
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')
  fig.Units = "centimeters";
  fig.Position = [0 0 8.8*2 5*ceil(num_sim/2)];
  if plot_param.print_figure == 1
    export_figure(fig, 'P_TOT_REC_2025_03_05_365_varPS.pdf', '..\presentation\may_2025\figure');
  end
end