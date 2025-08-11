function prob = lin_ContBin(prob, name, y, x, delta, M, m)
% Linearize the product between a continuous and a binary variable 
% prob -> optimproblem
% name -> constraint name
% x -> continuous variable
% delta -> binary variable
% y = x*delta
% M = max(x)
% m = min(x)

prob.Constraints.([name, '1']) = y <= M*delta;
prob.Constraints.([name, '2']) = y >= m*delta;
prob.Constraints.([name, '3']) = y <= x - m*(1 - delta);
prob.Constraints.([name, '4']) = y >= x - M*(1 - delta);

end