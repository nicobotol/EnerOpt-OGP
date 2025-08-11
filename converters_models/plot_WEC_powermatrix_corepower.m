%    ____                                            
%   / ___|___  _ __ ___ _ __   _____      _____ _ __ 
%  | |   / _ \| '__/ _ \ '_ \ / _ \ \ /\ / / _ \ '__|
%  | |__| (_) | | |  __/ |_) | (_) \ V  V /  __/ |   
%   \____\___/|_|  \___| .__/ \___/ \_/\_/ \___|_|   
%                      |_|                           
                                   
% clear;
close all;
clc;

plot_param.print_figure = 1;

% Load the data
pelamis_filename        = 'pelamis_P750_power_matrix.csv';
pelamis_axes_filename   = 'pelamis_P750_power_matrix_axes.csv';
dataLines_PM            = [1, inf];
dataLines_axes          = [4, inf];
WEC                     = WECX();
WEC.import_powermatrix_pelamisP750(pelamis_filename, dataLines_PM, pelamis_axes_filename, dataLines_axes);


fig = figure('Color', 'w');
v = [0.1:0.1:0.7]; % level set to be plotted
v = [v, 0.75];
[C, pl] = contourf(WEC.PowerMatrixAxes(:,2), WEC.PowerMatrixAxes(1:16,1), WEC.PowerMatrix/1e6, v);
pl.FaceAlpha = 0.8; % opacity of the plot
clabel(C, pl, v, 'FontSize', 6.5, 'Interpreter', 'latex'); % add labels to the contour lines

colormap(slanCM('blues'));

xlim([4.5, max(WEC.PowerMatrixAxes(:,2))])
ylim([1, max(WEC.PowerMatrixAxes(1:16,1))])
ax = xlabel("Wave Height $H_s$ [m]", "Interpreter", "latex");
ax = gca;
ax.FontSize = 6.5;
ay = ylabel("Wave Energy Period $T_e$ [s]", "Interpreter", "latex");
ay = gca;
ay.FontSize = 6.5;

fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];

title("Pelamis P750 Power Matrix [MW]", "Interpreter", "latex", "FontSize", 6.5);
set(gca,'TickLabelInterpreter','latex')

box on

if plot_param.print_figure == 1
  exportgraphics(fig,'..\report\figure\vectorial\corpower_power_matrix.pdf','BackgroundColor','none','ContentType','vector')
end