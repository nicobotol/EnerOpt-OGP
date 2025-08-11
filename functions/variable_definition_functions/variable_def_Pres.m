% Power produced by the renewable energy sources
P_res = optimvar('P_res', [T, W], 'lowerBound', [0], 'Type', 'continuous');

x0.P_res = zerso([T, W]);