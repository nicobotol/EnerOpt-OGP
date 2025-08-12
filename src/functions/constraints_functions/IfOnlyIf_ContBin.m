function prob = IfOnlyIf_ContBin(prob, name, f, delta, M, m, epsilon)
% Impose the implication: F <= 0 <=> delta = 1
% prob -> optimproblem
% name -> constraint name
% f -> continuous variable
% delta -> binary variable
% M = max(x)
% m = min(x)
% epsilon -> tolerance

prob.Constraints.([name, '1']) = f <= M*(1 - delta);
prob.Constraints.([name, '2']) = f >= epsilon + (m - epsilon)*delta;

end