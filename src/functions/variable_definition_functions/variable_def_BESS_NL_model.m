% Define the variables related to the battery energy storage system (BESS) model

% Shelf degradation
theta_sh = BAT.deg_cost_enable*scenario.tau/BAT.L_sh;

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

x_ESS_IV_max = max_phy_Ebt/BAT.C_batt; % maximum value of the variable x_ESS_IV
x_ESS_IV_min = 0; % minimum value of the variable x_ESS_IV

% x_ESS = [N_ESS]
x_ESS_IV  = optimvar('x_ESS_IV', [num_ESS,1], 'lowerBound', x_ESS_IV_min, 'UpperBound', x_ESS_IV_max, 'Type', 'integer');
x_ESS_presence  = optimvar('x_ESS_presence', [num_ESS,1], 'lowerBound', 0, 'UpperBound', 1, 'Type', 'integer'); % variable indicating the presence of the BESS
      
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

% max degradation cost
max_theta   = max(max(BAT.y_deg)/2, theta_sh); % max value that theta can get

Ki          = max(1, ceil(log2(x_ESS_IV_max - x_ESS_IV_min))); % number of points for the binary expansion of the product between damage and battery module number
b_expansion = 2.^(0:Ki-1)'; % binary expansion coefficients
% b_expansion_tensor  = repmat(reshape(b_expansion', 1, 1, []), T, W, 1);
% zeta_theta  = optimvar('zeta_theta', [T-1,W,Ki], 'Type', 'continuous', 'LowerBound', 0,  'UpperBound', max_theta); % helper variable for linearize the product theta*x_ESS_IV
% u_theta     = optimvar('u_theta', [T-1,W,Ki], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % helper variable for linearize the product theta*x_ESS_IV
zeta_pla    = optimvar('zeta_pla', [T,W,BAT.num_points_deg_approx,Ki], 'Type', 'continuous', 'LowerBound', 0,  'UpperBound', 1); % helper variable for linearize the product alpha_pla*x_ESS_IV
zeta_psi    = optimvar('zeta_psi', [T,W,BAT.num_points_deg_approx], 'Type', 'continuous', 'LowerBound', 0,  'UpperBound', 1); % helper variable for linearize the product alpha_pla*x_ESS_presence
u_pla       = optimvar('u_pla', [Ki], 'Type', 'integer', 'LowerBound', 0,  'UpperBound', 1); % helper variable for linearize the product alpha_pla*x_ESS_IV
alpha_pla   = optimvar('alpha_pla', [T,W,BAT.num_points_deg_approx], 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', 1); % continuous helper variable for the PLA
h_pla       = optimvar('h_pla', [T,W,BAT.num_points_deg_approx+1], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % integer helper variable for the PLA

z_max = optimvar('z_max', [T-1, W, 2], 'lowerBound', 0, 'UpperBound', 1, 'Type', 'integer'); % helper variable for obtaining theta = max(theta_cy, theta_sh)
z_abs = optimvar('z_abs', [T-1, W], 'lowerBound', 0, 'UpperBound', 1, 'Type', 'integer'); % helper integer variable for obtaining theta_cy(t) = abs(psi(t) - psi(t-1))
y_abs = optimvar('y_abs', [T-1, W], 'lowerBound', 0, 'UpperBound', 2*max_theta, 'Type', 'continuous'); % helper integer variable defined as y_abs(t) = abs(psi(t) - psi(t-1))

% battery degradation cost
theta       = optimvar('theta', [T-1,W], 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', max_theta); % damage
xEssIv_theta= optimvar('xEssIv_theta', [T-1,W], 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', max_theta*x_ESS_IV_max); % damage times number of installed BESS module
z_xEssIv_theta=optimvar('z_xEssIv_theta', [T-1,W,Ki], 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', x_ESS_IV_max); % helper for linearize the product between theta*x_ESS_IV

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