function prob = lin_ContInt(prob, name, z, x, y, u, x_U, i_L, b)
% Linearize the product between a continuous and an integer variable (see Tutorial on Advanced Optimization by Wei and Tsinghua)
%
% y = x*i = x*i_L + b'*z  
%
% prob -> optimproblem
% name -> constraint name
% x -> continuous variable
% i -> integer variable: i = i_L + b'u
% x_L = max(x)
% x_U = min(x)
% i_L = max(i)
% i_U = min(i)
% z -> helper variable: z(k) = x*u(k), with u(k) binary variable for expressing the integer


Ki = length(b); % number of integers used in the expansion

tmp_sum = 0;
for k=1:Ki
  tmp_sum = tmp_sum + b(k)*z(:,:,k); 
  c_name  = [name, '_lin_dem_', num2str(k)];
  prob    = lin_ContBin(prob, c_name, z(:,:,k), x, u(k), x_U, 0); % linearization of z = u*x
end
prob.Constraints.([name, '_sum']) = y == x*i_L + tmp_sum;   

end