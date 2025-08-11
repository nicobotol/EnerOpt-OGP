% Define the variables related to the battery energy storage system (BESS) model

% x_ESS = [N_ESS]
x_ESS_IV  = optimvar('x_ESS_IV', [num_ESS,1], 'lowerBound', zeros(num_ESS, 1), 'Type', 'integer');
      
% x_ESS_NIV = [Pbt_max]
x_ESS_NIV = optimvar('x_ESS_NIV', [num_ESS,1], 'lowerBound', [0], 'Type', 'continuous');

% Initial state of charge of the battery
E0 = optimvar('E0', 1, 'lowerBound', [0], 'Type', 'continuous');

% Battery energy 
Ebt = optimvar('Ebt', [T, W], 'lowerBound', [0], 'Type', 'continuous');

% Battery charging/discharging power
Pbt = optimvar('Pbt', [T, W], 'Type', 'continuous');

% battery SOC soft constraint 
epsilon_bat = optimvar('epsilon_bat', 1, 'Type', 'continuous', 'LowerBound', 0); 

% Virtual power
delta_ESS_Pmax = optimvar('delta_ESS_Pmax', [T, W, num_ESS], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); 


% Define the initial condition for the solver
x0.x_ESS_IV = 1e6*ones([num_ESS,1]);
x0.x_ESS_NIV = 1e6*ones([num_ESS,1]);
x0.E0 = 0.5*x0.x_ESS_IV;
x0.Ebt = x0.E0*ones([T, W]);
x0.Pbt = zeros([T, W]);
x0.epsilon_bat = 0;
x0.delta_ESS_Pmax = zeros([T, W, num_ESS]);