classdef GridX < handle
  
 
  %   ____                            _   _           
  %  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
  %  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
  %  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
  %  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
  %                  |_|                              
    properties
        iniVec;           % Initial "vector" of data
        f_G0      = 50;   % Nominal Frequency [rad/s]
        omega_G0;         % Nominal Rotational Speed [rad/s]
        r_tr      = 0.05;  % Max transient frequency deviation [-]
        r_ss      = 0.02;  % Max steady state frequency deviation [-]
        RoCoF_max = 0.5;  % Max Rate of Change of Frequency [Hz/s]
        t_0       = 0;    % time intial load umbalance [s]
        t_a       = 5;    % time inertia control [s]
        t_b       = 20;   % time primary control [s]
        t_c       = 600;  % time secondary control [s]
    end % properties
   
  
    methods
        % standard constructor
        function objData = GridX(inputData)
            % Summary of constructor
            if nargin == 0
                objData.iniVec = [];
                objData.omega_G0 = 2*pi*objData.f_G0;
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
    

    end
  %    
  %
  end % classdef
  
  