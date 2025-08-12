classdef BatteryX < handle
  % DataX class can perform the following operations on its objects:
  % 1) DoWindPower: computes the mechanical output power given the wind speed
  %
  % Static Methods:
  % 
  %-------------------------------------------------------
  % Example of creating an onject (test1) of this class:
  % test1 = DataX(GFA.P_Active_Total);
  %
  % DataX Properties:
  %   iniVec      - Initial "vector" of data
  %   V_in        - cut-in wind speed [m/s]
  %   V_out       - cut-out wind speed [m/s]
  %   V_rated     - rated wind speed [m/s]
  %   Pm_rated    - rated mechanical power [W]
  %   Pe_rated    - rated electrical power [W]
  %
  % DataX Methods:
  %   GroupSamplesBy
  
 
  
%   ____                            _   _           
%  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
%  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
%  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
%  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
%                  |_|                              
  properties
    C_batt                   % [Wh] battery capacity
    SOC_init     = 0.5;      % percentage of energy stored
    SOC_max      = 1;        % maximum energy stored
    SOC_min;      % minimum energy stored
    LPSP_target  = 0;        % Load Power Supply Probability target
    eta_conv     = 0.999999; % conversion efficiency
    eta_ch       = 1;        % charging efficiency
    eta_dc       = 1;        % discharging efficiency
    sigma_bt     = 0;        % self-discharge rate
    C_capital                % [€] capital cost
    C_charge                 % [€/W] Cost for charge the battery
    C_discharge              % [€/W] Cost for discharge the battery
    C_CAPEX_E                % [€] capital cost for the energy size
    C_CAPEX_P                % [€] capital cost for the power size
    C_OPEX_E                 % [€/W] operational cost
    C_OPEX_P                 % [€/W] operational cost
    C_DECOM      = 0.0;      % [€/W] operational cost
    Pch_max                  % [W] maximum charging power
    Pdc_max                  % [W] maximum discharging power
    E_max                    % [Wh] maximum energy stored
    constraint_weight = 1e10;  % weight for the soft 
  end % properties
 

  methods
      % standard constructor
      function objData = WindTurbineX(inputData)
          % Summary of constructor
          if nargin == 0
              %
              objData.iniVec = [];
          else
%                 objData.iniVec = inputData./max(inputData,[],'all');
              objData.iniVec = inputData;

          end
      end % standard constructor
      %
  end % normal methods

%   ____  _        _   _                       _   _               _     
%  / ___|| |_ __ _| |_(_) ___   _ __ ___   ___| |_| |__   ___   __| |___ 
%  \___ \| __/ _` | __| |/ __| | '_ ` _ \ / _ \ __| '_ \ / _ \ / _` / __|
%   ___) | || (_| | |_| | (__  | | | | | |  __/ |_| | | | (_) | (_| \__ \
%  |____/ \__\__,_|\__|_|\___| |_| |_| |_|\___|\__|_| |_|\___/ \__,_|___/
                                                                       
  methods(Static = true)
    % static methods

  end	% static methods
  
%   __  __      _   _               _     
%  |  \/  | ___| |_| |__   ___   __| |___ 
%  | |\/| |/ _ \ __| '_ \ / _ \ / _` / __|
%  | |  | |  __/ |_| | | | (_) | (_| \__ \
%  |_|  |_|\___|\__|_| |_|\___/ \__,_|___/
                                        
  methods
  
  end
  %    
  %
end % classdef

