% This file creates the scenarios using the initial load dataset

% Raplace the "Converters" section in tha main file with this

%    ____                                _                
%   / ___|___   ___  _ ____   _____ _ __| |_ ___ _ __ ___ 
%  | |   / _ \ / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__/ __|
%  | |__| (_) | (_) | | | \ V /  __/ |  | ||  __/ |  \__ \
%   \____\___/ \___/|_| |_|\_/ \___|_|   \__\___|_|  |___/
                  
define_converters % define the converters and their parameters

WT.iniVec               = reshape(wind.iniVec, [], 1);
WT.WindValue            = [];
WT.Power            = [];
WT.WindValue            = WT.GroupSamplesBy(scenario.T);
WT.DoWindPower;


PV.iniVec               = reshape(irradiance.iniVec, [], 1);
PV.RadiationValue       = [];
PV.Power              = [];
PV.RadiationValue       = PV.GroupSamplesBy(scenario.T);
PV.DoPVPower;


WEC.iniVec              = reshape(SWH.iniVec, [], 1);
WEC.SWH                 = [];
WEC.SWH                 = WEC.GroupSamplesBy(scenario.T);
WEC.iniVec              = reshape(W_period.iniVec, [], 1);
WEC.W_period            = [];
WEC.W_period            = WEC.GroupSamplesBy(scenario.T);
WEC.PowRated            = max(WEC.PowerMatrix, [], 'all');
WEC.DoWECPower;

% load_scenarios.iniVec = LselScens_N;
load_scenarios.iniVec = [Pload;Pload];
LscensProbVec_N = 1/730*ones(730,1);
load_scenarios.iniVec = load_scenarios.GroupSamplesBy(scenario.T);

% Collect all the Renewable Energy Converters (REC) in one structure
REC = RECX();
REC.WT = WT; 
REC.PV = PV;
REC.WEC = WEC;