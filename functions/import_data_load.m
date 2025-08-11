function Pload = import_data_load(filename, num_days)
%IMPORT_DATA_LOAD Import load data from a file

% import Pload data
load_data = readtable(filename); % [kW]
rep_load = repmat(load_data.Var2, num_days, 1)*1000; % [W]
Pload = reshape(rep_load, [24, num_days]); % each column is ona day, each row an hour

% Pload = rep_load; % enable for optimizing the whole year together

end