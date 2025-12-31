% evaluate the cost function after the solution
function values_solution = evaluate_cost(values_solution, name, expression)
  if isa(expression,'optim.problemdef.OptimizationExpression')
    values_solution.(name) = evaluate(expression, values_solution);
  else
    values_solution.(name) = 0;
  end
end