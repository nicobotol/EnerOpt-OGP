% Define the variables related to the battery energy storage system (BESS) model

% Maximum BESS physical power and energy
if strcmp(case_constraint, 'REC-U') 
  % case of unconstrained REC and BESS
  max_phy_Pbt = Inf;
  max_phy_Ebt = Inf;
else 
  % case of constrained REC and BESS
  max_phy_Pbt = BAT.Pch_max;
  max_phy_Ebt = BAT.E_max;
end


% x_ESS = [N_ESS]
x_ESS_IV  = optimvar('x_ESS_IV', [num_ESS,1], 'lowerBound', zeros(num_ESS, 1), 'UpperBound', max_phy_Ebt/BAT.C_batt, 'Type', 'integer');
      
% x_ESS_NIV = [Pbt_max]
x_ESS_NIV = optimvar('x_ESS_NIV', [num_ESS,1], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');

% Initial state of charge of the battery
E0        = optimvar('E0', 1, 'lowerBound', [0], 'UpperBound', max_phy_Ebt, 'Type', 'continuous');

% Battery energy 
Ebt       = optimvar('Ebt', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Ebt, 'Type', 'continuous');

% Battery charging and discharging power
Pch       = optimvar('Pch', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');
Pdc       = optimvar('Pdc', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');

% Battery charging and discharging indicators
Uch       = optimvar('Uch', [T, W], 'lowerBound', [0],'upperBound', [1], 'Type', 'integer');
Udc       = optimvar('Udc', [T, W], 'lowerBound', [0],'upperBound', [1], 'Type', 'integer');

% Battery charging and discharging nonlinear variable
PchUch    = optimvar('PchUch', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');
PdcUdc    = optimvar('PdcUdc', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');

% battery SOC soft constraint 
epsilon_bat = optimvar('epsilon_bat', 1, 'LowerBound', [0], 'UpperBound', max_phy_Ebt, 'Type', 'continuous'); 

% Virtual power
delta_ESS_Pmax = optimvar('delta_ESS_Pmax', [T, W, num_ESS], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % 1 if the max power is installed
delta_ESS_Emax = optimvar('delta_ESS_Emax', [T, W, num_ESS], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % 1 if the max energy is installed
delta_ESS_Emin = optimvar('delta_ESS_Emin', [T, W, num_ESS], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % 1 if the min energy is reached
delta_ESS_Pdcmax = optimvar('delta_ESS_Pdcmax', [T, W, num_ESS], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % 1 if the max power is discharged
delta_ESS_Pchmax = optimvar('delta_ESS_Pchmax', [T, W, num_ESS], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % 1 if the max power is charged

% Define the initial condition for the solver
x0.x_ESS_IV     = ones([num_ESS,1]);
x0.x_ESS_NIV    = ones([num_ESS,1]);
x0.E0           = 0.5*x0.x_ESS_IV;
x0.Ebt          = x0.E0*ones([T, W]);
x0.Pch          = zeros([T, W]);
x0.Pdc          = zeros([T, W]);
x0.Uch          = zeros([T, W]);
x0.Udc          = zeros([T, W]);
x0.PchUch       = zeros([T, W]);
x0.PdcUdc       = zeros([T, W]);
x0.epsilon_bat  = 0;
x0.delta_ESS_Pmax = zeros([T, W, num_ESS]);
x0.delta_ESS_Emax = zeros([T, W, num_ESS]);
x0.delta_ESS_Emin = zeros([T, W, num_ESS]);
x0.delta_ESS_Pdcmax = zeros([T, W, num_ESS]);
x0.delta_ESS_Pchmax = zeros([T, W, num_ESS]);