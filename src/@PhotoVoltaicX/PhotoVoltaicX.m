classdef PhotoVoltaicX < handle
  
%   ____                            _   _           
%  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
%  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
%  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
%  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
%                  |_|                              
  properties
      iniVec;           % Initial "vector" of data
      RadiationValue;   % Irradiance speed [m/s]
      Power;          % Solar power [W]
      A_eff           % [m^2] effective area of the PV panel
      eta_c           % conversion efficiency
      eta_AC          % Conversion efficiency DC to AC
      PowRated;       % [W] rated power
      C_OPEX          % [€/W] Operation and Maintenance cost
      C_CAPEX         % [€] capital cost
      C_DECOM   = 0;  % [€/W] decommissioning cost
      max_area;       % maximum area of the PV field [m^2]
      max_installed_power; % max power of the PV field [W]
      power_coefficient; % coefficient for rescaling the power in different units
  end % properties
 

  methods
      % standard constructor
      function objData = PhotoVoltaicX(inputData)
          % Summary of constructor
          if nargin == 0
              objData.iniVec = [];
          else
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
      % ---Method 1:   
      function objData = DoPVPower(objData)
          % DoPVPower computes the power given the radiation
          % Example: test1.Pm=test1.DoPVPower(test1.WS,WT);
          % (test1 is the object)

          objData.Power = objData.A_eff*objData.eta_c*objData.eta_AC*objData.RadiationValue*objData.power_coefficient; % [W]
        
      end
      % -----------------------------------------------------------------
  
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
  end
  %    
  %


end % classdef

