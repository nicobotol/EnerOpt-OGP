% This script computes the LCOE of the system considering a variety of generators and energy storage systems.
L = opt_parameters.L; % project lifetime [years]
L_G = L;
r = opt_parameters.r; % annual interest rate

if sum(values_solution.P_DGv,'all') > 0
  n_DG = 1;
else 
  n_DG = 0;
end

if ~exist('n_GT') 
  n_GT = 0;
end

num_GEN = n_DG + n_GT + size(values_solution.x_REC, 1);

EOH       = zeros(L, num_GEN);
PowRated  = zeros(1, num_GEN);
E_G       = zeros(L, num_GEN);
G_CAPEX   = zeros(L, num_GEN);
G_OPEX    = zeros(L, num_GEN);
G_FUEL    = zeros(L, num_GEN);

% GT
for g=1:n_GT

  E_G(:, g)     = build_vector(L_G, sum(values_solution.P_GT(:,:,g), 'all'));
  PowRated(g)   = REC.GT.GT_obj{g}.PowRated;
  CAPEX_tmp     = REC.GT.GT_obj{g}.C_I*values_solution.x_GT(g);
  G_CAPEX(:, g) = [CAPEX_tmp, zeros(1, L_G-1)]'; % installation costs
  OPEX_tmp      = sum(REC.GT.GT_obj{g}.C_OeM*values_solution.P_GT(:,:,g)*values_solution.x_GT(g), 'all');
  G_OPEX(:, g)  = build_vector(L_G, OPEX_tmp); % yearly operational costs
  G_FUEL(:, g)  = build_vector(L_G, sum(values_solution.P_GT(:,:,g)*REC.GT.GT_obj{g}.alpha_g + values_solution.u_GT(:,:,g)*REC.GT.GT_obj{g}.beta_g,'all')*REC.GT.GT_obj{g}.C_F); % cost of the fuel
  EOH(:, g)     = compute_EOH(E_G(:, g), PowRated(g));
end

% DG
for g=n_GT+1:n_GT+n_DG

  E_G(:, g)     = build_vector(L_G, sum(values_solution.P_DGv, 'all'));
  PowRated(g)   = values_solution.P_DGv_max_inst;
  CAPEX_tmp     = REC.DGv.DGv_obj{g}.C_I*values_solution.P_DGv_max_inst;
  G_CAPEX(:, g) = [CAPEX_tmp, zeros(1, L_G-1)]'; % installation costs
  OPEX_tmp      = sum(REC.DG.DG_obj{g}.C_OeM*values_vector.P_DGv);
  G_OPEX(:, g)  = build_vector(L_G, OPEX_tmp); % yearly operational costs
  G_FUEL(:, g)  = build_vector(L_G, values_solution.P_DGv(g)*REC.DGv.DGv_obj{g}.C_F*REC.DGv.DGv_obj{g}.alpha_g); % cost of the fuel
  EOH(:, g)     = compute_EOH(E_G(:, g), PowRated(g));
end

% REC
idx = 0;
for g=n_DG+n_GT+1:num_GEN 
  idx = idx + 1;
  if values_solution.x_REC(idx) > 0
    PowRated(g)   = values_solution.x_REC(idx)*REC_obj{idx}.PowRated;
    E_G(:, g)     = build_vector(L_G, sum(values_vector.P_res_vec(:, idx)));
    EOH(:, g)     = compute_EOH(E_G(:, g), PowRated(g)); % equivalent operating hours of the PV system
    G_CAPEX(:, g) = PowRated(g)*[REC_obj{idx}.C_CAPEX, zeros(1, L_G-1)]';
    G_OPEX(:, g)  = PowRated(g)*build_vector(L_G, REC_obj{idx}.C_OPEX);
    G_FUEL(:, g)  = PowRated(g)*build_vector(L_G, 0); % RECs don't consume fuel
  end
end

% ESS
E_DC    = zeros(L, num_ESS);
E_CH    = zeros(L, num_ESS);
E_CAPEX = zeros(L, num_ESS);
E_OPEX  = zeros(L, num_ESS);

for g=1:num_ESS 
  E_DC(:, g)    = build_vector(L_G, sum(values_vector.Pdc, 'all'));
  E_CH(:, g)    = build_vector(L_G, sum(values_vector.Pch, 'all'));
  CAPEX         = BAT.C_CAPEX_E*BAT.C_batt*values_solution.x_ESS_IV + BAT.C_CAPEX_P*values_solution.x_ESS_NIV;
  OPEX          = BAT.C_OPEX_E*BAT.C_batt*values_solution.x_ESS_IV + BAT.C_OPEX_P*values_solution.x_ESS_NIV;
  E_CAPEX(:, g) = [CAPEX, zeros(1, L_G-1)]'; % installation costs
  E_OPEX(:, g)  = build_vector(L_G, OPEX); % yearly operational costs
end


