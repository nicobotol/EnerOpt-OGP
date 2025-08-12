classdef WECX < handle
  
 
  %   ____                            _   _           
  %  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
  %  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
  %  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
  %  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
  %                  |_|                              
    properties
        iniVec;           % Initial "vector" of data
        SWH;              % Significant Wave Height [m]
        W_period;         % Wave period [s]
        Power;         % Wave power [W]
        PowerMatrix;      % Power matrix [W]
        PowerMatrixAxes;  % Power matrix axes [W]
        PowRated;         % Rated power [W]
        C_CAPEX = 1e3;    % Capital cost of a WEC [$/W]
        C_OPEX = 0;     % Operational cost of a WEC [$/W]
        C_DECOM = 0;      % Decommissioning cost of a WEC [$/w]
        max_installed_power;
        WEC_coefficient = 1; % coefficient to rescale the power matrix
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
      % ---Method 1:   
      function objData = DoWECPowerPelamisP750(objData)
        % DoWECPower computes the power given the power matrix and its axes
        
        % SWH: significant wave height
        % W_period: wave period

        P_WEC = interp2(objData.PowerMatrixAxes(:, 2), objData.PowerMatrixAxes(1:16, 1), objData.PowerMatrix, objData.W_period, objData.SWH); % WEC power in [W]
        P_WEC = reshape(P_WEC, size(objData.W_period)); % each column is ona day, each row an hour
        P_WEC(isnan(P_WEC)) = 0; % if the WEC exceed rated power it is turn down, the power is 0

        % Store the data in objData
        objData.Power = P_WEC;

      end

      function objData = DoWECPowerCorpower(objData)
      % DoWECPower computes the power given the power matrix and its axes
      
      % SWH: significant wave height
      % W_period: wave period

      P_WEC = interp2(objData.PowerMatrixAxes(1:20, 2), objData.PowerMatrixAxes(1:30, 1), objData.PowerMatrix, objData.W_period, objData.SWH); % WEC power in [W]
      P_WEC = reshape(P_WEC, size(objData.W_period)); % each column is ona day, each row an hour
      P_WEC(isnan(P_WEC)) = 0; % if the WEC exceed rated power it is turn down, the power is 0

      % Store the data in objData
      objData.Power = P_WEC*objData.WEC_coefficient;

      end

      % -----------------------------------------------------------------
  
      function objData = import_powermatrix_pelamisP750(objData, filename_PM, dataLines_PM, filename_axes, dataLines_axes)

        %% Import axes first
        % Set up the Import Options and import the data
        opts_axes = delimitedTextImportOptions("NumVariables", 2);
        % Specify range and delimiter
        opts_axes.DataLines = dataLines_axes;
        opts_axes.Delimiter = ",";
        % Specify column names and types
        opts_axes.VariableNames = ["ThisFileContainsTheAxesForTheTablePelamis_P750_power_matrix", "VarName2"];
        opts_axes.VariableTypes = ["double", "double"];
        % Specify file level properties
        opts_axes.ExtraColumnsRule = "ignore";
        opts_axes.EmptyLineRule = "read";
        % Import the data
        pelamisP750powermatrixaxes1 = readtable(filename_axes, opts_axes);
        %Convert to output type
        objData.PowerMatrixAxes = table2array(pelamisP750powermatrixaxes1);


        %% Import power matrix
        % Set up the Import Options and import the data
        opts_PM = delimitedTextImportOptions("NumVariables", 23);

        % Specify range and delimiter
        opts_PM.DataLines = dataLines_PM;
        opts_PM.Delimiter = ",";

        % Specify column names and types
        opts_PM.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23"];
        opts_PM.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

        % Specify file level properties
        opts_PM.ExtraColumnsRule = "ignore";
        opts_PM.EmptyLineRule = "read";

        % Import the data
        pelamisP750powermatrix = readtable(filename_PM, opts_PM);

        %% Convert to output type
        pelamisP750powermatrix = table2array(pelamisP750powermatrix); % [kW]

        objData.PowerMatrix = pelamisP750powermatrix * 1000; % [W]
      end

      function objData = import_powermatrix_corpower(objData, filename_PM, dataLines_PM, filename_axes, dataLines_axes)

        %% Import axes first
        % Set up the Import Options and import the data
        opts_axes = delimitedTextImportOptions("NumVariables", 2);
        % Specify range and delimiter
        opts_axes.DataLines = dataLines_axes;
        opts_axes.Delimiter = ",";
        % Specify column names and types
        opts_axes.VariableNames = ["ThisFileContainsTheAxesForTheTablePelamis_P750_power_matrix", "VarName2"];
        opts_axes.VariableTypes = ["double", "double"];
        % Specify file level properties
        opts_axes.ExtraColumnsRule = "ignore";
        opts_axes.EmptyLineRule = "read";
        % Import the data
        pelamisP750powermatrixaxes1 = readtable(filename_axes, opts_axes);
        %Convert to output type
        objData.PowerMatrixAxes = table2array(pelamisP750powermatrixaxes1);


        %% Import power matrix
        % Set up the Import Options and import the data
        opts_PM = delimitedTextImportOptions("NumVariables", 23);

        % Specify range and delimiter
        opts_PM.DataLines = dataLines_PM;
        opts_PM.Delimiter = ",";

        % Import the data
        pelamisP750powermatrix =  readmatrix(filename_PM);

        objData.PowerMatrix = pelamisP750powermatrix * objData.WEC_coefficient; % [W]
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

    end
  %    
  %
  end % classdef
  
  