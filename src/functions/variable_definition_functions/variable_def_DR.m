%% Define variable related to the demand response mechanism

Pps_rem = optimvar('Pps_rem', [T, W], 'lowerbound', [0], 'Type', 'continuous'); % shifted power: power removed from the normal load
Pps_add = optimvar('Pps_add', [T, W], 'lowerbound', [0], 'Type', 'continuous'); % shifted power: power added to the normal load

x0.Pps_rem = zeros([T, W]);
x0.Pps_add = zeros([T, W]);