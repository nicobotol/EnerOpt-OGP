function [values_reshaped, values] = reshape_data(values, Pload, Pres_vec, BAT)
  
  values_reshaped.Pload   = reshape(Pload, [], 1);
  values.Eload  = trapz(values_reshaped.Pload); % Energy required by the load [Wh]

  if isfield(values, 'Pct') 
    values_reshaped.Pct     = reshape(values.Pct, [], 1);
    values.Ect    = trapz(values_reshaped.Pct); % Dumped energy [Wh]
  end
  
  if isfield(values, 'Pns') 
    values_reshaped.Pns  = reshape(values.Pns, [], 1);
  end
  
  %   ____  _____ ____ ____  
  %  | __ )| ____/ ___/ ___| 
  %  |  _ \|  _| \___ \___ \ 
  %  | |_) | |___ ___) |__) |
  %  |____/|_____|____/____/ 
                         
  if isfield(values, 'Pch') % just if there is the BESS
    values.Pbt = values.Pch - values.Pdc; 
    values_reshaped.Pbt     = reshape(values.Pbt, [], 1);
    values_reshaped.Pch     = reshape(values.Pch, [], 1);
    values_reshaped.Pdc     = reshape(values.Pdc, [], 1);
    values_reshaped.E       = cumsum(values_reshaped.Pch - values_reshaped.Pdc);
    values_reshaped.Ebt     = reshape(values.Ebt, [], 1);
    values_reshaped.PchUch     = reshape(values.PchUch, [], 1);
    values_reshaped.PdcUdc     = reshape(values.PdcUdc, [], 1);
    values_reshaped.Uch     = reshape(values.Uch, [], 1);
    values_reshaped.Udc     = reshape(values.Udc, [], 1);
    % maximum storing capacity of the battery
    values.Ebt_max          = values.x_ESS_IV*BAT.C_batt;
    values.Ebt_min          = values.x_ESS_IV*BAT.C_batt*BAT.SOC_min;
  elseif isfield(values, 'Pbt') % just if there is the BESS
    values_reshaped.Pbt     = reshape(values.Pbt, [], 1);
    values_reshaped.E       = cumsum(values_reshaped.Pbt);
    values_reshaped.Ebt     = reshape(values.Ebt, [], 1);
    % maximum storing capacity of the battery
    values.Ebt_max = values.x_ESS_IV*BAT.C_batt;
    values.Ebt_min = values.x_ESS_IV*BAT.C_batt*BAT.SOC_min;
  else
    values_reshaped.Ebt = zeros(size(values_reshaped.Pload));
    values.Ebt_max = 0;    
    values.Ebt_min = 0;
  end

  if isfield(values, 'x_ESS_IV')
  else
    values.x_ESS_IV = 0;
    values.x_ESS_NIV = 0;
  end

  %   ____  _____ ____ 
  %  |  _ \| ____/ ___|
  %  | |_) |  _|| |    
  %  |  _ <| |__| |___ 
  %  |_| \_\_____\____|
                     
  if isfield(values,'x_REC') 
    % values_reshaped.P_PV = Pres_vec(:, 1)*values.x_REC(1);
    % values_reshaped.P_WT = Pres_vec(:, 2)*values.x_REC(2);
    % values_reshaped.P_WEC = Pres_vec(:, 3)*values.x_REC(3);
    % values_reshaped.Pres_max = values_reshaped.P_PV + values_reshaped.P_WT + values_reshaped.P_WEC; % maximum power from the RECs
    values_reshaped.Pres_max = Pres_vec*values.x_REC;
    values_reshaped.P_res = reshape(values.P_res, [], 1); % power provided by RECs
    % values.E_PV   = trapz(values_reshaped.P_PV); % Energy provided by the PV [Wh]
    % values.E_WT   = trapz(values_reshaped.P_WT); % Energy provided by the WT [Wh]
    % values.E_WEC  = trapz(values_reshaped.P_WEC); % Energy provided by the WEC [Wh]
    % values.E_REC  = values.E_PV + values.E_WT + values.E_WEC; % Total renewable energy [Wh]
    
  end

  %   ____  ____  
  %  |  _ \|  _ \ 
  %  | | | | |_) |
  %  | |_| |  _ < 
  %  |____/|_| \_\

  if  isfield(values,'Pps_add')
    if ~isempty(values.Pps_add) 
      values_reshaped.Pps_add = reshape(values.Pps_add, [], 1);
      values_reshaped.Pps_rem = reshape(values.Pps_rem, [], 1);
      values_reshaped.Pps = values_reshaped.Pps_add - values_reshaped.Pps_rem;
      values_reshaped.Pload_PS = values_reshaped.Pload + values_reshaped.Pps;
    end
  end

  %   ____        
  %  |  _ \__   __
  %  | |_) \ \ / /
  %  |  __/ \ V / 
  %  |_|     \_/  
                
  if isfield(values, 'P_DGv') 
    values_reshaped.P_DGv  = reshape(values.P_DGv, [], 1);
  end

  %   _____                                         
  %  |  ___| __ ___  __ _     ___ _   _ _ __  _ __  
  %  | |_ | '__/ _ \/ _` |   / __| | | | '_ \| '_ \ 
  %  |  _|| | |  __/ (_| |_  \__ \ |_| | |_) | |_) |
  %  |_|  |_|  \___|\__, (_) |___/\__,_| .__/| .__/ 
  %                    |_|             |_|   |_|    
  
  if isfield(values, 'P_WTsM') 
    values_reshaped.P_WTsD      = reshape(values.P_WTsD, [], 1);
    values_reshaped.P_WTsM      = reshape(values.P_WTsM, [], 1);
    values_reshaped.P_ESsD      = reshape(values.P_ESsD, [], 1);
    values_reshaped.P_ESsM      = reshape(values.P_ESsM, [], 1);
    values_reshaped.P_WTs       = values_reshaped.P_WTsD + values_reshaped.P_WTsM;
    values_reshaped.P_ESs       = values_reshaped.P_ESsD + values_reshaped.P_ESsM;  
    values_reshaped.E_ESs_tmp   = reshape(values.E_ESs_tmp, [], 1); % energy stored for inertia support
    values_reshaped.E_ES_upper  = values_reshaped.Ebt + values_reshaped.E_ESs_tmp;
    values_reshaped.E_ES_lower  = values_reshaped.Ebt - values_reshaped.E_ESs_tmp;
  end
  
  if isfield(values, 'Pns_virtual') 
    values_reshaped.Pns_virtual  = reshape(values.Pns_virtual, [], 1);
  end

  if isfield(values, 'Pns_virtual_s') 
    values_reshaped.Pns_virtual_s  = reshape(values.Pns_virtual_s, [], 1);
  end

  % Virtual power
  if isfield(values, 'Pres_virtual') 
    values_reshaped.Pres_virtual  = reshape(values.Pres_virtual, [], 1);
  end
 
  % GT related variables
  if isfield(values, 'P_GT') 
    for g = 1:size(values.P_GT, 3)
      values_reshaped.P_GT(:,:,g) = reshape(values.P_GT(:,:,g), [], 1); % GT power
      values_reshaped.u_GT(:,:,g) = reshape(values.u_GT(:,:,g), [], 1); % GT status
      values_reshaped.z_GT(:,:,g) = reshape(values.z_GT(:,:,g), [], 1); % GT status
    end
  end

  if isfield(values, 'delta_GT_Pmax') 
    for g = 1:size(values.delta_GT_Pmax, 3)
      values_reshaped.delta_GT_Pmax(:,:,g) = reshape(values.delta_GT_Pmax(:,:,g), [], 1); % GT status
    end
  end

  % DG related variables
  if isfield(values, 'P_DG') 
    for g = 1:size(values.P_DG, 3)
      values_reshaped.P_DG(:,:,g) = reshape(values.P_DG(:,:,g), [], 1); % DG power
      % values_reshaped.delta_DG_Pmax(:,:,g) = reshape(values.delta_DG_Pmax(:,:,g), [], 1); % GT status
      % values_reshaped.u_DG(:,:,g) = reshape(values.u_DG(:,:,g), [], 1); % DG status
      % values_reshaped.z_DG(:,:,g) = reshape(values.z_DG(:,:,g), [], 1); % DG status
    end
  end
  
end