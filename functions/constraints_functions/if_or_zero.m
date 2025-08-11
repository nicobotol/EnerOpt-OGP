function [prob, delta] = if_or_zero(prob, name, c, x, M, m, epsilon)
% Implement a logic such that the real variable x_delta is equal to x if a condition c is true, otherwise it is zero
%
% x_delta = x if c>=0 else 0;

delta_name = ['delta_', name];

delta = optimvar(delta_name, 1, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

prob.Constraints.([name, '1']) = -m*delta <= c - m;
prob.Constraints.([name, '2']) = -(M + epsilon)*delta <= - c - epsilon;

end