function [p, y_hat] = PLA_approximation_rescaled(p, name, h, alpha, zeta_x, zeta_y, u_x, X, X_L, X_U, X_indicator, S, b, x_points, y_points, x_hat)
  % piecewise linear approximation of a function, rescaling the approximation points by an integer variable, and providing the output only if a condition is met
  %
  % p           -> optimization problem
  % name        -> constraint name
  % h           -> binary variable for selecting the interval of the PLA
  % alpha       -> continuous variable for the convex combination of the PLA
  % zeta_x      -> continuous helper variable for rescaling x-axis: zeta_x = x_points*X
  % zeta_y      -> continuous helper variable for enabling y output: y = alpha*y_points*X_indicator
  % u_x         -> binary helper variable for rescaling x-axis
  % X           -> integer variable rescaling the x-axis
  % X_L         -> lower bound of X ( X_L = min(X) )
  % X_U         -> upper bound of X ( X_U = max(X) )
  % X_indicator -> helper variable for enabling the output if X is non negative (X_indicator = 1 <=> X >= 0)
  % S           -> integer scalar factor for rescaling the x-axis (i.e. it is not a variable) 
  % b           -> binary expansion coefficients for writing the integer variable X
  % x_points    -> x-points of the function to approximate
  % y_points    -> y-points of the function to approximate: y_points = f(x_points)
  % x_hat       -> x value where to approximate the function
  %
  % y_hat       -> approximated value of the function: y_hat = f(x_hat)

  T = size(x_hat, 1);
  W = size(x_hat, 2);
  x_tensor = repmat(reshape(x_points', 1, 1, []), T, W, 1);
  y_tensor = repmat(reshape(y_points', 1, 1, []), T, W, 1);
  Ki = length(b);

  p.Constraints.([name, '_h']) = sum(h(:,:,2:end-1), 3) == 1;

  p.Constraints.([name, '_h_init'])  = h(:,:,1)    == 0;
  p.Constraints.([name, '_h_fin'])   = h(:,:,end)  == 0;
  
  int_points = size(alpha, 3); % number of points used for the PLA
  i = 1:1:int_points;
  p.Constraints.([name, '_alpha']) = alpha(:,:,i) <= h(:,:,i) + h(:,:,i+1);  

  p.Constraints.([name, '_alpha_sum']) = sum(alpha,3) == 1;

  % express the integer variable X with a binary expansion
  tmp = b'*u_x;
  p.Constraints.([name, '_X_equivalence']) = X == X_L + tmp; 

  % Rewrite:
  % x_hat = S*alpha'*x_points*X
  % such that the product of variables alpha*X is linearized. Use helper variables zeta_x(T,W,n,k) = alpha(T,W,n)*u_x(k)
  tmp_sum = 0;
  for n=1:int_points
    for k=1:Ki
      tmp_sum = tmp_sum + b(k)*x_points(n)*zeta_x(:,:,n,k); 
      c_name = [name, '_lin_dem_', num2str(n), '_', num2str(k)];
      p = lin_ContBin(p, c_name, zeta_x(:,:,n,k), alpha(:,:,n), u_x(k), 1, 0); % linearization of zeta_x = alpha*x
    end
  end
  p.Constraints.([name, '_x_hat']) = x_hat == S*(sum(alpha.*x_tensor, 3)*X_L + tmp_sum);

  % % compute the approximated value of the function, imposing that the output is larger than 0 if and only if X is non negative
  % y_hat = sum(alpha.*y_tensor, 3); 
  % p = IfOnlyIf_ContBin(p, [name, '_X_iff'], 1-X, X_indicator, 1, 1-X_U, 1);

  y_hat = sum(zeta_y.*y_tensor, 3); 
  p = lin_ContBin(p, [name, '_y_hat'], zeta_y, alpha, X_indicator, 1, 0);


  % Set X_indicator==1 <=> 1-x<=0 
  % p = IfOnlyIf_ContBin(p, [name, '_X_iff'], 1-X, X_indicator, 1+1e-6, 1-X_U-1e-6, 1e-6); % WORKING
  % p = IfOnlyIf_ContBin(p, [name, '_X_iff'], 1-X, X_indicator, 1+1e-1, 1-X_U-1e-1, 1e-1); % WORKING BETTER
  p = IfOnlyIf_ContBin(p, [name, '_X_iff'], 1-X, X_indicator, 1+9e-1, 1-X_U-9e-1, 9e-1); 
end


