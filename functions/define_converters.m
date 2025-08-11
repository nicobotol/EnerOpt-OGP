%% This script defines the different converters and their parameters

% Dump load
DL = DumpLoadX();
DL.C_OeM = 1e-3; % [$/W]

%    ____      _     _ 
%   / ___|_ __(_) __| |
%  | |  _| '__| |/ _` |
%  | |_| | |  | | (_| |
%   \____|_|  |_|\__,_|
                     
% Parameters related to the grid
GRID = GridX();

%  __        _______ 
%  \ \      / /_   _|
%   \ \ /\ / /  | |  
%    \ V  V /   | |  
%     \_/\_/    |_|  
                   
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
WT.V_in                 = 4;  % cut-in wind speed [m/s]
WT.V_out                = 25; % cut-out wind speed [m/s]
WT.V_rated              = 12; % rated wind speed [m/s]

%   ______     __
%  |  _ \ \   / /
%  | |_) \ \ / / 
%  |  __/ \ V /  
%  |_|     \_/   
               
PV                      = PhotoVoltaicX([]);
PV.A_eff                = 1.663; % [m^2] effective area of the PV panel
PV.eta_c                = 14.4/100; % conversion efficiency in STC
PV.C_CAPEX              = 7.5; % CAPEX [$/W]
PV.C_OPEX               = 0.11; % OPEX [$/W]
PV.C_DECOM              = 0.0; % decommissioning [$/W]
PV.PowRated             = 240; % [W] rated power
PV.max_area             = 5e4; % maximum area of the PV field [m^2]
PV.max_installed_power  = 200e6; % maximum power of the PV field [W]

%   ____      _                 _     
%  |  _ \ ___| | __ _ _ __ ___ (_)___ 
%  | |_) / _ \ |/ _` | '_ ` _ \| / __|
%  |  __/  __/ | (_| | | | | | | \__ \
%  |_|   \___|_|\__,_|_| |_| |_|_|___/
                                    
% WEC                     = WECX([]);
% WEC.C_CAPEX             = 30; % CAPEX [$/W]
% WEC.C_OPEX              = 4.75; % OPEX [$/W]
% WEC.PowRated            = 750e3; % rated power [W]
% pelamis_filename        = 'pelamis_P750_power_matrix.csv';
% pelamis_axes_filename   = 'pelamis_P750_power_matrix_axes.csv';
% dataLines_PM            = [1, inf];
% dataLines_axes          = [4, inf];
% WEC.import_powermatrix_pelamisP750(pelamis_filename, dataLines_PM, pelamis_axes_filename, dataLines_axes);
% WEC.max_installed_power = 50e6; % maximum tot WEC installed power [W]

%    ____                                        
%   / ___|___  _ __ _ __   _____      _____ _ __ 
%  | |   / _ \| '__| '_ \ / _ \ \ /\ / / _ \ '__|
%  | |__| (_) | |  | |_) | (_) \ V  V /  __/ |   
%   \____\___/|_|  | .__/ \___/ \_/\_/ \___|_|   
%                  |_|                           
WEC                     = WECX([]);
WEC.C_CAPEX             = 30; % CAPEX [$/W]
WEC.C_OPEX              = 4.75; % OPEX [$/W]
WEC.PowRated            = 400e3; % rated power [W]
corpower_filename        = 'converters_models/corpower_power_matrix.csv';
corpower_axes_filename   = 'converters_models/corpower_power_matrix_axes.csv';
dataLines_PM            = [1, inf];
dataLines_axes          = [4, inf];
WEC.import_powermatrix_corpower(corpower_filename, dataLines_PM, corpower_axes_filename, dataLines_axes);
WEC.max_installed_power = 60e6; % maximum tot WEC installed power [W]

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|
                         
load_scenarios                = LoadX([]);
load_scenarios.delta_load     = 0.1; % percentage of the load generating power imbalance
load_scenarios.NS_cost        = 1e-2; % cost of not served energy [$/Wh]
load_scenarios.LPSP_target    = 0.01;
load_scenarios.NS_fraction    = 0.1; % fraction of the load that can be not served
load_scenarios.P_rated        = 50e6; % rated power of the load [W]
load_scenarios.P_shaved_frac  = 0.3; % fraction of rated power that can be re-allocated within the time horizon
load_scenarios.P_shaved_overpower = 1.1; % factor of increase of load power w.r.t. the rated power when doing peak shaving
load_scenarios.Pps_add_cost    = 1e-6;
load_scenarios.Pps_rem_cost    = 1e-6;
load_scenarios.Pyr_add_cost    = 1e-5;
load_scenarios.Pyr_rem_cost    = 1e-5;

%   ____  _____ ____ ____  
%  | __ )| ____/ ___/ ___| 
%  |  _ \|  _| \___ \___ \ 
%  | |_) | |___ ___) |__) |
%  |____/|_____|____/____/ 
                         
% Define the battery
BAT = BatteryX();
BAT.C_batt      = 1; % Capacity of 1 battery module [Wh]
BAT.C_CAPEX_E   = 0.380; % CAPEX+OPEX for the energy [$/Wh]
BAT.C_CAPEX_P   = 1.485; % CAPEX+OPEX for the power [$/W]
BAT.C_OPEX_E    = 0.01*BAT.C_CAPEX_E; % OPEX [$/Wh]
BAT.C_OPEX_P    = 0.01*BAT.C_CAPEX_P; % OPEX [$/W]
BAT.C_DECOM     = 0.0; % decommissioning [$/W]
BAT.C_charge    = 1.8e-3;
BAT.C_discharge = 1.8e-3;
BAT.constraint_weight=1e-3; % cost of violating the soft constraint
BAT.SOC_min     = 0.3; % fraction minimum energy stored
ESS = ESSX();
ESS.BAT = BAT;

%    ____ _____ 
%   / ___|_   _|
%  | |  _  | |  
%  | |_| | | |  
%   \____| |_|  
              
% Define the GT
GT              = GasTurbineX();
GT.C_per_watt         = 50;             % cost of fuel GT
GT.C_on      = 50;          % Cost of aving the GT on
GT.C_start   = 50;       % Cost of starting the GT
GT.gamma        = 0.20;            % minimum technicla operational ratio
GT.PowRated   = 2.5e6;       % Rated power of the GT [W]
GT.R            = GT.PowRated;                % Ramping rate
GT.T_off        = 4;            % Time between two start ups of the turbine [h]