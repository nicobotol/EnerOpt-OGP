function [cTx, qTy_w] = cost_GT(GT_obj, AF, n_GT, P_GT, u_GT, z_GT, RR, x_GT, T, W, tau)
  % cost related to the GTs

  % 1st stage variable cost
  c = zeros(n_GT, 1);
  for g = 1:n_GT
    c(g) = GT_obj{g}.C_I;
  end
  
  % 2nd stage variable cost
  % cost associated with the GTs
  for g = 1:n_GT
    qTg = [GT_obj{g}.C_per_watt*ones(T, 1); GT_obj{g}.C_on*ones(T, 1); GT_obj{g}.C_start*ones(T, 1); GT_obj{g}.C_RR*ones(T, 1)]';
    y_G(1,1:W,g)  = qTg*[P_GT(:,:,g);u_GT(:,:,g);z_GT(:,:,g)/tau;RR(:,:,g)];
  end
  
  cTx = AF.CRF*c'*x_GT;
  qTy_w = sum(y_G, 3);
end
