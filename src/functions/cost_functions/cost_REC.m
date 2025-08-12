function [cTx, P_REC_max, P_REC_individual] = cost_REC(REC_obj, AF, n_REC, x_REC)
  % cost related to the RECs: they don't have operational costs, but only installation ones

  P_REC_max = 0;
  P_REC_individual = zeros(size(REC_obj{1}.Power, 1)*size(REC_obj{1}.Power, 2), n_REC);

  % 1st stage variable cost
  c = zeros(n_REC, 1);
  for r = 1:n_REC
    c(r) = (AF.CRF*REC_obj{r}.C_CAPEX + AF.YtD*REC_obj{r}.C_OPEX)*REC_obj{r}.PowRated;
    
    P_REC_max = P_REC_max + REC_obj{r}.Power*x_REC(r);

    P_REC_individual(:, r) = reshape(REC_obj{r}.Power, [], 1);
  end
  
  cTx = c'*x_REC;
  
  % 2nd stage variable cost
  
end
