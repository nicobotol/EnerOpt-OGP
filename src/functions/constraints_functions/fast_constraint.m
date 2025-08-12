

x_PV_max = sum(Pload - P_REC_max - sum(P_GT, 3)); 

P_max_feasibility = 0; 
for r = 1:n_REC
  P_max_feasibility = P_max_feasibility + REC_obj{r}.max_installed_power;
end
for g=1:REC.GT.n_NREC
  P_max_feasibility = P_max_feasibility + GT_obj{g}.PowRated;
end


x0.delta_Pv_max = ones(1, W);
x0.z_Pv_max = ones(1, W);
x0.Pv_max_inst = 0;

name = ['Pv_delta'];
condition = -x_PV_max;
m = -T*Pload_obj.P_shaved_overpower*Pload_obj.P_rated;
M = T*P_max_feasibility;

% prob = Pv_max_plant_size(prob, name, sum(Pv), sum(Pv_max), condition, 0, delta_Pv_max, M,  m, epsilon );

prob = IfOnlyIf_ContBin(prob, name, condition, delta_Pv_max, M, m, epsilon); % Set the binary variable delta to 1 if the load energy >= generator energy
prob = lin_ContBin(prob, 'lin_Pvdelta_Pv_max', z_Pv_max, x_PV_max, delta_Pv_max, 1e6, -1e6);
prob.Constraints.max_Pv_energy = sum(Pv) <= z_Pv_max ;

prob.Constraints.PvPch = Pv <= Pv_max_inst;

% x_PV_max = sum(Pload - P_max_feasibility);
% prob.Constraints.max_Pv_energy = sum(Pv) == z_Pv_max ;
% m = 0;%-T*P_max_feasibility;
% M = T*Pload_obj.P_shaved_overpower*Pload_obj.P_rated;
% % prob = lin_ContBin(prob, 'lin_Pvdelta_Pv_max', z_Pv_max, x_PV_max, delta_Pv_max, M, m);
% prob = lin_ContBin(prob, 'lin_Pvdelta_Pv_max', z_Pv_max, x_PV_max, delta_Pv_max, 1e6, -1e6);
