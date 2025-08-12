function [prob] = MIN_AB(prob, name, delta, zeta, y, A, B, M, m, epsilon) 
  % This function returns the constraints for modelling :
  %  y = min(A, B)

  prob = IfElse(prob, name, delta, zeta, y, B, A, A - B, M, m, epsilon);

end