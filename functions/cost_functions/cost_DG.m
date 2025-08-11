function [cTx, qTy_w] = cost_DG(DG_obj, AF, n_DG, P_DG, x_DG, u_DG, T, W)
  % cost related to the Diesel generators

  % 1st stage variable cost
  c = zeros(n_DG, 1);
  for r = 1:n_DG
    c(r) = DG_obj{r}.C_I;
  end
  
  % 2nd stage variable cost
  for g = 1:n_DG
    qTg = [DG_obj{g}.C_per_watt*ones(T, 1); DG_obj{g}.C_on*ones(T, 1)]';
    y_G(1,1:W,g)  = qTg*[P_DG(:,:,g);u_DG(:,:,g)];
  end
  
  cTx = AF.CRF *c'*x_DG;
  qTy_w = sum(y_G, 3);
end
