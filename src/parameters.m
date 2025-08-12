%% Configuration parameters for the Lanzarote case study

%    ____                           _ 
%   / ___| ___ _ __   ___ _ __ __ _| |
%  | |  _ / _ \ '_ \ / _ \ '__/ _` | |
%  | |_| |  __/ | | |  __/ | | (_| | |
%   \____|\___|_| |_|\___|_|  \__,_|_|
                                    
                                                    
general.dispFigs    = 1;            % 1: YES | 0: NO
general.dispPrints  = 1;            % 1: YES | 0: NO
general.riskA       = 0.8;         % Risk control parameter alpha
general.riskB       = 0;           % Risk control parameter beta
general.MIPGap      = 0.0017;
warning('off', 'stats:ksdensity:NoConvergence');
rngSeed = 2;
rng(rngSeed);
uniqueSeed = mod(now,10)*1e4;

%   ____                            _       
%  / ___|  ___ ___ _ __   __ _ _ __(_) ___  
%  \___ \ / __/ _ \ '_ \ / _` | '__| |/ _ \ 
%   ___) | (_|  __/ | | | (_| | |  | | (_) |
%  |____/ \___\___|_| |_|\__,_|_|  |_|\___/ 

scenario.hours_start      = 365*24+1; % Time when start to load data from the dataset
scenario.hours_stop       = 730*24;   % Time when start to load data from the dataset
scenario.T                = 24;    % numbers of unit of time in a scenario
scenario.tau              = 1; % minimum time resolution for the optimization problem (in hours)
scenario.h                = 24; % time horizon for the optimization problem (in hours)
scenario.T                = scenario.h/scenario.tau;   % numbers of unit of time in a scenario
scenario.h_star           = scenario.h; % time horizon for the optimization problem (in hours)
scenario.d_o              = 1/365; % scaling factor from annual to daily cost 
scenario.simulation_type  = 1;

%    ___        _   _           _          _   _             
%   / _ \ _ __ | |_(_)_ __ ___ (_)______ _| |_(_) ___  _ __  
%  | | | | '_ \| __| | '_ ` _ \| |_  / _` | __| |/ _ \| '_ \ 
%  | |_| | |_) | |_| | | | | | | |/ / (_| | |_| | (_) | | | |
%   \___/| .__/ \__|_|_| |_| |_|_/___\__,_|\__|_|\___/|_| |_|
%        |_|                                                 

opt_parameters.alpha          = 0.8;
opt_parameters.beta           = 0.5;
opt_parameters.r_annual       = 0.07; % daily inrerest rate
opt_parameters.r              = opt_parameters.r_annual/365; % daily inrerest rate
opt_parameters.L              = 10; % investment lifetime
opt_parameters.BESS_NL_model  = 1; % 0 -> linear model, 1 -> Nonlinear model

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|                

%    ____      _     _ 
%   / ___|_ __(_) __| |
%  | |  _| '__| |/ _` |
%  | |_| | |  | | (_| |
%   \____|_|  |_|\__,_|

%   ______     __                         _ 
%  |  _ \ \   / /  _ __   __ _ _ __   ___| |
%  | |_) \ \ / /  | '_ \ / _` | '_ \ / _ \ |
%  |  __/ \ V /   | |_) | (_| | | | |  __/ |
%  |_|     \_/    | .__/ \__,_|_| |_|\___|_|
%                 |_|                       

%  __        ___           _   _              _     _            
%  \ \      / (_)_ __   __| | | |_ _   _ _ __| |__ (_)_ __   ___ 
%   \ \ /\ / /| | '_ \ / _` | | __| | | | '__| '_ \| | '_ \ / _ \
%    \ V  V / | | | | | (_| | | |_| |_| | |  | |_) | | | | |  __/
%     \_/\_/  |_|_| |_|\__,_|  \__|\__,_|_|  |_.__/|_|_| |_|\___|

%   ____        _   _                   
%  | __ )  __ _| |_| |_ ___ _ __ _   _  
%  |  _ \ / _` | __| __/ _ \ '__| | | | 
%  | |_) | (_| | |_| ||  __/ |  | |_| | 
%  |____/ \__,_|\__|\__\___|_|   \__, | 
%                                |___/  

%   ____                        
%  |  _ \ _   _ _ __ ___  _ __  
%  | | | | | | | '_ ` _ \| '_ \ 
%  | |_| | |_| | | | | | | |_) |
%  |____/ \__,_|_| |_| |_| .__/ 
%                        |_|    

%   ____                                         
%  |  _ \ ___  ___  ___  _   _ _ __ ___ ___  ___ 
%  | |_) / _ \/ __|/ _ \| | | | '__/ __/ _ \/ __|
%  |  _ <  __/\__ \ (_) | |_| | | | (_|  __/\__ \
%  |_| \_\___||___/\___/ \__,_|_|  \___\___||___/
resource.number = 1; % Number of renewable energy resources

%   ____  _       _   
%  |  _ \| | ___ | |_ 
%  | |_) | |/ _ \| __|
%  |  __/| | (_) | |_ 
%  |_|   |_|\___/ \__|
                    
plot_param.font_size = 12;
plot_param.line_width = 1.5;
plot_param.print_figure = 0;
marker_vec = {'x', 'o', 'd'};

% Create custom colormap
n = 256; % Number of colors in the colormap
rgb_red = color(2);
whiteToRed = [linspace(1, rgb_red(1), n)', linspace(1, rgb_red(2), n)', linspace(1, rgb_red(3), n)']; % White to red gradient
% Insert blue for zero value
customColormap = [color(1); whiteToRed];

set(0,'DefaultFigureWindowStyle','docked');
beep off;

%   ____       _   _     
%  |  _ \ __ _| |_| |__  
%  | |_) / _` | __| '_ \ 
%  |  __/ (_| | |_| | | |
%  |_|   \__,_|\__|_| |_|
                       
addpath(genpath('meteo_data_import'));
addpath(genpath(['converters_models']));
addpath(genpath(['cases']));
addpath(genpath(['functions']));
addpath(genpath(['plot_function']));