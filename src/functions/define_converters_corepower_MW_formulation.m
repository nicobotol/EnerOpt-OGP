%% This script defines the different converters and their parameters

% Dump load
DL = DumpLoadX();
DL.C_OeM = 1e3; % [$/MW]
DL.Pct_max = 1; % [W]

% Parameters related to the grid
GRID = GridX();
% WT_filename             = 'converters_models/2023NREL_Bespoke_3MW_127.csv'; % 3 [MW] wind turbine
WT_filename             = 'converters_models/2020ATB_NREL_Reference_8MW_180.csv'; % 7 [MW] wind turbine
WT_coefficient          = 1e-3; % coefficient to convert the power curve in [W]
WT                      = WindTurbineX([], WT_filename, WT_coefficient);
WT.C_CAPEX              = 3.2*1e6;  % CAPEX [$/MW]
WT.C_OPEX               = 0.11*1e6; % OPEX [$/MWyr]
WT.C_DECOM              = 0;    % decommissioning [$/W]
WT.hub_height           = 112;  % hub height of the 7 [MW] wind turbine [m]
WT.WS_measure_height    = WT.hub_height; % height at which the WS was measured [m] N.B. Since the wind speed in the dataset already accounts for the shear law this parameters is not considered here
WT.WS_alpha             = 0.11; % coefficient for the wind shear
WT.deloaded_coeff_min   = 0.05; % coefficient for deloaded power
WT.deloaded_coeff_max   = 0.1;  % coefficient for deloaded power
WT.V_in                 = 4; % cut-in wind speed [m/s]
WT.V_out                = 25; % cut-out wind speed [m/s]
WT.V_rated              = 12; % rated wind speed [m/s]
WT.max_installed_power  = 80; % maximum power of the wind farm [MW]
WT.PowRated             = max(WT.PC_power*1e-3); % rated power of the wind turbine [MW]

PV                      = PhotoVoltaicX([]);
PV.A_eff                = 1.663; % [m^2] effective area of the PV panel
PV.eta_c                = 14.4/100; % conversion efficiency in STC
PV.eta_AC               = 0.95; % Conversion efficiency DC to AC
PV.C_CAPEX              = 1.1*2*1e6;  % CAPEX [$/MW]
PV.C_OPEX               = 1.1*0.3*1e6; % OPEX [$/MW]
PV.C_DECOM              = 0.0; % decommissioning [$/W]
PV.PowRated             = 240*1e-6; % [MW] rated power
PV.max_area             = 5e4; % maximum area of the PV field [m^2]
PV.max_installed_power  = 200; % maximum power of the PV field [W]
PV.power_coefficient    = 1e-6; % coefficient for rescaling the power in different units
PV_CAPEX_ref            = PV.C_CAPEX;
PV_OPEX_ref             = PV.C_OPEX;

WEC                     = WECX([]);
WEC.C_CAPEX             = 1.1*5*1e6;  % CAPEX [$/MW]
WEC.C_OPEX              = 0.28*1e6;   % OPEX [$/MW]
WEC.PowRated            = 0.400;      % rated power [MW]
pelamis_filename        = 'converters_models/corpower_power_matrix.csv';
pelamis_axes_filename   = 'converters_models/corpower_power_matrix_axes.csv';
dataLines_PM            = [1, inf];
dataLines_axes          = [4, inf];
WEC.import_powermatrix_corpower(pelamis_filename, dataLines_PM, pelamis_axes_filename, dataLines_axes);
WEC.WEC_coefficient     = 1e-3; % coefficient to rescale the power matrix 
WEC.max_installed_power = 50; % maximum tot WEC installed power [MW]
WEC_CAPEX_ref            = WEC.C_CAPEX;
WEC_OPEX_ref             = WEC.C_OPEX;

load_scenarios                = LoadX([]);
load_scenarios.delta_load     = 0.1; % percentage of the load generating power imbalance
load_scenarios.NS_cost        = 1e3; % cost of not served energy [$/MWh]
load_scenarios.Pv_cost        = 1e4;%load_scenarios.NS_cost*1e1; % cost of not served energy [$/MWh]
load_scenarios.CT_cost        = 5e-3*1e6; % cost of curtailed energy [$/MWh]
load_scenarios.Pct_max        = 1; % max curtailing power [MW]
load_scenarios.LPSP_target    = 0.0;
load_scenarios.NS_fraction    = 0.05; % fraction of the load that can be not served
load_scenarios.P_rated        = 45;   % rated power of the load [MW]
load_scenarios.P_shaved_frac  = 0.0;  % fraction of rated power that can be re-allocated within the time horizon
load_scenarios.P_shaved_overpower = 1.05; % factor of increase of load power w.r.t. the rated power when doing peak shaving
load_scenarios.Pps_add_cost   = 1e-5*1e6; % cost of adding power to the load [$/MW] (not used)
load_scenarios.Pps_rem_cost   = 1e-5*1e6; % cost of removing power to the load [$/MW] (not used)

