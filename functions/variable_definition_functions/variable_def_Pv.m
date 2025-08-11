% Virtual power to be added to fix the power balance
Pv = optimvar('Pv', [T, W], 'lowerBound', [0], 'UpperBound', Pv_max, 'Type', 'continuous');
% u_Pv = optimvar('u_Pv', [T, W], 'lowerBound', [0], 'upperBound', 1, 'Type', 'integer'); % ON/OFF status of the virtual power
% delta_Pv = optimvar('delta_Pv', [T, W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % binary variable to define the virtual power state (i.e. 1 iff Pv is provided)
% zeta_Pv = optimvar('zeta_Pv', [T, W], 'lowerBound', [0], 'UpperBound', Pv_max, 'Type', 'continuous'); % helper variable to linearize the product between Pv and u_Pv


delta_Pv_max = optimvar('delta_Pv_max', [1, W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % variable equal to 1 if the the condition for allowing the use of the virtual power is satisfied
Pv_max_inst = optimvar('Pv_max_inst', 1, 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', Pload_obj.P_shaved_overpower*Pload_obj.P_rated);
z_Pv_max = optimvar('z_Pv_max', [1, W], 'Type', 'continuous');


x0.Pv = zeros([T, W]);
x0.delta_Pv = zeros([T, W]);
x0.delta_Pv_max = ones(1, W);
x0.z_Pv_max = ones(1, W);
x0.Pv_max_inst = 0;
% x0.h_Pv = zeros([T, W]);