close all;
clc

plot_param.print_figure = 1;
deloading_coeff = 0.1;

set(0,'DefaultFigureWindowStyle','normal');

file_name = '2020ATB_NREL_Reference_8MW_180.csv';
data        = readmatrix(file_name);
PC_wind     = data(:, 1);
PC_power    = data(:, 2);
PC_deloaded = PC_power * (1 - deloading_coeff);

F = figure('Color', 'w'); hold on;
pl = plot(PC_wind, PC_power/1e3);
pl.LineWidth = 2;
pl.DisplayName = 'Nominal power';

% % Deloaded operation
% pl_deload = plot(PC_wind, PC_deloaded/1e3);
% pl_deload.LineWidth = 2;
% pl_deload.DisplayName = 'Min. deloaded power';
% x_axis = [PC_wind; flip(PC_wind)]';
% inBetween = [PC_power; flip(PC_deloaded)]/1e3;
% fill_energy = fill(x_axis, inBetween, color(2));  % plot filled area
% fill_energy.FaceAlpha = 0.2;
% fill_energy.DisplayName = 'Deloaded operation';
% fill_energy.EdgeColor = 'none';

legend('Location', 'south', 'Interpreter', 'latex', 'FontSize', 6.5);

ax = xlabel('Wind speed [m/s]', 'Interpreter','latex');
ax = gca;
ax.FontSize = 6.5;
ay = ylabel('Power [MW]', 'Interpreter','latex');
ay = gca;
ay.FontSize = 6.5;
title('Wind turbine power curve', 'Interpreter','latex', 'FontSize', 6.5);
grid on;
box on;

ylim([min(PC_power), 1.05*max(PC_power)/1e3])

set(gca,'TickLabelInterpreter','latex')
% Position and size
F.Units = "centimeters";
F.Position = [0 0 8.8 5];

if plot_param.print_figure == 1
  % exportgraphics(F, '..\report\figure\vectorial\power_curve_3MW_deload.pdf','BackgroundColor','none','ContentType','vector');
  exportgraphics(F, '..\report\figure\vectorial\power_curve_8MW.pdf','BackgroundColor','none','ContentType','vector');
end
