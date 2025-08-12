classdef RECX < handle
  % RECX contains all the Renewable Energy Conversion classes
  
 
  
%   ____                            _   _           
%  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
%  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
%  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
%  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
%                  |_|                              
  properties
    RES_power = []; % Total renewable power [W]
    WT  = []; % Wind Turbine
    PV  = []; % Photovoltaic
    WEC = []; % Wave Energy Converter
    GT  = []; % Gas Turbine
    DG  = []; % Diesel Generator
    DGv = []; % Diesel Generator
    Pv  = []; % virtual power
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
      % ---Method 1:   
      function objData = ComputeRESPower(objData)
          % ComputeRESPower computes the power of all the REC
          % Example: test1.Pm=test1.DoWindPower(test1.WS,WT);
          % (test1 is the object)

          tmp = 0;
          if ~isempty(objData.WT)
              tmp = tmp + objData.WT.Power;
          end
          if ~isempty(objData.PV)
              tmp = tmp + objData.PV.Power;
          end
          if ~isempty(objData.WEC)
              tmp = tmp + objData.WEC.Power;
          end
          objData.RES_power = tmp;
          
      end
      % -----------------------------------------------------------------
  
  end
  %    
  %
end % classdef

