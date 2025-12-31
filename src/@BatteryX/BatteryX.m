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
    deg_coeff_A              % coefficient A of the BESS degradation model
    deg_coeff_B              % coefficient B of the BESS degradation model
    num_points_deg_approx    % number of points to be used for the PLA of the damage function
    x_deg                    % abscissa for the damage function (battery energy in [MWh])
    y_deg                    % ordinate for the damage function (damage)
    eol_fraction             % fraction of the initial value that the asset has at its end of live
    L_sh                     % shelf lifetime of the battery
    deg_cost_enable          % 1 if the degradation cost is considered, 0 otherwise 
    year_deg                 % years that the battery has to last
    max_day_deg              % maximum allowed daily degradation
  end % properties
 

  methods
    function objData = BuildDegradationPoints(objData)
      % BuildDegradationPoints generates the points that will be then used in the piecewise linear approximation for the degradation model of the battery

      C_batt = objData.C_batt; % capacity of one battery model
      A = objData.deg_coeff_A; % coefficient of the damage function
      B = objData.deg_coeff_B; % coefficient of the damage function
      num_points_deg_approx = objData.num_points_deg_approx; % number of points to be used for the PLA of the damage function

      x_deg = linspace(0,1,num_points_deg_approx)'; % ordinate points of the interpolation (state of charge)
      y_deg = A*(1 - x_deg).^B;
    
      objData.x_deg = x_deg;
      objData.y_deg = y_deg;
    end
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

