% function [x_Pv_max, P_max_feasibility]  = Pv_energy_aux(Pload, P_REC_max, P_GT, n_REC, REC_obj, n_GT, GT_obj)

%   x_Pv_max = sum(Pload - P_REC_max - sum(P_GT, 3)); 

%   P_max_feasibility = 0; 
%   for r = 1:n_REC
%     P_max_feasibility = P_max_feasibility + REC_obj{r}.max_installed_power;
%   end
%   for g=1:n_GT
%     P_max_feasibility = P_max_feasibility + GT_obj{g}.PowRated;
%   end

% end


switch case_constraint
  case {'GT24','GT365'} % Only GT

    x_Pv_max = sum(Pload - sum(P_GT, 3)); 

    P_max_feasibility = 0; 
    for g=1:REC.GT.n_NREC
      P_max_feasibility = P_max_feasibility + GT_obj{g}.PowRated;
    end

  case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'} % GT + REC + BESS

    x_Pv_max = sum(Pload - P_REC_max - sum(P_GT, 3)); 

    P_max_feasibility = 0; 
    for r = 1:n_REC
      P_max_feasibility = P_max_feasibility + REC_obj{r}.max_installed_power;
    end
    for g=1:REC.GT.n_NREC
      P_max_feasibility = P_max_feasibility + GT_obj{g}.PowRated;
    end

  case {'WT+DG', 'REC-C+DG24'}
    x_Pv_max = sum(Pload - P_REC_max); 

    P_max_feasibility = 0; 
    for r = 1:n_REC
      P_max_feasibility = P_max_feasibility + REC_obj{r}.max_installed_power;
    end

  case {'DG+REC24', 'DG+REC365'}  
    x_Pv_max = sum(Pload - P_REC_max - P_DG); 

    P_max_feasibility = 0; 
    for r = 1:n_REC
      P_max_feasibility = P_max_feasibility + REC_obj{r}.max_installed_power;
    end
    for g=1:REC.DG.n_NREC
      P_max_feasibility = P_max_feasibility + DG_obj{g}.PowRated;
    end

end