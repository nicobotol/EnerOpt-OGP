classdef WindTurbineX < handle
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
  %   PowRated    - rated mechanical power [W]
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
      iniVec;           % Initial "vector" of data
      WindValue;        % Wind speed [m/s]
      Power;        % Wind power [W]
      V_in                    % cut-in wind speed [m/s]
      V_out                  % cut-out wind speed [m/s]
      V_rated              % rated wind speed [m/s]
      PowRated                    % rated mechanical power [W]
      Pe_rated;                   % rated electrical power [W]
      deloaded_coeff_min;         % coefficient for deloaded power 
      deloaded_coeff_max;         % coefficient for deloaded power 
      C_CAPEX             = 0; % [€] capital cost
      C_OPEX              = 0;  % [€/W] Operation and Maintenance cost
      C_DECOM             = 0;  % [€/W] Operation and Maintenance cost
      tau                 = 1;    % time constant of the power output [s]
      PC_wind             = [];   % wind speed axis of the power curve [m/s]
      PC_power            = [];   % power axis of the power curve [W]
      PC_factor                   % factor to multiply the power curve to convert it in [W]
      hub_height;                 % hub height of the wind turbine [m]
      WS_measure_height;          % height at which the WS was measured [m]
      WS_alpha;                   % coefficient for the wind shear
      max_installed_power;        % maximum installed power [W]
  end % properties
 

  methods
      % standard constructor
      function objData = WindTurbineX(varargin)
          % varargin{1} = data
          % varargin{2} = file name of the wind turbine power curve
          % varargin{3} = factor to multiply the power curve to convert it in [W]
          % Summary of constructor
          if nargin == 0
              %
              objData.iniVec = [];
          elseif nargin == 1
              %                 objData.iniVec = inputData./max(inputData,[],'all');
              objData.iniVec  = varargin{1};
          elseif nargin == 2
            objData.LoadPowerCurve(varargin{2});
            objData.iniVec  = varargin{1};
          elseif nargin == 3
            objData.LoadPowerCurve(varargin{2});
            objData.iniVec    = varargin{1};
            objData.PC_factor = varargin{3};
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
      % ---Method 1:   
      function objData = DoWindPower(objData)
          % DoWindPower computes the mechanical output power given the wind speed 
          % Example: test1.Pm=test1.DoWindPower(test1.WS,WT);
          % (test1 is the object)

          extrap_value = 0; % power for WS outside [V_in, V_out] range

          if isempty(objData.PC_power)
            Pm = objData.PowRated*(objData.WindValue/objData.V_rated).^3; % WT power in [W]
            Pm(objData.WindValue < objData.V_in | objData.WindValue > objData.V_out) = 0; % if the wind speed is below the cut-in or above the cut-out the power is 0
            Pm = min(Pm, objData.PowRated); % if the power exceed the rated power, the power is the rated power
          else 
            wind_cstr = objData.WindValue;
            % wind_cstr(wind_cstr > objData.V_out) = objData.V_out;
            % wind_cstr(wind_cstr < objData.V_in) = objData.V_in;

            % Rescale the wind speed to hub height
            wind_cstr = wind_cstr*(objData.hub_height/objData.WS_measure_height).^objData.WS_alpha;

            Pm = interp1(objData.PC_wind, objData.PC_power, wind_cstr, 'linear', extrap_value)*objData.PC_factor; % power curve
            objData.PowRated = max(Pm, [], 'all'); % rated power
          end 
          objData.Power = Pm;
      end
      % -----------------------------------------------------------------
  
      function E_wts = ReleasedEnergy(objData, P_wts_ref, t_s, t_f)
        % This function computes the integral of the power curve of the turbine after a step input of amplitude P_wts_ref between the time t_s and t_f
        
        E_wts = P_wts_ref*(t_f - t_s + objData.tau*(exp(-t_f/objData.tau) - exp(-t_s/objData.tau))); % [J]
      end

      function grouped = GroupSamplesBy(objData,samples2Average)
        % GroupSamplesBy Goups vector data by a specified group length
        % Example: test1.iniVec=test1.GroupSamplesBy(96);
        % (test1 is the object)

        L=length(objData.iniVec);
        grouped=zeros(samples2Average,L/samples2Average);
        igroup=1;
        for i=1:samples2Average:L
            igroupjsample =1;
            for j=i:1:i+samples2Average-1
                grouped(igroupjsample,igroup)=objData.iniVec(j);
                igroupjsample = igroupjsample+1;
            end
            igroup = igroup+1;
        end
      end

      function objData = LoadPowerCurve(objData, file_name)
        % This function loads the power curve of the wind turbine from a file
        % Example: test1 = test1.LoadPowerCurve();
        % (test1 is the object)

        % Load the power curve of the wind turbine
        data                = readmatrix(file_name);
        objData.PC_wind     = data(:, 1);
        objData.PC_power    = data(:, 2);
        objData.V_in   = objData.PC_wind(1);
        objData.V_out  = objData.PC_wind(end);

      end

  end
  %    
  %
end % classdef

