classdef DumpLoadX < handle
 
%   ____                            _   _           
%  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
%  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
%  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
%  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
%                  |_|                              
  properties
    C_capital = 0;    % [€] capital cost
    C_OeM     = 1e1;  % [€/W] Operation and Maintenance cost
    Pct_max;          % [W] maximum power that can be dumped
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

