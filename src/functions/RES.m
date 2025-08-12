function [RES_power] = RES(meteo, devices, met_data_param)
% This function computes the renewable resources starting from the meteo data and the devices parameters. For the moment the script computes only the pwer from the solar panel and the wind turbine with two simple models

PV = devices.PV;
WT = devices.WT;

% Wind
% P_WT = interp1(WT.power_curve(:, 1), WT.power_curve(:, 2), meteo(:, 2)); % WT power in [W]
P_WT = WT.P_rated*(meteo(:, 2)/WT.v_rated).^3; % WT power in [W]
P_WT(meteo(:, 2) < WT.v_cutin | meteo(:, 2) > WT.v_cutout) = 0; % if the wind speed is below the cut-in or above the cut-out the power is 0
P_WT = min(P_WT, WT.P_rated); % if the power exceed the rated power, the power is the rated power
P_WT = reshape(P_WT, [met_data_param.scenario_len, met_data_param.num_scenarios]); % each column is ona day, each row an hour

% Solar PV
P_PV = PV.eta_c*PV.A_eff*meteo(:, 1); % PV power in [W]
P_PV = reshape(P_PV, [met_data_param.scenario_len, met_data_param.num_scenarios]); % each column is ona day, each row an hour

% WEC
if size(meteo, 2) > 2 % there are the information for the WEC
  WEC = devices.WEC;
  P_WEC = interp2(WEC.powermatrix_axes(:, 2), WEC.powermatrix_axes(1:16, 1), WEC.powermatrix, meteo(:, 4), meteo(:, 3)); % WEC power in [W]
  P_WEC = reshape(P_WEC, [met_data_param.scenario_len, met_data_param.num_scenarios]); % each column is ona day, each row an hour
  P_WEC(isnan(P_WEC)) = 0; % if the WEC exceed rated power it is turn down, the power is 0
else
  P_WEC = zeros(met_data_param.scenario_len, met_data_param.num_scenarios);
end

RES_power.P_WT = P_WT;
RES_power.P_PV = P_PV;
RES_power.P_WEC = P_WEC;

end