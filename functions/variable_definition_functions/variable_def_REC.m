% x = [N_PV, N_WT, N_WEC]
x_REC = optimvar('x_REC', [n_REC,1], 'lowerBound', zeros(n_REC, 1), 'Type', 'integer');
P_res = optimvar('P_res', [T, W], 'lowerBound', [0], 'Type', 'continuous');

delta_REC_Pmax = optimvar('delta_REC_Pmax', [T, W, n_REC], 'lowerBound', 0, 'UpperBound', 1, 'Type', 'integer');

x0.x_REC = ones([n_REC,1]);
x0.P_res = zeros([T, W]);
x0.delta_REC_Pmax = zeros([T, W, n_REC]);