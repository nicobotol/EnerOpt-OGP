%% This script imports the datasets of the different resources

%  __        ___           _ 
%  \ \      / (_)_ __   __| |
%   \ \ /\ / /| | '_ \ / _` |
%    \ V  V / | | | | | (_| |
%     \_/\_/  |_|_| |_|\__,_|
                           
file_name                   = "1stat_2022-02-16_2024-05-30_hourly_wide.csv";
[met_data, met_data_param]  = import_data_Ploze_array(file_name, [1, 730*24+1], scenario.T); 
wind                        = DataX(met_data(:,2));                           % WIND timeseries
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
Pload           = readmatrix(load_file_name)*load.nominal_load;
LoadA           = DataX([Pload; Pload]);                                         % LOAD timeseries
% LoadA           = DataX([Pload]);                                         % LOAD timeseries
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
                                                  
file_name_PV      = "datasets/irradiance_Lanzarote2014-2015.csv";
met_irradiance    = import_PV_lanzarote(file_name_PV, [5, inf]); % load irradaince data [kW/m^2] 
irradiance        = DataX(met_irradiance);
irradiance.iniVec = irradiance.GroupSamplesBy(scenario.T);
irradiance.bw_range = linspace(0.01, 0.4, 10);

%  __        __              
%  \ \      / /_ ___   _____ 
%   \ \ /\ / / _` \ \ / / _ \
%    \ V  V / (_| |\ V /  __/
%     \_/\_/ \__,_| \_/ \___|

file_name_wave  = "datasets/15771_22353_1023015_WAVE_20140101121357_20151231121357.csv";
wave_data       = import_wave_lanzarote(file_name_wave, [2, inf]); % load wave data [m]
met_SWH         = wave_data(:, 1); % significant wave height [m]
met_W_period    = wave_data(:, 2); % wave period [s]
SWH             = DataX(met_SWH);
W_period        = DataX(met_W_period);
SWH.iniVec      = SWH.GroupSamplesBy(scenario.T);
W_period.iniVec = W_period.GroupSamplesBy(scenario.T);
SWH.bw_range    = linspace(0.01, 0.4, 10);
W_period.bw_range = linspace(0.01, 0.4, 10); 