% Define the battery
BAT = BatteryX();
BAT.C_batt      = 10; % Capacity of 1 battery module [MWh]
BAT.C_CAPEX_E   = 0.250*1e6; % BESS cost+installation [$/MWh]
BAT.C_CAPEX_P   = 0.200*1e6; % BESS cost+installation [$/MW]
BAT.C_OPEX_E    = 0.05*BAT.C_CAPEX_E; % OPEX [$/Wh]
BAT.C_OPEX_P    = 0.05*BAT.C_CAPEX_P; % OPEX [$/W]
BAT.C_DECOM     = 0.0; % decommissioning [$/W]
BAT.C_charge    = 5e-4;
BAT.C_discharge = 5e-4;
BAT.constraint_weight=1e-3; % cost of violating the soft constraint
BAT.SOC_min     = 0.1; % fraction minimum energy stored
BAT.E_max       = 70; % maximum energy stored [MWh]
BAT.Pch_max     = 50; % maximum charging power [MW]
BAT.Pdc_max     = BAT.Pch_max; % maximum discharging power [W]
BAT.deg_coeff_A = 2.74e-4; % coefficient A of the BESS degradation model 
BAT.deg_coeff_B = 2.1; % coefficient B of the BESS degradation model
BAT.num_points_deg_approx = 3; % number of points to be used for the PLA of the damage function
BAT.BuildDegradationPoints(); % build the points to be used in the PLA of the damage
BAT.eol_fraction = 1/10;     % fraction of the initial value that the asset has at its end of live
BAT.L_sh         = 25*365*24; % shelf degradation for each hour 
BAT.year_deg      = 15; % years that the battery has to last
% BAT.max_day_deg  = 1/15/365; % maximum allowed daily degradation
BAT.deg_cost_enable = 1; % 1 for considering the BESS degradation cost, 0 if not
ESS = ESSX();
ESS.BAT = BAT;
% decide which kind of BESS model to use
% 0 -> linear model
% 1 -> Nonlinear model
BESS_NL_model = 1;

% define the GT
GT_1              = GasTurbineX();
GT_1.C_F          = 1.2*1.1*0.24;   % fuel sale value [$/m^3]
GT_1.rho          = 0.77;       % density of the fuel [kg/m^3]
GT_1.mu           = 2.682;      % ideal combustion coefficient of gas
GT_1.C_CO2        = 0.071;      % tax per kg of CO2 [$/kg]
GT_1.alpha_g      = 1.05*172.50;     % coeff for estimating modeling fuel consumption [kg/MW]
GT_1.beta_g       = 1.05*729.20;     % coeff for estimating modeling fuel consumption [kg/h]
GT_1.C_OeM        = 1.1*5.53;   % [$/MW]
GT_1.C_start      = 1.1*1217;   % Cost of starting the GT [$/start]
GT_1.C_I_unitary  = 820e3;      % [$/MW]
GT_1.gamma        = 0.20;       % minimum technical operational ratio
GT_1.PowRated     = 25;         % Rated power of the GT [MW]
GT_1.R            = 25;         % Ramping rate [MW/h]
GT_1.Toff         = 2;          % Time between two start ups of the turbine [h]
GT_1.C_RR         = 5e-1;       % Cost of the ramping rate [$/MW]
GT_1.ComputeCosts();

GT_obj            = {GT_1, GT_1};
% GT_obj            = {GT_1};
n_GT              = size(GT_obj, 2);        % Maximum number of gas turbines to install

