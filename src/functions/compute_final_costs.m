values_solution = evaluate_cost(values_solution, 'cTx', (1 - cvar_beta)*cTx);
switch case_constraint
  case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'}
    values_solution.cTx_GT = (1 - cvar_beta)*cTx_GT;
    values_minvalue = values_minvalue + values_solution.cTx_GT;
  otherwise
    values_solution = evaluate_cost(values_solution, 'cTx_GT', (1 - cvar_beta)*cTx_GT);
end
values_solution = evaluate_cost(values_solution, 'cTx_BESS', (1 - cvar_beta)*cTx_BESS);
values_solution = evaluate_cost(values_solution, 'cTx_REC', (1 - cvar_beta)*cTx_REC);
values_solution = evaluate_cost(values_solution, 'cTx_DG', (1 - cvar_beta)*cTx_DG);
values_solution = evaluate_cost(values_solution, 'cTx_Pv', (1 - cvar_beta)*cTx_Pv);
values_solution = evaluate_cost(values_solution, 'qTy', (1 - cvar_beta)*AF.gamma*qTy_w*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'qTy_GT', (1 - cvar_beta)*AF.gamma*qTy_w_GT*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'qTy_BESS', (1 - cvar_beta)*AF.gamma*qTy_w_BESS*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'qTy_Pns_Pct', (1 - cvar_beta)*AF.gamma*qTy_w_Pns_Pct*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'qTy_DG', (1 - cvar_beta)*AF.gamma*qTy_w_DG*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'qTy_DR', (1 - cvar_beta)*AF.gamma*qTy_w_DR*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'qTy_Pv', (1 - cvar_beta)*AF.gamma*qTy_w_Pv*LscensProbVec_N);
values_solution = evaluate_cost(values_solution, 'wTz', (1 - cvar_beta)*wTz);
values_solution = evaluate_cost(values_solution, 'cvar', cvar_beta*cvar);

values_solution.qTy = values_solution.qTy ; % - values_solution.qTy_Pv;
values_solution.values_minvalue = values_minvalue;

values_solution.cTx_GT_fraction = values_solution.cTx_GT/values_minvalue;
values_solution.cTx_BESS_fraction = values_solution.cTx_BESS/values_minvalue;
values_solution.cTx_REC_fraction = values_solution.cTx_REC/values_minvalue;
values_solution.cTx_DG_fraction = values_solution.cTx_DG/values_minvalue;
values_solution.cTx_Pv_fraction = values_solution.cTx_Pv/values_minvalue;
values_solution.qTy_fraction = values_solution.qTy/values_minvalue;
values_solution.qTy_GT_fraction = values_solution.qTy_GT/values_minvalue;
values_solution.qTy_BESS_fraction = values_solution.qTy_BESS/values_minvalue;
values_solution.qTy_Pns_Pct_fraction = values_solution.qTy_Pns_Pct/values_minvalue;
values_solution.qTy_DG_fraction = values_solution.qTy_DG/values_minvalue;
values_solution.qTy_DR_fraction = values_solution.qTy_DR/values_minvalue;
values_solution.wTz_fraction = values_solution.wTz/values_minvalue;
values_solution.cvar_fraction = values_solution.cvar/values_minvalue;
values_solution.qTy_Pv_fraction = values_solution.qTy_Pv/values_minvalue;

values_solution.cost_fraction(7).val = values_solution.cTx_GT_fraction;
values_solution.cost_fraction(7).name = '$c^{T}x_{GT}$';
values_solution.cost_fraction(9).val = values_solution.cTx_BESS_fraction;
values_solution.cost_fraction(9).name = '$c^{T}x_{BESS}$';
values_solution.cost_fraction(4).val = values_solution.cTx_REC_fraction;
values_solution.cost_fraction(4).name = '$c^{T}x_{REC}$';
values_solution.cost_fraction(3).val = values_solution.cTx_Pv_fraction;
values_solution.cost_fraction(3).name = '$c^{T}x_{DG}$';
values_solution.cost_fraction(1).val = values_solution.qTy_GT_fraction;
values_solution.cost_fraction(1).name = '$q^{T}y_{GT}$';
values_solution.cost_fraction(5).val = values_solution.qTy_Pns_Pct_fraction;
values_solution.cost_fraction(5).name = '$q^{T}y_{Pns}$';
values_solution.cost_fraction(2).val = values_solution.qTy_Pv_fraction;
values_solution.cost_fraction(2).name = '$q^{T}y_{DG}$';
values_solution.cost_fraction(6).val = values_solution.wTz_fraction;
values_solution.cost_fraction(6).name = ' $w^{T}z$ ';
values_solution.cost_fraction(8).val = values_solution.cvar_fraction;
values_solution.cost_fraction(8).name = '$cvar$';

%    __                  _   _             
%   / _|_   _ _ __   ___| |_(_) ___  _ __  
%  | |_| | | | '_ \ / __| __| |/ _ \| '_ \ 
%  |  _| |_| | | | | (__| |_| | (_) | | | |
%  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|
                                        
% evaluate the cost function after the solution
function values_solution = evaluate_cost(values_solution, name, expression)
  if isa(expression,'optim.problemdef.OptimizationExpression')
    values_solution.(name) = evaluate(expression, values_solution);
  else
    values_solution.(name) = 0;
  end
end