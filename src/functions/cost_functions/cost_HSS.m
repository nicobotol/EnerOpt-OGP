function [cTx, qTy_w] = cost_HSS(HSS, AF, x_IV, x_HSS_el, x_HSS_fc, W, rev_FC)
  % cost related to the BESS

  num_HSS = length(x_HSS_el);
  cTx = 0;
  if rev_FC == 0 % separated fuel cell and electrolyzer
    for i = 1:num_HSS
      c = zeros(1, 3);
      c(1) =  HSS.C_unitaryP_el*(AF.CRF* HSS.C_CAPEX_el + AF.YtD* HSS.C_OPEX_el);  % cost electrolyzer
      c(2) =  HSS.C_unitaryP_fc*(AF.CRF* HSS.C_CAPEX_fc + AF.YtD* HSS.C_OPEX_fc);  % cost fuel cell
      c(3) =  AF.CRF* HSS.C_CAPEX_st + AF.YtD* HSS.C_OPEX_st;  % cost storage tank
      x = [x_HSS_el(i), x_HSS_fc(i), x_IV(i)]';
      cTx = cTx + c*x;
    end

  else % reversible fuel cell and electrolyzer
    for i = 1:num_HSS
      c = zeros(1, 2);
      c(1) = HSS.C_unitaryP_fc*(AF.CRF* HSS.C_CAPEX_rev_FC + AF.YtD* HSS.C_OPEX_rev_FC);  % cost electrolyzer
      c(2) = AF.CRF* HSS.C_CAPEX_st + AF.YtD* HSS.C_OPEX_st;  % cost storage tank
      x = [x_HSS_fc(i), x_IV(i)]';
      cTx = cTx + c*x;
    end

  end

  % 2nd stage variable cost
  qTy_w = zeros(1, W);

end