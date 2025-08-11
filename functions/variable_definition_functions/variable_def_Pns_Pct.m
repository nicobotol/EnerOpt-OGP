% Not satisfied load and dumped power

% Dumped power
Pct = optimvar('Pct', [T, W], 'lowerBound', [0], 'Type', 'continuous');
% Not satisfied load
Pns = optimvar('Pns', [T, W], 'lowerBound', [0], 'Type', 'continuous');

x0.Pct = zeros([T, W]);
x0.Pns = zeros([T, W]);