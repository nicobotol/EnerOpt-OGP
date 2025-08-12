% this function computes the power of the different renewable energy converters using the loaded data

%  __        _______ 
%  \ \      / /_   _|
%   \ \ /\ / /  | |  
%    \ V  V /   | |  
%     \_/\_/    |_|  
                   
WT.WindValue = wind.iniVec;
WT.DoWindPower;
WT.Power(WT.Power < 1e-5) = 1e-5;

%   ______     __
%  |  _ \ \   / /
%  | |_) \ \ / / 
%  |  __/ \ V /  
%  |_|     \_/   
               
PV.RadiationValue = irradiance.iniVec;
PV.DoPVPower;
PV.Power(PV.Power<=1e-8) = 1e-8;

%  __        _______ ____ 
%  \ \      / / ____/ ___|
%   \ \ /\ / /|  _|| |    
%    \ V  V / | |__| |___ 
%     \_/\_/  |_____\____|
                        
WEC.iniVec              = met_data_swh;
WEC.iniVec              = reshape(WEC.iniVec, [], 1);
WEC.SWH                 = [];
WEC.SWH                 = WEC.GroupSamplesBy(scenario.T);
% WEC.iniVec              = cellScenGenSetRes{4}.iniVec;
WEC.iniVec              = met_data_mwp;
WEC.iniVec              = reshape(WEC.iniVec, [], 1);
WEC.W_period            = [];
WEC.W_period            = WEC.GroupSamplesBy(scenario.T);
WEC.PowRated            = WEC.WEC_coefficient*max(WEC.PowerMatrix, [], 'all');
WEC.DoWECPowerCorpower; 

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|

Pload = LoadA.iniVec; % Load data
load_scenarios.iniVec = Pload;
% Extract some data from the Pload and meteo
scenario_len = size(Pload, 1);  % number of data in each scenario 
num_scenarios = size(Pload, 2); % number of scenarios (e.g. days)
LscensProbVec_N = 1/num_scenarios*ones(num_scenarios,1);