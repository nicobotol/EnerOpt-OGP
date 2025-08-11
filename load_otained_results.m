load('results\opt_Acases_10_12_2024.mat');

values_solution_collect{a,b,1} = values_solution{a,b,1};
values_vector_collect{a,b,1} = values_vector{a,b,1};
values_minvalue_collect{a,b,1} = values_minvalue{a,b,1}; 
CO2_emitted_collect{a,b,1} = CO2_emitted{a,b,1};

load('results\opt_BCcases_10_12_2024.mat');
values_solution_collect{a,b,2} = values_solution{a,b,1};
values_vector_collect{a,b,2} = values_vector{a,b,1};
values_minvalue_collect{a,b,2} = values_minvalue{a,b,1}; 
CO2_emitted_collect{a,b,2} = CO2_emitted{a,b,1};

values_solution_collect{a,b,3} = values_solution{a,b,2};
values_vector_collect{a,b,3} = values_vector{a,b,2};
values_minvalue_collect{a,b,3} = values_minvalue{a,b,2}; 
CO2_emitted_collect{a,b,3} = CO2_emitted{a,b,2};

fig = figure('Color', 'w'); hold on; grid on;
for i=1:3
  plot(i, values_minvalue_collect{a,b,i}, 'x', 'LineWidth', 1.5, 'Color', 'r');
end
title('Total cost')

fig = figure('Color', 'w'); hold on; grid on;
for i=1:3
  yyaxis left
  plot(i, values_solution_collect{a,b,i}.cTx, 'x', 'LineWidth', 1.5, 'Color', 'r');
  
  yyaxis right
  plot(i, values_solution_collect{a,b,i}.qTy, 'o', 'LineWidth', 1.5, 'Color', 'g');
end
yyaxis left
ylabel('cTx')
yyaxis right
ylabel('qTy')
title('cTx')

fig = figure('Color', 'w'); hold on; grid on;
for i=1:3
  plot(sum(values_vector_collect{a,b,i}.P_GT, 3), '-', 'LineWidth', 1.5, 'Color', color(i));
end
title('Total GT outout power')

fig = figure('Color', 'w'); hold on; grid on;
for i=1:3
  subplot(3, 1, i);hold on;grid on;
  plot(sum(values_vector_collect{a,b,i}.P_GT, 3), '-', 'LineWidth', 1.5, 'Color', color(1));
  plot(values_vector_collect{a,b,i}.Pload, '-', 'LineWidth', 1.5, 'Color', color(2));
end
title('GT power and load')
