% This file plots the input resources and the corresponding generated scenario 

close all;

% Load
plot_comparison(reshape(Pload, scenario.T, []), reshape(LselScens_N, scenario.T, []), 'Load', '[W]');

% Wind
plot_comparison(reshape(met_data(:,2), scenario.T, []), reshape(ResselScens_N{1}, scenario.T, []), 'Wind', '[m/s]');

% PV
plot_comparison(reshape(met_irradiance, scenario.T, []), reshape(ResselScens_N{2}, scenario.T, []), 'Irradiance', '[$\frac{W}{m^2}$]');

% Wave
plot_comparison(reshape(met_SWH, scenario.T, []), reshape(ResselScens_N{3}, scenario.T, []), 'Significant wave height', '[m]');
plot_comparison(reshape(met_W_period, scenario.T, []), reshape(ResselScens_N{4}, scenario.T, []), 'Wave period', '[s]');


function [] = plot_comparison(loaded, generated, Title, mu)
  num_integers = 15;

  idx_l = randperm(size(loaded, 2) - 1 + 1, num_integers) + 1 - 1;
  idx_g = randperm(size(generated, 2) - 1 + 1, num_integers) + 1 - 1;

  fig = figure('Color', 'w'); hold on; grid on;
  plot(loaded(:, idx_l), 'linewidth', 0.75, 'DisplayName', 'Loaded', 'HandleVisibility', 'off', 'Color', color(1));
  plot(generated(:, idx_g), 'linewidth', 0.75, 'DisplayName', 'Generated', 'HandleVisibility', 'off', 'Color', color(2));
  plot(NaN, NaN, 'linewidth', 0.75, 'DisplayName', 'Loaded', 'Color', color(1));
  plot(NaN, NaN, 'linewidth', 0.75, 'DisplayName', 'Generated', 'Color', color(2));
  legend("Interpreter", 'latex');
  xlabel('Time [h]', "Interpreter", 'latex')
  ylabel(mu, "Interpreter", 'latex')
  title(Title, "Interpreter", 'latex')

end