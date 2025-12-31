function [cTx, qTy_w] = cost_BESS(BAT, AF, T, x_ESS_IV, x_ESS_NIV, xEssIv_theta)
  % cost related to the BESS
  % BAT -> object of the battery
  % AF  -> annualization factor
  % x_ESS_IV -> number of battery energy modules
  % x_ESS_NIV -> number of battery power modules
  % x_ESS_IV_min -> minimum number of battery power modules
  % xEssIv_theta -> damage factor times number of BESS installed


  % 1st stage variable cost
  CAPEX_IV  = (BAT.C_CAPEX_E)*BAT.C_batt;
  OPEX_IV   = (BAT.C_OPEX_E)*BAT.C_batt;
  CAPEX_NIV = BAT.C_CAPEX_P;
  OPEX_NIV  = BAT.C_OPEX_P;

  cTx_ESS_IV_CAPEX  = CAPEX_IV * x_ESS_IV;
  cTx_ESS_NIV_CAPEX = CAPEX_NIV * x_ESS_NIV;
  cTx_ESS_IV_OPEX   = OPEX_IV * x_ESS_IV;
  cTx_ESS_NIV_OPEX  = OPEX_NIV * x_ESS_NIV;
  cTx_CAPEX = cTx_ESS_IV_CAPEX + cTx_ESS_NIV_CAPEX;
  cTx_OPEX  = cTx_ESS_IV_OPEX + cTx_ESS_NIV_OPEX;

  cTx = (AF.CRF*cTx_CAPEX + AF.YtD*cTx_OPEX);
  
  % 2nd stage variable cost
  % qTy_w = 0;
  if BAT.deg_cost_enable == 1  
    qTy_w = ones(T-1,1)'*xEssIv_theta*CAPEX_IV*(1 - BAT.eol_fraction); % cost of depletion for each scenario

  else 
    qTy_w = 0;
  end


end