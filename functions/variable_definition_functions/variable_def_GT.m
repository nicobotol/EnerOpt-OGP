% Define the variables for the GT model

% x = [REC.GT.n_NREC]
x_GT = optimvar('x_GT', [REC.GT.n_NREC, 1], 'lowerBound', zeros(1, REC.GT.n_NREC), 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

% GT variables
P_GT = optimvar('P_GT', [T, W, REC.GT.n_NREC], 'LowerBound', 0, 'Type', 'continuous'); % power output of the GT
u_GT = optimvar('u_GT', [T, W, REC.GT.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % ON/OFF status of the GT
z_GT = optimvar('z_GT', [T, W, REC.GT.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % startup indicator of the GT
RR = optimvar('RR', [T, W, REC.GT.n_NREC], 'Type', 'continuous', 'LowerBound', 0); % absolute value of the ramping rate

z_help = optimvar('z_help', [T, W, REC.GT.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % helper variable for removing the nonlinearity

delta_GT_Pmax = optimvar('delta_GT_Pmax', [T, W, REC.GT.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); 

x0.x_GT = ones([REC.GT.n_NREC, 1]);
x0.P_GT = zeros([T, W, REC.GT.n_NREC]);
x0.u_GT = zeros([T, W, REC.GT.n_NREC]);
x0.z_GT = zeros([T, W, REC.GT.n_NREC]);
x0.RR = zeros([T, W, REC.GT.n_NREC]);
x0.z_help = zeros([T, W, REC.GT.n_NREC]);
x0.delta_GT_Pmax = zeros([T, W, REC.GT.n_NREC]);