% define the Diesel Generator
DG_1              = DieselGeneratorX();
DG_1.C_F          = 1.2*1.1*1.75; % fuel sale value [$/l]
DG_1.rho          = 0.85;     % density of the fuel [kg/l]
DG_1.mu           = 3.17;     % ideal combustion coefficient of gas
DG_1.C_CO2        = 0.071;    % tax per kg of CO2 [$/kg]
DG_1.alpha_g      = 1.05*2.34e2;   % coeff for estimating modeling fuel consumption [kg/MW]
DG_1.beta_g       = 0;        % coeff for estimating modeling fuel consumption
DG_1.C_OeM        = 1.1*5.53; % operational and maintenance cost [$/MW]
DG_1.C_start      = 0;        % Cost of starting the DG
DG_1.C_I_unitary  = 2.1*1e6;  % [$/MW]
DG_1.gamma        = 0;        % minimum technical operational ratio
DG_1.PowRated     = 3;        % Rated power of the GT [MW]
DG_1.R            = DG_1.PowRated*60;   % Ramping rate
DG_1.Toff         = 0;        % Time between two start ups of the turbine [h]
DG_1.C_RR         = 1e-1;     % Cost of the ramping rate
DG_1.ComputeCosts();
DG_1.base_power   = DG_1.PowRated; % rated power of the DG [W]

DG_obj            = {DG_1};
n_DG              = size(DG_obj, 2);        % Maximum number of gas turbines to install

base_CO2_tax = GT_1.C_CO2; % tax per kg of CO2 [$/kg]

DGv_1 = VirtualPowerX();
DGv_1.C_F          = 1.1*1.75; % fuel sale value [$/l]
DGv_1.rho          = 0.85;     % density of the fuel [kg/l]
DGv_1.mu           = 3.17;     % ideal combustion coefficient of gas
DGv_1.C_CO2        = 0.071;    % tax per kg of CO2 [$/kg]
DGv_1.alpha_g      = 2.34e2;   % coeff for estimating modeling fuel consumption [kg/MW]
DGv_1.beta_g       = 0;        % coeff for estimating modeling fuel consumption
DGv_1.C_OeM        = 1.1*5.53; % operational and maintenance cost [$/MW]
DGv_1.C_start      = 0;        % Cost of starting the DG
DGv_1.C_I_unitary  = 2.1*1e6;  % [$/MW]
DGv_1.gamma        = 0;        % minimum technical operational ratio
DGv_1.Toff        = 0;        % Time between two start ups of the turbine [h]
DGv_1.ComputeCosts();
DGv_obj            = {DGv_1};

% Define the Hydrogen Storage
HSS = HSSX();
HSS.eta_H         = 0.0333; % [MWh/kgH2] energy conversion from kWh to kg of hydrogen
HSS.C_storage_kg  = 25;  % Capacity of 1 hydrogen storage module [kg]
HSS.C_storage_u   = HSS.C_storage_kg*HSS.eta_H;  % Capacity of 1 hydrogen storage module [kg]
HSS.C_unitaryP_el = 1; % Unitary power of the electrolyzer
HSS.C_unitaryP_fc = 1; % Unitary power of the fuel cell
HSS.C_CAPEX_el    = 1.1*1.7e6;  % capital cost electrolyzer [$/MW]
HSS.C_OPEX_el     = 0.01*HSS.C_CAPEX_el;  % operational cost electrolyzer
HSS.C_CAPEX_fc    = 2.4e6;  % capital cost fuel cell [$/MW]
HSS.C_OPEX_fc     = 0.01*HSS.C_CAPEX_fc;  % operational cost fuel cell
HSS.C_CAPEX_st    = 1.1*464/HSS.eta_H*HSS.C_storage_u;  % capital cost tank storage [€/tank] 8$=7€
HSS.C_OPEX_st     = 0.025*HSS.C_CAPEX_st;  % operational cost tank storage
% HSS.C_CAPEX_rev_FC  = 1.1*900e6; % capital cost reversible fuel cell [$/MW]
% HSS.C_OPEX_rev_FC   = 0.0275*HSS.C_CAPEX_rev_FC; % operational cost reversible fuel cell
HSS.C_DECOM       = 0.0; % decommissioning [$/W]
HSS.SOC_max       = 1; % fraction maximum energy stored
HSS.SOC_min       = 0; % fraction minimum energy stored
HSS.E_H_max       = 5*HSS.C_storage_u; % maximum energy stored [kg]
HSS.Pel_max       = 2; % maximum charging power [MW]
HSS.Pfc_max       = HSS.Pel_max; % maximum discharging power [MW]
HSS.eta_el        = 0.6; % electrolyzer efficiency
HSS.eta_fc        = 0.6; % fuel cell efficiency
HSS.rev_FC        = 0; % 1 for reversible fuel cell, 0 for separate FC and EL
ESS.HSS           = HSS;

CAPEX_ref = 0;
OPEX_ref = 0;