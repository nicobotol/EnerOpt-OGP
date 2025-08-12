% Virtual power to be added to fix the power balance
P_DGv = optimvar('P_DGv', [T, W], 'lowerBound', [0], 'UpperBound', P_DGv_max, 'Type', 'continuous');

delta_P_DGv_max = optimvar('delta_P_DGv_max', [1, W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % variable equal to 1 if the the condition for allowing the use of the virtual power is satisfied
P_DGv_max_inst = optimvar('P_DGv_max_inst', 1, 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', Pload_obj.P_shaved_overpower*Pload_obj.P_rated);
z_P_DGv_max = optimvar('z_P_DGv_max', [1, W], 'Type', 'continuous');


x0.P_DGv = zeros([T, W]);
x0.delta_P_DGv = zeros([T, W]);
x0.delta_P_DGv_max = ones(1, W);
x0.z_P_DGv_max = ones(1, W);
x0.P_DGv_max_inst = 0;
% x0.h_P_DGv = zeros([T, W]);