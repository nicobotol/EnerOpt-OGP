%% This script imports the datasets of the different resources

hours_start = 365*24+1;
hours_end = 730*24;

%  __        ___           _ 
%  \ \      / (_)_ __   __| |
%   \ \ /\ / /| | '_ \ / _` |
%    \ V  V / | | | | | (_| |
%     \_/\_/  |_|_| |_|\__,_|
                           
% file_name       = "meteo_data_import/norway/POWER_Point_Hourly_20220101_20231231_060d00N_002d50E_LST.csv";
% file_name       = "meteo_data_import/norway/norway_2022_2023_wind_100m.txt";
file_name       = "meteo_data_import/norway/norway_2022_2023_wind_112m.txt";
met_data_wind   = readmatrix(file_name, 'CommentStyle',{'!','%'});
% met_data_wind   = readtable(file_name, 'CommentStyle',{'!','%'});
wind            = DataX(met_data_wind(hours_start:hours_end));                           % WIND timeseries
% wind            = DataX(met_data_wind.WSC);                           % WIND timeseries
scenGenSetWind  = DataX();
wind.iniVec     = wind.GroupSamplesBy(scenario.T);
wind.bw_range   = unique([0.01:0.01:0.08,0.08:0.02:0.25]); % range where to look for the optimal bandwidth
% wind.bw_range   = 0.05:0.01:0.08; % range where to look for the optimal bandwidth

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|
                         
% load_file_name  = "datasets/load_lanzaroteFuerteventura.csv";
% Pload           = import_load_lanzarote(load_file_name, [2, inf])*1e6;  % houly energy in [kWh], since the sample time is hour it is necerically equivalent to the power in kW
% Pload(15890)    = 1.2e8;
% Pload(4736)     = 1.2e8;
% Pload(7971)     = 1.2e8;
% Pload           = Pload/45;
load_file_name  = "load_data/generated_unitary_load_730h_scenario.txt"; % unitary load
Pload           = readmatrix(load_file_name)*load_scenarios.P_rated;
LoadA           = DataX([Pload; Pload]); % LOAD timeseries
% LoadA           = DataX([Pload]);                                         % LOAD timeseries
LoadA.iniVec    = LoadA.iniVec(hours_start:hours_end);
LoadA.iniVec    = LoadA.GroupSamplesBy(scenario.T);
LoadA.bw_range  = linspace(0.01, 0.4, 10); % range where to look for the optimal bandwidth
scenGenSetLoad  = DataX();
min_load        = load_scenarios.NS_fraction*load_scenarios.P_rated;
LoadA.iniVec(LoadA.iniVec <= min_load) = min_load;

%   ___                    _ _                      
%  |_ _|_ __ _ __ __ _  __| (_) __ _ _ __   ___ ___ 
%   | || '__| '__/ _` |/ _` | |/ _` | '_ \ / __/ _ \
%   | || |  | | | (_| | (_| | | (_| | | | | (_|  __/
%  |___|_|  |_|  \__,_|\__,_|_|\__,_|_| |_|\___\___|
                                                  
% file_name       = "ninja_pv_60.0000_2.5000_uncorrected_2022_2023.csv";
% met_data_irr        = readtable(file_name);
% irradiance      = DataX(met_data_irr.irradiance_direct*1e3);         % direct irradiance
file_name       = "meteo_data_import/norway/norway_nasa.csv";
met_data_irr        = readtable(file_name, "CommentStyle", '%');
irradiance      = DataX(met_data_irr.ALLSKY_SFC_SW_DWN(hours_start:hours_end));         % direct irradiance
irradiance.iniVec = irradiance.GroupSamplesBy(scenario.T);
irradiance.bw_range = linspace(0.01, 0.4, 10);

%  __        __              
%  \ \      / /_ ___   _____ 
%   \ \ /\ / / _` \ \ / / _ \
%    \ V  V / (_| |\ V /  __/
%     \_/\_/ \__,_| \_/ \___|

file_name_mwp  = "meteo_data_import/norway/norway_2022_2023_pp1d.txt";
met_data_mwp        = readmatrix(file_name_mwp);
met_data_mwp = met_data_mwp(hours_start:hours_end);
W_period        = DataX(met_data_mwp);
% W_period        = DataX(met_data_mwp(hours_start:hours_end));   
W_period.iniVec = W_period.GroupSamplesBy(scenario.T);
W_period.bw_range = linspace(0.01, 0.3, 10); 

file_name_swh   = "meteo_data_import/norway/norway_2022_2023_swh.txt";
met_data_swh        = readmatrix(file_name_swh);
met_data_swh  = met_data_swh(hours_start:hours_end);
SWH             = DataX(met_data_swh);        
SWH.iniVec      = SWH.GroupSamplesBy(scenario.T);
SWH.bw_range    = linspace(0.01, 0.4, 10); 