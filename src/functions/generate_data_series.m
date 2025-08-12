%% This function generates data series statistically similar to the initial dataset 

% uniqueSeed = mod(now,10)*1e4;
% scenGenSetLoad.iniVec   = LoadA.DoCopulaOptBW(scenario, uniqueSeed);       
% cellScenGenSetRes       = cell(resource.number, 1);         % Cell containg all the renewable resources
% uniqueSeed = mod(now,10)*1e4; 
% cellScenGenSetRes{1}    = DataX(wind.DoCopulaOptBW(scenario, uniqueSeed));       % Wind 
% uniqueSeed = mod(now,10)*1e4;
% cellScenGenSetRes{2}    = DataX(irradiance.DoCopulaOptBW(scenario, uniqueSeed)); % Irradiance
% cellScenGenSetRes{2}.iniVec = max(cellScenGenSetRes{2}.iniVec, 0);
% uniqueSeed = mod(now,10)*1e4;
% cellScenGenSetRes{3}    = DataX(SWH.DoCopulaOptBW(scenario, uniqueSeed));        % Significant wave height
% uniqueSeed = mod(now,10)*1e4;
% cellScenGenSetRes{4}    = DataX(W_period.DoCopulaOptBW(scenario, uniqueSeed));   % Wave period          


uniqueSeed                                = mod(now,10)*1e4;
LoadA.iniVec                              = LoadA.UnGroupSamples;
% if j==idx_reduc_number
%   LoadA.iniVec = LoadA.iniVec(1:720*24);
% end
LoadA.iniVec                              = LoadA.GroupSamplesBy(scenario.T);
[tmp_load, ~, ES_load_tmp, ~, KL_load_tmp]  = LoadA.DoCopulaOptBW(scenario, uniqueSeed); % Find the optimal bw
scenGenSetLoad.iniVec                     = tmp_load;       
 
cellScenGenSetRes                         = cell(resource.number, 1);         % Cell containg all the renewable resources
uniqueSeed                                = mod(now,10)*1e4; 
wind.iniVec                               = wind.UnGroupSamples;
% if j==idx_reduc_number
%   wind.iniVec = wind.iniVec(1:720*24);
% end
wind.iniVec                               = wind.GroupSamplesBy(scenario.T);
[tmp_wind, ~, ES_wind_tmp, ~, KL_wind_tmp]  = wind.DoCopulaOptBW(scenario, uniqueSeed); % Find the optimal bw
cellScenGenSetRes{1}                      = DataX(tmp_wind);       % Wind 

uniqueSeed                                                  = mod(now,10)*1e4;
irradiance.iniVec                                           = irradiance.UnGroupSamples;
% if j==idx_reduc_number
%   irradiance.iniVec = irradiance.iniVec(1:720*24);
% end
irradiance.iniVec                                           = irradiance.GroupSamplesBy(scenario.T);
[tmp_irradiance, ~, ES_irradiance_tmp, ~, KL_irradiance_tmp]  = irradiance.DoCopulaOptBW(scenario, uniqueSeed); % Find the optimal bw
cellScenGenSetRes{2}                                        = DataX(tmp_irradiance); % Irradiance

uniqueSeed                            = mod(now,10)*1e4;
SWH.iniVec                            = SWH.UnGroupSamples;
% if j==idx_reduc_number
%   SWH.iniVec = SWH.iniVec(1:720*24);
% end
SWH.iniVec                            = SWH.GroupSamplesBy(scenario.T);
[tmp_SWH, ~, ES_SWH_tmp, ~, KL_SWH_tmp] = SWH.DoCopulaOptBW(scenario, uniqueSeed); % Find the optimal bw
cellScenGenSetRes{3}                  = DataX(tmp_SWH);        % Significant wave height

uniqueSeed                                            = mod(now,10)*1e4;
W_period.iniVec                                       = W_period.UnGroupSamples;
% if j==idx_reduc_number
%   W_period.iniVec = W_period.iniVec(1:720*24);
% end
W_period.iniVec                                       = W_period.GroupSamplesBy(scenario.T);
[tmp_W_period, ~, ES_W_period_tmp, ~, KL_W_period_tmp]  = W_period.DoCopulaOptBW(scenario, uniqueSeed); % Find the optimal bw
cellScenGenSetRes{4}                                  = DataX(tmp_W_period);   % Wave period 