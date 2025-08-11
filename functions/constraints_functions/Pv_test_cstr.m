

close all;clc;clear;

epsilon = 1e-5;
M = 10;
m = -10;

prob = optimproblem; 
x = optimvar('x', 1, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
y = optimvar('y', [10,1], 'LowerBound', -10, 'UpperBound', 1e1);
Pv = optimvar('Pv', [10,1], 'LowerBound', 0, 'UpperBound', 1e1, 'Type','continuous');

Pload = 2*ones(10,2);
Pload(end) = 1.5;
P_REC = x*ones(10,1);

prob.Constraints.min_energy = P_REC + Pv == Pload ;
prob.Objective = x + sum(Pv)*1e3;

delta = optimvar('delta', [10,1], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
zeta = optimvar('zeta', [10,1], 'LowerBound', 0, 'UpperBound', M);
% prob = MAX_AB(prob, delta, zeta, 'Test', y, Pv, P_REC, M, m, epsilon);
prob = MIN_AB(prob, delta, zeta, 'Test', y, Pv, P_REC, M, m,  epsilon);

opt = optimoptions("intlinprog", "Display", "iter", "RelativeGapTolerance",3e-2, 'IntegerTolerance',1e-3, 'MaxTime', 2*3600, 'Heuristics', 'advanced');
prob.ObjectiveSense = 'minimize';
[values_solution, values_minvalue_with_Pv, tmp, min_info] = solve(prob, 'Options', opt);

values_solution.y