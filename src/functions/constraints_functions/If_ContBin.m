function prob = If_ContBin(prob, name, f, delta, M, m, epsilon)
% Impose the implication: F <= 0 => delta = 1
% prob -> optimproblem
% name -> constraint name
% f -> continuous variable
% delta -> binary variable
% M = max(x)
% m = min(x)
% epsilon -> tolerance

prob.Constraints.(name) = f >= epsilon + (m - epsilon)*delta;

end