function [cTx, qTy_w] = cost_Pv(AF, Pv, T, Pv_max_inst, PV_obj)
  % cost related to the virtual power

  cTx = AF.CRF * Pv_max_inst * PV_obj.C_I;

  % qTp = [load_scenarios.Pv_cost*ones(T, 1)]';
  
  qTp = [PV_obj.C_per_watt*ones(T, 1)]';
  
  qTy_w = qTp*[Pv];

  % qTy_w = load_scenarios.Pv_cost*sum(sum(Pv)); 

end
