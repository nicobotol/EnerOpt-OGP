function [REC, load_scenarios, opt_parameters] = optimization_setup(loop_type_1, loop_vec_1, loop_type_2, loop_vec_2, a, b, REC, base_CO2_tax, CAPEX_ref, OPEX_ref, load_scenarios_old, opt_parameters_old, BESS_NL_model, case_sim)

  [REC, load_scenarios, opt_parameters] = sweep_case(loop_type_1, loop_vec_1, loop_type_2, loop_vec_2, a, b, REC, base_CO2_tax, CAPEX_ref, OPEX_ref, load_scenarios_old, opt_parameters_old);
  opt_parameters  = set_opt_tollerance(case_sim, loop_type_2, opt_parameters);
  % scenario        = set_scenario_param(scenario, case_sim, use_generate_dataseries, loop_type_1, loop_vec_1(a)); 
  opt_parameters  = set_max_time(loop_type_1, opt_parameters, case_sim);
  opt_parameters.alpha = loop_vec_1(a);
  opt_parameters.BESS_NL_model = BESS_NL_model; 

end