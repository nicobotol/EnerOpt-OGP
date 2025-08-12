function [wTz] = cost_soft_constraint(BAT, AF, epsilon_bat)
  % cost related to the soft constraint

  wTz_NA = BAT(:).constraint_weight*epsilon_bat; % not annualized cost

  wTz = AF.CRF*wTz_NA; % annualized cost
  
end