% denominator of the participation factor of the generator
f_G_d = compute_denominator(EOH, E_DC, E_CH, L, r, PowRated);

% GENERATORS
LCOE_first  = zeros(num_GEN, 1);
f_G         = zeros(num_GEN, 1);
for g=1:n_DG
  if sum(values_solution.P_DGv,'all') > 0
    f_G(g)        = compute_fG(PowRated(g), EOH(:,g), r, L_G, f_G_d); % participation factor of the generator
    LCOE_DG_tmp   = compute_LCOE(G_CAPEX(:, g), G_OPEX(:, g), G_FUEL(:, g), E_G(:, g), L, r);
    LCOE_first(g) = compute_LCOE_first(LCOE_DG_tmp, L, L_G);
  else 
    f_G(g)        = 0;
    LCOE_first(g) = 0;
  end
end

for g=n_DG+1:num_GEN
  if PowRated(g) > 0
    f_G(g)        = compute_fG(PowRated(g), EOH(:,g), r, L_G, f_G_d); % participation factor of the generator
    LCOE_tmp      = compute_LCOE(G_CAPEX(:, g), G_OPEX(:, g), G_FUEL(:, g), E_G(:, g), L, r);
    LCOE_first(g) = compute_LCOE_first(LCOE_tmp, L, L_G);
  else 
    f_G(g)        = 0;
    LCOE_first(g) = 0;
  end 
end

% ESS
LCOS_first  = zeros(num_ESS, 1);
f_ESS      = zeros(num_ESS, 1); 
for g=1:num_ESS
  LCOS_tmp      = compute_LCOS(E_CAPEX(:, g), E_OPEX(:, g), E_DC(:, g), L, r); % [$/kWh]
  LCOS_first(g) = compute_LCOS_first(LCOS_tmp, L, L_G);
  f_ESS(g)      = compute_f_ESS(E_DC(:, g), r, L_G, f_G_d);
end

% LCOE for integrating the system
LCOE_sys = 0;

values_solution.LCOE_poly   = compute_LCOE_poly(f_G, LCOE_first, f_ESS, LCOS_first, LCOE_sys);


%   _____                 _   _                 
%  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___ 
%  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                                              
function vec = build_vector(n, value)
  % Considering of having the same same cost for all the years

  if length(value) == 1
    vec = ones(n, 1)*value; % vector of size n with all the values equal to value
  elseif length(value) == n
    vec = value; % vector of size n with all the values equal to value
  else
    error('The length of the vector must be 1 or n')
  end

end


function [EOH] = compute_EOH(E_supplied, PowRated)
  % Compute the equivalent operating hours (or full load hours) of the system that is the number of hours that the generator has to work at full power to produce the same amount of energy as the system
  % 
  % Inputs:
  % E_supplied: totasl energy produced by the system [kWh]
  % PowRated: rated power of the system [kW]
  
  EOH = E_supplied/PowRated;

end

function [LCOE_poly] = compute_LCOE_poly(f_G, LCOE_G_first, f_ESS, LCOS_ESS_first, LCOE_sys)
  % Compute the LCOE of a polygenerator system considering ESS (eq. 3.40)
  %
  % Inputs:
  % f_G: Column vector of the participation factors of the generators
  % LCOE_G_first: Column vector of generators' LCOE [$/kWh]
  % f_ESS: Column vector of the participation factors of the energy storages
  % LCOS_ESS_first: Column vector of energy storages' LCOE [$/kWh]
  % LCOE_sys: LCOE of the system [$/kWh]

  LCOE_poly = f_G'*LCOE_G_first + f_ESS'*LCOS_ESS_first + LCOE_sys;

end

function [f_G] = compute_fG(P_G, EOH, r, L_G, f_G_denominator)
  % Compute the participation factors of the generators (eq. 3.41)
  %
  % Outputs:
  % f_G: Participation factors of one generator
  %
  % Inputs:
  % P_G: Rated power of the generator [kW]
  % EOH: Equivalent operating hours of the generator [h]
  % r: Discount rate
  % L_G: Lifetime of the generator [years]
  % f_G_denominator: Denominator of the participation factor of the generator (common to all the generators)

  if ~size(EOH, 1) == L_G
    error('EOH must be a column vector of size L_G')
  end

  f_G_numerator = 0;
  for i = 1:L_G
    f_G_numerator = f_G_numerator + P_G*EOH(i)/(1 + r)^i;
  end

  f_G = f_G_numerator/f_G_denominator;

end

function [f_ESS] = compute_f_ESS(E_DC, r, L_G, f_G_denominator)
  % Compute the participation factors of the generators (eq. 3.41)
  %
  % Outputs:
  % f_ESS: Participation factors of one storage
  %
  % Inputs:
  % E_DC: vector of discharging energy over one year[kW]
  % EOH: Equivalent operating hours of the generator [h]
  % r: Discount rate
  % L_G: Lifetime of the generator [years]
  % f_G_denominator: Denominator of the participation factor of the generator (common to all the generators)

  if ~size(E_DC, 1) == L_G
    error('E_DC must be a column vector of size L_G')
  end

  f_ESS_numerator = 0;
  for i = 1:L_G
    f_ESS_numerator = f_ESS_numerator + E_DC(i)/(1 + r)^i;
  end

  f_ESS = f_ESS_numerator/f_G_denominator;

