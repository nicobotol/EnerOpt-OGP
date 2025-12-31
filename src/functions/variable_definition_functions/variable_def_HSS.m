% Define the variables related to the hydrogen storage system (HSS) model
% The necessary equipment are the electrolyzer, the fuel cell, and the storage tank

% x_HSS =  number of H2 tanks
x_HSS_IV  = optimvar('x_HSS_IV', [num_HSS,1], 'lowerBound', zeros(num_HSS, 1), 'Type', 'integer', 'UpperBound', HSS.E_H_max/HSS.C_storage_u); % number of H2 tanks
x_HSS_el  = optimvar('x_HSS_el', [num_HSS,1], 'lowerBound', zeros(num_HSS, 1), 'Type', 'continuous', 'UpperBound', HSS.Pel_max/HSS.C_unitaryP_el); % maximum power of the electrolyzer
x_HSS_fc  = optimvar('x_HSS_fc', [num_HSS,1], 'lowerBound', zeros(num_HSS, 1), 'Type', 'continuous', 'UpperBound', HSS.Pfc_max/HSS.C_unitaryP_fc); % maximum power of the fuel cell

if HSS.rev_FC == 1 % in case of reversible fuel cell there is no electrolyzer
  x_HSS_el = 0;

  % HSS charging and discharging indicators
  Uel     = optimvar('Uel', [T, W], 'lowerBound', [0],'upperBound', [1], 'Type', 'integer');
  Ufc     = optimvar('Ufc', [T, W], 'lowerBound', [0],'upperBound', [1], 'Type', 'integer');
  
  % HSS charging and discharging nonlinear variable
  PelUel  = optimvar('PelUel', [T, W], 'lowerBound', [0], 'UpperBound', HSS.Pel_max, 'Type', 'continuous');
  PfcUfc  = optimvar('PfcUfc', [T, W], 'lowerBound', [0], 'UpperBound', HSS.Pfc_max, 'Type', 'continuous');
else
  PelUel = 0;
  PfcUfc = 0;
  Uel = 0;
  Ufc = 0;
end

% Initial state of charge of the hydrogen tank
E_H0 = optimvar('E_H0', [num_HSS,1], 'lowerBound', [0], 'Type', 'continuous', 'UpperBound', HSS.E_H_max); % initial state of charge of the hydrogen tank

% Hydrogen in the tank
E_H = optimvar('E_H', [T, W, num_HSS], 'lowerBound', [0], 'Type', 'continuous', 'UpperBound', HSS.E_H_max);

% Power of the electrolyzer
Pel = optimvar('Pel', [T, W, num_HSS], 'LowerBound', 0, 'Type', 'continuous', 'UpperBound', HSS.Pel_max);

% Power of the fuel cell
Pfc = optimvar('Pfc', [T, W, num_HSS], 'LowerBound', 0, 'Type', 'continuous', 'UpperBound', HSS.Pfc_max);


x0.x_HSS_IV = zeros([num_HSS,1]);
x0.x_HSS_el = zeros([num_HSS,1]);
x0.x_HSS_fc = zeros([num_HSS,1]);
x0.E_H0       = zeros([num_HSS,1]);
x0.E_H      = x0.E_H0*ones([T, W, num_HSS]);
x0.Pel      = zeros([T, W, num_HSS]);
x0.Pfc      = zeros([T, W, num_HSS]);





