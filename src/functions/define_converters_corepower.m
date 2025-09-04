%% This script defines the different converters and their parameters

% Dump load
DL = DumpLoadX();
DL.C_OeM = 1e-3; % [$/W]
DL.Pct_max = 1e6; % [W]

% Parameters related to the grid
GRID = GridX();
% WT_filename             = 'converters_models/2023NREL_Bespoke_3MW_127.csv'; % 3 [MW] wind turbine
WT_filename             = 'converters_models/2020ATB_NREL_Reference_8MW_180.csv'; % 7 [MW] wind turbine
WT_coefficient          = 1e3; % coefficient to convert the power curve in [W]
WT                      = WindTurbineX([], WT_filename, WT_coefficient);
% REC.WT.C_CAPEX              = 1e-8; % CAPEX [- rescaled from 7 to 5 MW of rated power $/W]
% REC.WT.C_OPEX               = 1e-8;     % OPEX - rescaled from 7 to 5 MW of rated power [$/W]
% REC.WT.C_DECOM              = 1e-8; % decommissioning - rescaled from 7 to 5 MW of rated power [$/W]
WT.C_CAPEX              = 6; % CAPEX [- rescaled from 7 to 5 MW of rated power $/W]
WT.C_OPEX               = 0.09;     % OPEX - rescaled from 7 to 5 MW of rated power [$/Wyr]
WT.C_DECOM              = 0; % decommissioning - rescaled from 7 to 5 MW of rated power [$/W]
WT.hub_height           = 112; % hub height of the 7 [MW] wind turbine [m]
WT.WS_measure_height    = WT.hub_height; % height at which the WS was measured [m] N.B. Since the wind speed in the dataset already accounts for the shear law this parameters is not considered here
WT.WS_alpha             = 0.11; % coefficient for the wind shear
WT.deloaded_coeff_min   = 0.05; % coefficient for deloaded power
WT.deloaded_coeff_max   = 0.1;  % coefficient for deloaded power
WT.V_in                 = 4; % cut-in wind speed [m/s]
WT.V_out = 25; % cut-out wind speed [m/s]
WT.V_rated = 12; % rated wind speed [m/s]
WT.max_installed_power  = 300e6; % maximum power of the wind farm [W]
WT.PowRated             = max(WT.PC_power*1e3); % rated power of the wind turbine [W]

PV                      = PhotoVoltaicX([]);
PV.A_eff                = 1.663; % [m^2] effective area of the PV panel
PV.eta_c                = 14.4/100; % conversion efficiency in STC
PV.eta_AC               = 0.95; % Conversion efficiency DC to AC
PV.C_CAPEX              = 7.5; % CAPEX [$/W]
PV.C_OPEX               = 0.11; % OPEX [$/W]
PV.C_DECOM              = 0.0; % decommissioning [$/W]
PV.PowRated             = 240; % [W] rated power
PV.max_area             = 5e4; % maximum area of the PV field [m^2]
PV.max_installed_power  = 200e6; % maximum power of the PV field [W]

WEC                     = WECX([]);
WEC.C_CAPEX             = 30; % CAPEX [$/W]
WEC.C_OPEX              = 4.75; % OPEX [$/W]
WEC.PowRated            = 400e3; % rated power [W]
pelamis_filename        = 'converters_models/corpower_power_matrix.csv';
pelamis_axes_filename   = 'converters_models/corpower_power_matrix_axes.csv';
dataLines_PM            = [1, inf];
dataLines_axes          = [4, inf];
WEC.import_powermatrix_corpower(pelamis_filename, dataLines_PM, pelamis_axes_filename, dataLines_axes);
WEC.max_installed_power = 50e6; % maximum tot WEC installed power [W]

