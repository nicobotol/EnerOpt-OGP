function [REC, load_scenarios, opt_parameters, scenario] = optimization_setup(loop_type_1, loop_vec_1, loop_type_2, loop_vec_2, a, b, REC, load_scenarios, scenario, opt_parameters_old, use_generate_dataseries, case_sim)

  [REC, load_scenarios, opt_parameters] = sweep_case(loop_type_1, loop_vec_1, loop_type_2, loop_vec_2, a, b, REC, load_scenarios, opt_parameters_old);
  opt_parameters  = set_opt_tollerance(case_sim, opt_parameters);
  scenario        = set_scenario_param(scenario, case_sim, use_generate_dataseries, loop_type_1, loop_vec_1(a)); 

end