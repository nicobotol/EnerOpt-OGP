classdef DieselGeneratorX < handle
  
 
  %   ____                            _   _           
  %  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
  %  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
  %  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
  %  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
  %                  |_|                              
    properties
        iniVec;           % Initial "vector" of data
        C_I;              % Cost of the installation of the DG [$]
        C_I_unitary;      % Unitary cost of the installation of the DG [$/W]
        C_per_watt;             % cost proportional to the power produced
        C_on;          % Cost of aving the DG on
        C_start;       % Cost of starting the DG
        C_RR              % Cost of ramping rate
        gamma;            % minimum technicla operational ratio
        PowRated;       % Rated power of the DG
        R;                % Ramping rate
        Toff;             % Time between two start ups of the turbine
        n_DG;         % Maximum number of gas turbines to install
        C_F;             % fuel sale value [$/m^3]
        rho;              % density of the fuel [kg/m^3]
        mu;               % ideal combustion coefficient of gas
        C_CO2;            % tax per kg of CO2 [$/kg]
        alpha_g;          % coeff for estimating modeling fuel consumption
        beta_g;           % coeff for estimating modeling fuel consumption
        C_OeM;            % estimated cost of operation and maintenance [$/kWh]
        base_power;

    end % properties
   
  
    methods
        % standard constructor
        function objData = WECX(inputData)
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
      function grouped = GroupSamplesBy(objData,samples2Average)
        % GroupSamplesBy Goups vector data by a specified group lenDGh
        % Example: test1.iniVec=test1.GroupSamplesBy(96);
        % (test1 is the object)

        L=lenDGh(objData.iniVec);
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

      function ComputeCosts(objData)
        % This function computes the costs for the operation 
        objData.C_per_watt = (objData.C_F/objData.rho + objData.mu*objData.C_CO2)*objData.alpha_g + objData.C_OeM; % Cost per produced power
        objData.C_on = (objData.C_F/objData.rho + objData.mu*objData.C_CO2)*objData.beta_g; % Cost for keeping the DG on
        objData.C_I = objData.C_I_unitary*objData.PowRated; % Cost of the installation of the DG
      end
    end
  %    
  %
  end % classdef
  
  