end

function f_G_denominator = compute_denominator(EOH, E_DC, E_CH, L, r, P_G)
  % Compute the denominator of the participation factor of the generator
  %
  % Outputs:
  % f_G_denominator: Denominator of the participation factor of the generator
  %
  % Inputs:
  % EOH: Equivalent operating hours of the generator [h]
  % L: Lifetime of the project [years]
  % r: Discount rate
  % P_G: Row vector containing the rated power of the generator [kW]
  % E_DC: Energy discharging the storage systems [kWh]
  % E_CH: Energy charging the storage systems [kWh]
  %
  % EOH, E_DC and E_CH are matrices with a number of columns equal to the number of generators and storage system and a number of rows equal to the project lifetime. 


  if ~size(EOH, 1) == L
    error('EOH must be a matrix')
  end

  if ~size(E_DC, 1) == L
    error('E_DC and E_CH must be matrices')
  end

  if ~size(P_G,1) == 1
    error('P_G must be a row vector')
  end

  f_G_denominator = 0;
  for i = 1:L
    f_G_denominator = f_G_denominator + P_G*EOH(i,:)'/(1 + r)^i + sum(E_DC(i, :) - E_CH(i, :))/(1 + r)^i; 
  end
end

function LCOE = compute_LCOE(CAPEX, OPEX, FUEL, E_supplied, L, r)
  % Compute the levelized cost of electricity (LCOE) of the system (eq. 3.18)
  %
  % Outputs:
  % LCOE: Levelized cost of electricity [$/kWh]
  %
  % Inputs:
  % CAPEX: vector of capital expenditures (each entry refers to 1 year) [$/kWh]
  % OPEX: vector of operational expenditures (each entry refers to 1 year) [$/kWh]
  % FUEL: vector of fuel expenditures (each entry refers to 1 year) [$/kWh]
  % E_supplied: vector of energy supplied by the system (each entry refers to 1 year) [kWh]
  % L: lifetime of the project [years]
  % r: discount rate


  LCOE_tmp = 0;
  den_tmp = 0;
  for i=1:L
    LCOE_tmp = LCOE_tmp + 1/(1 + r)^i*(CAPEX(i) + OPEX(i) + FUEL(i));
    den_tmp = den_tmp + E_supplied(i)/(1 + r)^i;
  end

  LCOE = LCOE_tmp/den_tmp;
  
end

function LCOS = compute_LCOS(CAPEX, OPEX, E_discharge, L, r)
  % Computes the levelized cost of storage (LCOS) of the storage system (Eq. 3.26)

  %
  % Outputs:
  % LCOS:  levelized cost of storage [$/kWh]
  %
  % Inputs:
  % CAPEX: vector of capital expenditures (each entry refers to 1 year) [$/kWh]
  % OPEX: vector of operational expenditures (each entry refers to 1 year) [$/kWh]
  % E_discharge: vector of energy supplied by the system (each entry refers to 1 year) [kWh]
  % L: lifetime of the project [years]
  % r: discount rate


  LCOS_tmp = 0;
  den_tmp = 0;
  for i=1:L
    LCOS_tmp = LCOS_tmp + 1/(1 + r)^i*(CAPEX(i) + OPEX(i));
    den_tmp = den_tmp + E_discharge(i)/(1 + r)^i;
  end

  LCOS = LCOS_tmp/den_tmp;
end


function LCOE_first = compute_LCOE_first(LCOE, L, L_G)
  % This function rescales the LCOEs considering the cost of replacing some items before their end of life (Eq. 3.42)

  if L == L_G
    LCOE_first = LCOE;
  else 
    error('Project and generator lifetime must be the same for using this formulation. Case with them different is not implemented yet.')
  end

end

function LCOS_first = compute_LCOS_first(LCOS, L, L_G)
  % This function rescales the LCOEs considering the cost of replacing some items before their end of life (Eq. 3.42)

  if L == L_G
    LCOS_first = LCOS;
  else 
    error('Project and generator lifetime must be the same for using this formulation. Case with them different is not implemented yet.')
  end

end

function [f_G, LCOE_first] = compute_weighted_LCOE(GEN, EOH, r, L, L_G, f_G_d)
  % This function computes the LCOE of on generator and weights it by its participation factor

  [f_G]        = compute_fG(GEN.PowRated, EOH, r, L_G, f_G_d);
  [LCOE]       = compute_LCOE(GEN.CAPEX, GEN.OPEX, GEN.FUEL, GEN.E_DG, L, r);
  [LCOE_first] = compute_LCOE_first(LCOE, L, L_G);

end