load_scenarios              = LoadX([]);
load_scenarios.delta_load   = 0.1; % percentage of the load generating power imbalance
load_scenarios.NS_cost        = 1e2; % cost of not served energy [$/Wh]
load_scenarios.Pv_cost        = 1e-3*load_scenarios.NS_cost; % cost of not served energy [$/Wh]
load_scenarios.CT_cost        = 5e-3; % cost of curtailed energy [$/Wh]
load_scenarios.Pct_max        = 1e6; % max curtailing power
load_scenarios.LPSP_target    = 0.0;
load_scenarios.NS_fraction    = 0.05; % fraction of the load that can be not served
load_scenarios.P_rated        = 45e6; % rated power of the load [W]
load_scenarios.P_shaved_frac  = 0.0; % fraction of rated power that can be re-allocated within the time horizon
load_scenarios.P_shaved_overpower = 1.05; % factor of increase of load power w.r.t. the rated power when doing peak shaving
load_scenarios.Pps_add_cost    = 1e-5;
load_scenarios.Pps_rem_cost    = 1e-5;

% Define the battery
BAT = BatteryX();
BAT.C_batt      = 1; % Capacity of 1 battery module [Wh]
BAT.C_CAPEX_E   = 0.380; % CAPEX+OPEX for the energy [$/Wh]
BAT.C_CAPEX_P   = 1.485; % CAPEX+OPEX for the power [$/W]
BAT.C_OPEX_E    = 0.01*BAT.C_CAPEX_E; % OPEX [$/Wh]
BAT.C_OPEX_P    = 0.01*BAT.C_CAPEX_P; % OPEX [$/W]
BAT.C_DECOM     = 0.0; % decommissioning [$/W]
BAT.C_charge    = 5e-4;
BAT.C_discharge = 5e-4;
BAT.constraint_weight=1e-3; % cost of violating the soft constraint
BAT.SOC_min     = 0.3; % fraction minimum energy stored
BAT.E_max       = 320e6; % maximum energy stored [Wh]
BAT.Pch_max     = 50e6; % maximum charging power [W]
BAT.Pdc_max     = BAT.Pch_max; % maximum discharging power [W]
ESS = ESSX();
ESS.BAT = BAT;

% define the GT
GT_1              = GasTurbineX();
GT_1.C_F          = 1.1*0.24; % fuel sale value [$/m^3]
GT_1.rho          = 0.77; % density of the fuel [kg/m^3]
GT_1.mu           = 2.682;  % ideal combustion coefficient of gas
GT_1.C_CO2        = 0.071;   % tax per kg of CO2 [$/kg]
GT_1.alpha_g      = 172.50e-6; % coeff for estimating modeling fuel consumption [kg/W]
GT_1.beta_g       = 729.20; % coeff for estimating modeling fuel consumption [kg/h]
GT_1.C_OeM        = 1.1*5.53e-6; % [$/W]
GT_1.C_start      = 1.1*1217;   % Cost of starting the GT [$/start]
GT_1.C_I_unitary  = 820e-3; % [$/W]
GT_1.gamma        = 0.20;   % minimum technical operational ratio
GT_1.PowRated     = 25e6;   % Rated power of the GT [W]
GT_1.R            = 25e6;   % Ramping rate
GT_1.Toff         = 4;      % Time between two start ups of the turbine [h]
GT_1.C_RR         = 5e-5;   % Cost of the ramping rate
GT_1.ComputeCosts();

GT_2              = GasTurbineX();
GT_2.C_F          = 1.1*0.24; % fuel sale value [$/m^3]
GT_2.rho          = 0.77; % density of the fuel [kg/m^3]
GT_2.mu           = 2.682;  % ideal combustion coefficient of gas
GT_2.C_CO2        = 0.071;   % tax per kg of CO2 [$/kg]
GT_2.alpha_g      = 172.50e-6; % coeff for estimating modeling fuel consumption [kg/W]
GT_2.beta_g       = 729.20; % coeff for estimating modeling fuel consumption [kg/h]
GT_2.C_OeM        = 1.1*5.53e-6; % [$/W]
GT_2.C_start      = 1.1*1217;   % Cost of starting the GT [$/start]
GT_2.C_I_unitary  = 820e-3; % [$/W]
GT_2.gamma        = 0.20;   % minimum technical operational ratio
GT_2.PowRated     = 25e6;   % Rated power of the GT [W]
GT_2.R            = 25e6;   % Ramping rate
GT_2.Toff         = 4;      % Time between two start ups of the turbine [h]
GT_2.C_RR         = 5e-5;   % Cost of the ramping rate
GT_2.ComputeCosts();

