function [prob] = MAX_AB(prob, name, delta, zeta, y, A, B, M, m, epsilon) 
  % This function returns the constraints for modelling :
  %  y = max(A, B)

  prob = IfElse(prob, name, delta, zeta, y, A, B, A-B, M, m, epsilon);

end