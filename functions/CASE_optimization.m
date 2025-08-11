function [values_solution, values_vector, values_minvalue, CO2_emitted] = CASE_optimization(LscensProbVec_N, REC, ESS, DL, Pload_obj, opt_parameters, scenario, case_constraint)
  % This function solves the optimization assuming that the data of load and renewable energy sources are given in objectives form
  
  % Probability related variables
  cvar_alpha = opt_parameters.alpha;
  cvar_beta = opt_parameters.beta;
  rel_gap_tol = opt_parameters.rel_gap_tol;
  abs_gap_tol = opt_parameters.abs_gap_tol;

  % Choice of the BESS model
  BESS_NL_model = opt_parameters.BESS_NL_model;
  
  % Extract the physical parameters from device structure
  PV        = []; % Photovoltaic panel
  WT        = []; % Wind turbine
  WEC       = []; % Wind turbine
  BAT       = []; % Battery
  Pload     = []; % Load data
  DG        = []; % Diesel generator
  P_DGv_max = Pload_obj.P_shaved_overpower*Pload_obj.P_rated; % Max virtual power Pv
  DGv_obj   = REC.DGv.DGv_obj; %
  
  % define the devices used in the different cases
  switch case_constraint
    case 'GT24' % Only GT
      GT_obj  = REC.GT.GT_obj;
      Pload   = Pload_obj.iniVec; % Load data

    case 'GT365' % Only GT w/o days
      GT_obj  = REC.GT.GT_obj;
      Pload   = Pload_obj.iniVec; % Load data

      % Reshape the data such that they are in the form of the REC
      Pload = reshape(Pload, [], 1);
      LscensProbVec_N = 1;

    case '1GT+WT+DG' % 1 GT + WT + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC = 1;
      WT      = REC.WT;           % Wind turbine
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
    
    case '2GT+WT+DG' % 2 GT + WT + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC    = 2;
      WT      = REC.WT;           % Wind turbine
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data

    case '1GT+REC+DG' % 1 GT + WT + PV + WEC + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC = 1;
      WT      = REC.WT;           % Wind turbine
      PV      = REC.PV;           % PV
      WEC     = REC.WEC;          % WEC
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
    
    case '2GT+REC+DG' % 2 GT + WT + PV + WEC + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC  = 2;
      WT      = REC.WT;           % Wind turbine
      PV      = REC.PV;           % PV
      WEC     = REC.WEC;          % WEC
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data

    case 'WT+DG' % only WT + BESS
      WT    = REC.WT;           % Wind turbine
      BAT   = ESS.BAT;          % Battery
      Pload = Pload_obj.iniVec; % Load data

    case {'REC-U', 'REC-U+DG', 'REC-C+DG24'} % REC + BESS
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      Pload = Pload_obj.iniVec; % Load data

    case {'REC-C+DG365'}
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      Pload = Pload_obj.iniVec; % Load data

      % Reshape the data such that they are in the form of the REC
      Pload = reshape(Pload, [], 1);
      LscensProbVec_N = 1;

    case 'DG+REC24' % REC + BESS + DIESEL
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      DG_obj= REC.DG.DG_obj;    % Diesel generator
      Pload = Pload_obj.iniVec; % Load data
   
    case 'DG+REC365' % REC + BESS + DIESEL
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      DG_obj= REC.DG.DG_obj;    % Diesel generator
      Pload = Pload_obj.iniVec; % Load data

      % Reshape the data such that they are in the form of the REC
      Pload = reshape(Pload, [], 1);
      LscensProbVec_N = 1;

    otherwise
      error('Case name not implemented yet\n');
  end

  % Annualization-related variables
  r = opt_parameters.r; % daily interest rate
  L = opt_parameters.L; % investment lifetime
  p = (365*24)*L/scenario.h_star; % recoupling period  
  T = scenario.T;  % number of data in each scenario 
  W = size(Pload, 2); % number of scenarios (e.g. days)
  AF.CRF    = (r*(1 + r)^p)/((1 + r)^p - 1);  % capital recovery factor (daily value of fixed cost)
  AF.gamma  = scenario.h_star/scenario.h;     % rescale the scenario to cost to daily values
  AF.YtD    = scenario.d_o;                   % rescale from yearly to daily cost

  % Identify how many REC are present
  if ~isempty(PV); num_PV = 1; else; num_PV = 0; end
  if ~isempty(WT); num_WT = 1; else; num_WT = 0; end
  if ~isempty(WEC); num_WEC = 1; else; num_WEC = 0; end
  if ~isempty(BAT); num_ESS = 1; else; num_ESS = 0; end
  if ~isempty(DL); num_DL = 1; else; num_DL = 0; end
  n_REC = num_PV + num_WT + num_WEC; % Number of devices

  %  __     __         _       _     _           
  %  \ \   / /_ _ _ __(_) __ _| |__ | | ___  ___ 
  %   \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
  %    \ V / (_| | |  | | (_| | |_) | |  __/\__ \
  %     \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
  
  Pch   = 0; % charging power of the battery
  Pdc   = 0; % discharging power of the battery
  prob  = optimproblem; 
  cvar_zeta = 0; % CVaR constraint
  cvar_s = zeros([W, 1]); % CVaR constraint
  P_REC_max = 0;
  P_GT  = 0;
  Pbt   = 0;

  switch case_constraint
    case {'GT24','GT365'} % Only GT
      variable_def_GT;
      variable_def_Pns_Pct;
      
    case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'} % 1/2 GT + REC + BESS
      variable_def_GT;
      x_GT = ones(REC.GT.n_NREC, 1); % impose the number of GTs
      variable_def_REC;
      variable_def_Pns_Pct;
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end
      
    case {'WT+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365'} % REC + BESS
      variable_def_REC;
      variable_def_Pns_Pct;
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end

    case {'DG+REC24', 'DG+REC365'} % REC + BESS + DIESEL
      variable_def_REC;
      variable_def_DGv;
      variable_def_Pns_Pct;
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end
      
    otherwise
      error('Case name not implemented yet\n');
        
  end
      
    variable_def_DR;
    variable_def_risk_related;
    variable_def_DGv;

  %    ____          _   
  %   / ___|___  ___| |_ 
  %  | |   / _ \/ __| __|
  %  | |__| (_) \__ \ |_ 
  %   \____\___/|___/\__|
  
  cTx_BESS  = 0;
  cTx_GT    = 0;
  cTx_REC   = 0;
  cTx_DG    = 0;
  cTx_Pv    = 0;
  qTy_w_GT  = 0;
  qTy_w_BESS= 0;
  qTy_w_DG  = 0;
  qTy_w_DR  = 0;
  qTy_w_Pv  = 0;
  wTz       = 0;
  Pres_vec = zeros(T, W); % vector power of the RECs
  switch case_constraint
    case {'GT24', 'GT365'} % Only GT
      [cTx_GT, qTy_w_GT] = cost_GT(GT_obj, AF, REC.GT.n_NREC, P_GT, u_GT, z_GT, RR, x_GT, T, W, scenario.tau); % cost related to the GTs
      Pbt = zeros(T,W);
      
    case {'1GT+WT+DG', '2GT+WT+DG'} % 1/2 GT + WT + BESS
      [cTx_GT, qTy_w_GT] = cost_GT(GT_obj, AF, REC.GT.n_NREC, P_GT, u_GT, z_GT, RR, x_GT, T, W, scenario.tau); % cost related to the GTs
      REC_obj = {WT};
      REC_obj = reshape_REC_power(REC_obj, Pload);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, n_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_IV, x_ESS_NIV);

    case {'1GT+REC+DG', '2GT+REC+DG'} % 1/2 GT + REC + BESS
      [cTx_GT, qTy_w_GT] = cost_GT(GT_obj, AF, REC.GT.n_NREC, P_GT, u_GT, z_GT, RR, x_GT, T, W, scenario.tau); % cost related to the GTs
      REC_obj = {PV, WT, WEC};
      REC_obj = reshape_REC_power(REC_obj, Pload);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, n_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_IV, x_ESS_NIV);
    
    case 'WT+DG' % only WT + BESS
      REC_obj = {WT};
      REC_obj = reshape_REC_power(REC_obj, Pload);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, n_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_IV, x_ESS_NIV);
      
    case {'REC-U', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365'} % REC + BESS
      REC_obj = {PV, WT, WEC};
      REC_obj = reshape_REC_power(REC_obj, Pload);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, n_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]          = cost_BESS(BAT, AF, x_ESS_IV, x_ESS_NIV);
              
    case {'DG+REC24', 'DG+REC365'} % REC + BESS + DIESEL
      REC_obj = {PV, WT, WEC};
      REC_obj = reshape_REC_power(REC_obj, Pload);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, n_REC, x_REC);
      % [cTx_DG, qTy_w_DG]      = cost_DG_linear(DG_obj, AF, REC.DG.n_NREC, P_DG, x_DG, T, W);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_IV, x_ESS_NIV);

    otherwise
      error('Case name not implemented yet');

  end

  % fast_constraint;

  [qTy_w_Pns_Pct]     = cost_Pns_Pct(Pns, Pct, T, Pload_obj);
  [cTx_Pv, qTy_w_Pv]  = cost_DGv(AF, P_DGv, T, P_DGv_max_inst,  REC.DGv.DGv_obj{1}); % virtual power (i.e. diesel cost without intercept)

  cTx = cTx_GT + cTx_BESS + cTx_REC + cTx_DG + cTx_Pv;               % Total 1st stage cost
  qTy_w = qTy_w_GT + qTy_w_BESS + qTy_w_Pns_Pct + qTy_w_DG + qTy_w_DR + qTy_w_Pv; % Total 2nd stage cost

  f     = cTx + AF.gamma*qTy_w*LscensProbVec_N;
  if num_ESS > 0
    [wTz] = cost_soft_constraint(BAT, AF, epsilon_bat);
    f = f + wTz; % add soft constraint in case of presence of the BESS
  end

  cvar  = cvar_zeta + (1/(1 - cvar_alpha))*sum(LscensProbVec_N.*cvar_s)*scenario.tau;
  F     = (1 - cvar_beta)*f + cvar_beta*cvar;
  prob.Objective  = F;
  
  %    ____                _             _       _       
  %   / ___|___  _ __  ___| |_ _ __ __ _(_)_ __ | |_ ___ 
  %  | |   / _ \| '_ \/ __| __| '__/ _` | | '_ \| __/ __|
  %  | |__| (_) | | | \__ \ |_| | | (_| | | | | | |_\__ \
  %   \____\___/|_| |_|___/\__|_|  \__,_|_|_| |_|\__|___/
  
  Pload_PS = load_PS(Pload, Pps_rem, Pps_add);
 
  switch case_constraint
    case {'GT24','GT365'} % Only GT
      P_gen_tot = sum(P_GT, 3);
      prob = GT_constraints(prob, REC.GT.n_NREC, T, W, GT_obj, u_GT, z_GT, x_GT, P_GT, RR, z_help, case_constraint);

    case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'} % GT + REC + BESS
      % GT
      P_gen_tot = P_res + sum(P_GT, 3);
      prob = GT_constraints(prob, REC.GT.n_NREC, T, W, GT_obj, u_GT, z_GT, x_GT, P_GT, RR, z_help, case_constraint); 
      
      % REC
      prob = REC_constraints(prob, P_res, P_REC_max, n_REC, REC_obj, x_REC);
      
      % BESS
      prob = BESS_constraints(prob, scenario, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat);

    case {'WT+DG', 'REC-C+DG24', 'REC-C+DG365'}  % G -> WT + BESS
                            % I -> REC + BESS
      % REC
      P_gen_tot = P_res;
      prob = REC_constraints(prob, P_res, P_REC_max, n_REC, REC_obj, x_REC);

      % BESS
      prob = BESS_constraints(prob, scenario, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat);

    case {'REC-U+DG'} % REC + BESS w/o plant size constraints and possibility to use Pv
      % REC
      P_gen_tot = P_res;
      prob = max_power(prob, 'REC_max_power', P_res, P_REC_max); % Maximum power produced by the REC
      
      % BESS
      prob = BESS_constraints(prob, scenario, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat);
    
      case {'REC-U'} % REC + BESS w/o plant size constraints
      % REC
      P_gen_tot = P_res;
      prob = max_power(prob, 'REC_max_power', P_res, P_REC_max); % Maximum power produced by the REC
      
      % BESS
      prob = BESS_constraints(prob, scenario, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat);

      % Virtual power
      prob.Constraints.Pv_zero = P_DGv == 0;
      
    case {'DG+REC24', 'DG+REC365'} % REC + BESS + DIESEL
      % Total generated power
      P_gen_tot = P_res + sum(P_DG, 3);
  
      % DG
      for g = 1:REC.DG.n_NREC
        name = ['DG', num2str(g), '_max_power'];
        prob = max_power(prob, name, P_DG(:, :, g), x_DG(g)*DG_obj{g}.PowRated); % max power for each DG
      end
  
      % REC
      prob = REC_constraints(prob, P_res, P_REC_max, n_REC, REC_obj, x_REC);
  
      % BESS
      prob = BESS_constraints(prob, scenario, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_IV, x_ESS_NIV, epsilon_bat);

    otherwise
      error('Case name not implemented yet\n');
      
  end

  % Power balance
  if BESS_NL_model == 1
    prob = power_balance_NL_model(prob, P_gen_tot, Pch, Pdc, Pns, Pct, P_DGv, Pload_PS);
  else
    prob = power_balance(prob, P_gen_tot, Pbt, Pns, Pct, P_DGv, Pload_PS);
  end

  % Peak shaving power
  prob = load_PS_energy(prob, Pps_add, Pps_rem);
  prob = load_PS_minmax(prob, Pload_PS, Pload_obj);
  prob = load_PS_power_minmax(prob, Pps_add, Pps_rem, Pload_obj);

  % Maximum dumped power 
  prob = max_power(prob, 'Pct_max_power', Pct, DL.Pct_max); 

  % LPSP
  prob = LPSP_target(prob, Pns, Pload_PS, Pload_obj);

  % CVaR
  prob = CVaR_constraint(prob, cvar_zeta, cvar_s, cTx, qTy_w, AF.gamma, wTz);

  % Virtual power
  prob = Pv_power_constraint_linear(prob, P_DGv, P_DGv_max_inst);
  % prob = Pv_power_constraint(prob, Pv, Pv_max_inst, u_Pv, zeta_Pv, P_DGv_max);

  %   ____        _       _   _             
  %  / ___|  ___ | |_   _| |_(_) ___  _ __  
  %  \___ \ / _ \| | | | | __| |/ _ \| '_ \ 
  %   ___) | (_) | | |_| | |_| | (_) | | | |
  %  |____/ \___/|_|\__,_|\__|_|\___/|_| |_|
  
  fprintf('Start solution\n')

  opt = optimoptions('intlinprog', 'Display', 'iter', 'AbsoluteGapTolerance', abs_gap_tol, 'RelativeGapTolerance', rel_gap_tol, 'MaxTime', 2*3600, 'Heuristics', 'advanced', 'ObjectiveImprovementThreshold',0);
  prob.ObjectiveSense = 'minimize';
  [values_solution, values_minvalue, tmp, min_info] = solve(prob, 'Options', opt);

  values_solution.min_info = min_info;
  values_solution.values_minvalue = values_minvalue;
  

  fprintf('Solution ended\n')

  %   ____           _                                       _             
  %  |  _ \ ___  ___| |_   _ __  _ __ ___   ___ ___  ___ ___(_)_ __   __ _ 
  %  | |_) / _ \/ __| __| | '_ \| '__/ _ \ / __/ _ \/ __/ __| | '_ \ / _` |
  %  |  __/ (_) \__ \ |_  | |_) | | | (_) | (_|  __/\__ \__ \ | | | | (_| |
  %  |_|   \___/|___/\__| | .__/|_|  \___/ \___\___||___/___/_|_| |_|\__, |
  %                       |_|                                        |___/ 
  
  % Check that the battery does not charge and discharge at the same time
  if isfield(values_solution, 'Pch')
    check_charging(values_solution);
  end

  % Reshape values in a vector
  values.n_REC = n_REC;
  [values_vector, values_solution] = reshape_data(values_solution, Pload, Pres_vec, BAT);
  values_vector.P_res_vec = Pres_vec;

  % % Compute the capacity factors
  % values_vector = capacity_factor(values_vector, values_vector, PV, WT, WEC, BAT, W, T);

  % Compute the emitted CO2
  compute_CO2

  % compute the installed power
  compute_installed_power;
      
  % Evaluate the costs 
  compute_final_costs;  

  % evaluate the LCOE
  compute_LCOE_polysystem;
  
  % Compute the CVaR
  values_solution.CVaR = values_solution.cvar_zeta + (1/(1 - cvar_alpha))*LscensProbVec_N'*values_solution.cvar_s;

  % Effective LPSP
  values_solution.LPSP_eff = sum(values_vector.Pns)/sum(Pload, 'all');

end


%    __                  _   _             
%   / _|_   _ _ __   ___| |_(_) ___  _ __  
%  | |_| | | | '_ \ / __| __| |/ _ \| '_ \ 
%  |  _| |_| | | | | (__| |_| | (_) | | | |
%  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|
                                         
% check whether the BESS is charging e discharging at the same time
function check_charging(values_solution)
  % This function check that the battery does not charge and discharge at the same time
  if sum(any(values_solution.Pch/values_solution.x_ESS_NIV > 1e-4 & values_solution.Pdc/values_solution.x_ESS_NIV > 1e-4))
    tmp = (values_solution.Pch > 1e-4) & (values_solution.Pdc > 1e-4);
    idx = 1:1:size(values_solution.Pch, 1) * size(values_solution.Pch, 2);
    
    figure(); hold on;
    plot(reshape(values_solution.Pch, [], 1), 'b', 'DisplayName', 'Pbt\_ch');
    plot(reshape(values_solution.Pdc, [], 1), 'r', 'DisplayName', 'Pbt\_dc');
    
    % Find first occurrence of the condition
    condition_idx = find(tmp, 1);
    
    if ~isempty(condition_idx)
      % Plot vertical line at the condition index
      xline(condition_idx, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Violation');
      legend;
      error('The battery is charging and discharging at the same time');
    end
  end
end

% sum(sol.Pch - sol.Pdc) == 0% constant of the power exchange
% sol.Ebt(T:T:T*W) = sol.E0 % final energy of the battery

