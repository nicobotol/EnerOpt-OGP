% Define the variables for the DG model

% x = [n_DG]
x_DG = optimvar('x_DG', [REC.DG.n_NREC, 1], 'lowerBound', zeros(1, REC.DG.n_NREC), 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

% DG variables
P_DG  = optimvar('P_DG', [T, W, REC.DG.n_NREC], 'LowerBound', 0, 'Type', 'continuous'); % power output of the DG

% Output power equal to the maximum installed
delta_DG_Pmax = optimvar('delta_DG_Pmax', [T, W, REC.DG.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); 

x0.x_DG = ones([REC.DG.n_NREC_DG, 1]);
x0.P_DG = zeros([T, W, REC.DG.n_NREC]);
x0.delta_DG_Pmax = zeros([T, W, REC.DG.n_NREC]);