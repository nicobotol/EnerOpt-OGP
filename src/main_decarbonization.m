close all;
clear;
clc;

figure_enable = 0;

parameters % load parameters related to simulation and converters

enable_parallel_computing = 1; % 1 for parallel computing, 0 for sequential computing

if enable_parallel_computing == 1 && isempty(gcp('nocreate'))
  num_core = feature('numcores');
  parpool('Processes', num_core);
end

%    ____                          _                
%   / ___|___  _ ____   _____ _ __| |_ ___ _ __ ___ 
%  | |   / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__/ __|
%  | |__| (_) | | | \ V /  __/ |  | ||  __/ |  \__ \
%   \____\___/|_| |_|\_/ \___|_|   \__\___|_|  |___/
                                                                   
define_converters_corepower_MW_formulation % define the converters and their parameters

%   ____        _                 _       
%  |  _ \  __ _| |_ __ _ ___  ___| |_ ___ 
%  | | | |/ _` | __/ _` / __|/ _ \ __/ __|
%  | |_| | (_| | || (_| \__ \  __/ |_\__ \
%  |____/ \__,_|\__\__,_|___/\___|\__|___/

import_datasets_norway_1yr % load the datasets of the different resources
% import_datasets_dulang_1yr % load the datasets of the different resources

% do_power_from_datasets

%    ____             __ _                    _   
%   / ___|___  _ __  / _(_) __ _     ___  ___| |  
%  | |   / _ \| '_ \| |_| |/ _` |   / __|/ _ \ |  
%  | |__| (_) | | | |  _| | (_| |_  \__ \  __/ |_ 
%   \____\___/|_| |_|_| |_|\__, (_) |___/\___|_(_)
%                          |___/                  

REC     = RECX();
REC.WT  = WT; 
REC.PV  = PV;
REC.WEC = WEC;
REC.DGv.DGv_obj = DGv_obj;
REC.DGv.n_NREC  = 1;
REC.GT.GT_obj   = GT_obj;
REC.GT.n_NREC   = n_GT;
REC.DG.DG_obj   = DG_obj;
REC.DG.n_NREC   = n_DG;
% GT24         & GT only 
% GT365        & GT only w/o scenario
% 1GT+WT+DG    & 1 GT + BESS + WT + DG 
% 2GT+WT+DG    & 2 GT + BESS + WT + DG
% 1GT+REC+DG   & 1 GT + BESS + WT+PV+WEC + DG
% 2GT+REC+DG   & 2 GT + BESS + WT+PV+WEC + DG 
% WT+DG        & WT + BESS + DG
% REC-U        & WT+PV+WEC (uncstr.) + BESS 
% REC-U+DG     & WT+PV+WEC (uncstr.) + BESS + DG
% REC-C+DG24   & WT+PV+WEC (cstr.) + BESS + DG w/ scenario
% REC-C+DG365  & WT+PV+WEC (cstr.) + BESS + DG w/o scenario
% DG+REC24     & WT+PV+WEC (cstr.) + BESS + DIESEL w/ scenario
% DG+REC365    & WT+PV+WEC (cstr.) + BESS + DIESEL w/o scenario

case_sim_vec = {'1GT+WT+DG', 'WT+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24'};
case_sim_vec = {'1GT+WT+DG'};
num_sim = length(case_sim_vec);

%   ____                                    _   
%  / ___|_      _____  ___ _ __    ___  ___| |  
%  \___ \ \ /\ / / _ \/ _ \ '_ \  / __|/ _ \ |  
%   ___) \ V  V /  __/  __/ |_) | \__ \  __/ |_ 
%  |____/ \_/\_/ \___|\___| .__/  |___/\___|_(_)
%                         |_|                   

% decide which kind of sweep to perform
% None -> No sweep, only 1 simulation
% beta -> Change the CVaR control parameter
% LPSP -> Change the LPSP
% PS   -> Change the power of the PS
% Carbon_tax -> Change the carbon tax
% DGpower -> Change the rated power of the DG
% PVCost -> Change the cost of the PV
% WECCost -> Change the cost of the WEC
sweep_type  = 'Carbon_tax';
alpha_vec   = 0.8;  % [0.1, 0.5, 0.9];
num_alpha   = size(alpha_vec, 2);
switch sweep_type
  case 'None'
    sweep_vec = 0;
  case 'beta'
    sweep_vec = [0:0.25:1];
  case 'LPSP'
    sweep_vec = [0:0.01:0.05];%[0, 0.1, 0.5, 0.9];
  case 'PS'
    sweep_vec = [0:0.025:0.1];
  case 'Carbon_tax'
    sweep_vec = [1,10,100,1000];
  case 'PVCost'
    sweep_vec = [1,0.7,0.5];
    CAPEX_ref = PV_CAPEX_ref;
    OPEX_ref  = PV_OPEX_ref;
  case 'WECCost'
    sweep_vec = [1,0.8,0.6,0.4];
    CAPEX_ref = WEC_CAPEX_ref;
    OPEX_ref  = WEC_OPEX_ref;
  otherwise
    error('Unknown sweep type')
end
num_sweep = size(sweep_vec, 2);


REC_obj(1:num_alpha,1:num_sweep)      = REC;
scenario_mat(1:num_alpha,1:num_sweep) = scenario;
opt_parameters_vec(1:num_sim)         = opt_parameters;
prob_scens                            = cell(num_alpha, num_sweep);
res_scens                             = cell(num_alpha, num_sweep);
load_scens                            = cell(num_alpha, num_sweep);
REC_tmp                               = cell(num_alpha, num_sweep);
LselScens_N                           = cell(num_alpha, num_sweep);
time_sim                              = cell(num_alpha, num_sweep, num_sim);
seed_increment                        = zeros(num_sweep);
values_solution                       = cell(num_alpha, num_sweep, num_sim);
values_vector                         = cell(num_alpha, num_sweep, num_sim);
values_minvalue                       = cell(num_alpha, num_sweep, num_sim);
CO2_emitted                           = cell(num_alpha, num_sweep, num_sim);
load_scenarios.iniVec = LoadA.iniVec;

for i=1:num_sim
  for b = 1:num_sweep
    for a = 1:num_alpha

      res_scens{a,b,i}{1} = wind.iniVec;
      res_scens{a,b,i}{2} = irradiance.iniVec;
      res_scens{a,b,i}{3} = reshape(met_data_swh, [], 1);
      res_scens{a,b,i}{4} = reshape(met_data_mwp, [], 1);
      load_scens{a,b,i}   = load_scenarios;
      prob_scens{a,b,i}   = 1/size(load_scenarios.iniVec, 2)*ones(size(load_scenarios.iniVec, 2), 1);
      
      [REC_tmp{a,b,i}]    = do_power(REC_obj(a,b,i), res_scens{a,b,i});
    
      tic;
      case_sim = case_sim_vec{i};
      
      % Optimization setup
      [REC_el, load_scenarios_el, opt_parameters_el] = optimization_setup('alpha', alpha_vec, sweep_type, sweep_vec, a, b, REC_tmp{a,b,i}, base_CO2_tax, CAPEX_ref, OPEX_ref, load_scens{a,b,i}, opt_parameters_vec(i), BESS_NL_model, case_sim);
      
      % Run optimization
      [values_solution{a,b,i}, values_vector{a,b,i}, values_minvalue{a,b,i}, CO2_emitted{a,b,i}] = CASE_optimization(prob_scens{a,b,i}, REC_el, ESS, DL, load_scenarios_el, opt_parameters_el, case_sim, scenario_mat(a,b));

      % Track time and convergence
      time_sim{a,b,i} = toc;
      fprintf('Simulation, case=%s, a=%4d, b=%3d, time=%5.f [s], stop due to %s\n, convergence=%5.2f\n', case_sim, alpha_vec(a), sweep_vec(b), time_sim{a,b,i}, values_solution{a,b,i}.min_info.message,values_solution{a,b,i}.min_info.relativegap);

    end
  end
end

%%
%   ____  _       _   
%  |  _ \| | ___ | |_ 
%  | |_) | |/ _ \| __|
%  |  __/| | (_) | |_ 
%  |_|   |_|\___/ \__|
                    

close all;
plot_decarbonization

%   _____                 _   _             
%  |  ___|   _ _ __   ___| |_(_) ___  _ __  
%  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \ 
%  |  _|| |_| | | | | (__| |_| | (_) | | | |
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
                                          
function UpdateOptInfo(info)
  fprintf("Simulation %s completed\n", info.case_constraint)
  fprintf("Final value: %d\n", info.values_minvalue)
end