% GT_3 the same size of the others
GT_3              = GasTurbineX();
GT_3.C_F         = 1.1*0.24; % fuel sale value [$/m^3]
GT_3.rho          = 0.77; % density of the fuel [kg/m^3]
GT_3.mu           = 2.682;  % ideal combustion coefficient of gas
GT_3.C_CO2        = 0.071;   % tax per kg of CO2 [$/kg]
GT_3.alpha_g      = 172.50e-6; % coeff for estimating modeling fuel consumption [kg/W]
GT_3.beta_g       = 729.20; % coeff for estimating modeling fuel consumption [kg/h]
GT_3.C_OeM        = 1.1*5.53e-6; % [$/W]
GT_3.C_start      = 1.1*1217;   % Cost of starting the GT [$/start]
GT_3.C_I_unitary  = 820e-3; % [$/W]
GT_3.gamma        = 0.20;   % minimum technical operational ratio
GT_3.PowRated    = 20e6;   % Rated power of the GT [W]
GT_3.R            = 20.2e6;   % Ramping rate
GT_3.Toff         = 4;      % Time between two start ups of the turbine [h]
GT_3.C_RR         = 1e-1;   % Cost of the ramping rate
GT_3.ComputeCosts();

% GT_3 smaller than the others
% GT_3              = GasTurbineX();
% GT_3.C_F         = 1.1*0.24; % fuel sale value [$/m^3]
% GT_3.rho          = 0.77; % density of the fuel [kg/m^3]
% GT_3.mu           = 2.682;  % ideal combustion coefficient of gas
% GT_3.C_CO2        = 1.1*0.07;   % tax per kg of CO2 [$/kg]
% GT_3.alpha_g      = 172.50e-6*1.1; % coeff for estimating modeling fuel consumption [kg/W]
% GT_3.beta_g       = 729.20*1.1; % coeff for estimating modeling fuel consumption [kg/h]
% GT_3.C_OeM        = 1.1*5.53e-6; % [$/W]
% GT_3.C_start      = 1.1*1217;   % Cost of starting the GT [$/start]
% GT_3.C_I_unitary  = 820e-3; % [$/W]
% GT_3.gamma        = 0.20;   % minimum technical operational ratio
% GT_3.PowRated    = 10e6;   % Rated power of the GT [W]
% GT_3.R            = 20.2e6;   % Ramping rate
% GT_3.Toff         = 4;      % Time between two start ups of the turbine [h]
% GT_3.C_RR         = 1e-1;   % Cost of the ramping rate
% GT_3.ComputeCosts();

GT_obj            = {GT_1, GT_2};
% GT_obj            = {GT_1};
n_GT              = size(GT_obj, 2);        % Maximum number of gas turbines to install

% define the Diesel Generator
DG_1              = DieselGeneratorX();
DG_1.C_F          = 1.1*1.75; % fuel sale value [$/l]
DG_1.rho          = 0.85; % density of the fuel [kg/l]
DG_1.mu           = 3.17;  % ideal combustion coefficient of gas
DG_1.C_CO2        = 0.071;   % tax per kg of CO2 [$/kg]
DG_1.alpha_g      = 2.34e-4; % coeff for estimating modeling fuel consumption [kg/W]
DG_1.beta_g       = 0; % coeff for estimating modeling fuel consumption
DG_1.C_OeM        = 1.1*5.53e-6;
DG_1.C_start      = 0;   % Cost of starting the GT
DG_1.C_I_unitary  = 2.1; % [$/W]
DG_1.gamma        = 0;   % minimum technical operational ratio
DG_1.PowRated     = 3e6;   % Rated power of the GT [W]
DG_1.R            = DG_1.PowRated*60;   % Ramping rate
DG_1.Toff         = 0;      % Time between two start ups of the turbine [h]
DG_1.C_RR         = 1e-1;   % Cost of the ramping rate
DG_1.ComputeCosts();
DG_1.base_power   = DG_1.PowRated; % rated power of the DG [W]

DG_obj            = {DG_1};
n_DG              = size(DG_obj, 2);        % Maximum number of gas turbines to install

base_CO2_tax = GT_1.C_CO2; % tax per kg of CO2 [$/kg]