function [prob] = IfElse(prob, name, delta, zeta, y, A, B, c, M, m, epsilon) 
  % this function models the if-else statement such that:
  %  y = A if c >= 0 else B
  %
  % prob -> optimisation problem
  % delta -> binary variable
  % zeta -> continuous variable
  % name -> name of the constraint
  % y -> variable to be constrained
  % A -> value of y if c >= 0
  % B -> value of y if c < 0
  % c -> condition
  % M -> max(A - B)
  % m -> min(A - B)
  % epsilon -> small value to avoid numerical issues

  % Set delta = 1 <=> c >= 0 
  prob.Constraints.([name, '1']) = -m*delta <= c - m;
  prob.Constraints.([name, '2']) = -(M + epsilon)*delta <= - c - epsilon;

  % Set y = (A - B)*delta + B
  % defining zeta = (A - B)*delta
  prob.Constraints.([name, '3']) = y == zeta + B;
  prob.Constraints.([name, '4']) = zeta <= M*delta;
  prob.Constraints.([name, '5']) = zeta >= m*delta;
  prob.Constraints.([name, '6']) = zeta <= (A - B) - m*(1 - delta);
  prob.Constraints.([name, '7']) = zeta >= (A - B) - M*(1 - delta);  
end