% t = repmat([1:1:T]', [1,W]);

% M1 = 1e5;
% Sum_ESS_NIV = x_ESS_NIV*t;
% Sum_Pl = cumsum(Pload_PS, 1);
% y_MAX_DC = optimvar('y_MAX_DC', [T,W], 'LowerBound', 0, 'UpperBound', M1);
% delta_MAX_DC = optimvar('delta_MAX_DC', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MAX_DC = optimvar('zeta_MAX_DC', [T,W], 'LowerBound', 0, 'UpperBound', M1);
% prob = MAX_AB(prob, delta_MAX_DC, zeta_MAX_DC, 'MAX_DC', y_MAX_DC, Sum_ESS_NIV, Sum_Pl, M1, 0, epsilon);

% M2 = 1e5;
% Sum_Prec_Pl = cumsum(P_REC_max - Pload, 1);
% y_MIN_CH = optimvar('y_MIN_CH', [T,W], 'LowerBound', -M2, 'UpperBound', M2);
% delta_MIN_CH = optimvar('delta_MIN_CH', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MIN_CH = optimvar('zeta_MIN_CH', [T,W], 'LowerBound', -M2, 'UpperBound', M2);
% prob = MIN_AB(prob, delta_MIN_CH, zeta_MIN_CH, 'MIN_CH', y_MIN_CH, Sum_ESS_NIV, Sum_Prec_Pl, M2, -M2, epsilon);

% M3 = 1e5;
% y_MAX_BAT = optimvar('y_MAX_BAT', [T,W], 'LowerBound', -M3, 'UpperBound', M3);
% delta_MAX_BAT = optimvar('delta_MAX_BAT', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MAX_BAT = optimvar('zeta_MAX_BAT', [T,W], 'LowerBound', -M3, 'UpperBound', M3);
% y_MAX_bat_tmp = E0 + y_MIN_CH - zeta_MAX_DC;
% prob = MAX_AB(prob, delta_MAX_BAT, zeta_MAX_BAT, 'MAX_BAT', y_MAX_BAT, 0, y_MAX_bat_tmp, M3, -M3, epsilon);

% M4 = 1e5;
% y_MIN_BAT = optimvar('y_MIN_BAT', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% delta_MIN_BAT = optimvar('delta_MIN_BAT', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MIN_BAT = optimvar('zeta_MIN_BAT', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob = MIN_AB(prob, delta_MIN_BAT, zeta_MIN_BAT, 'MIN_BAT', y_MIN_BAT, zeta_MAX_BAT, x_ESS_IV*BAT.C_batt*BAT.SOC_max, M4, -M4, epsilon);

% y_MAX_Pv_tmp = cumsum(Pload_PS - P_REC_max, 1) - y_MIN_BAT;
% y_MAX_Pv = optimvar('y_MAX_Pv', [T,W], 'LowerBound', 0, 'UpperBound', M4);
% delta_MAX_Pv = optimvar('delta_MAX_Pv', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MAX_Pv = optimvar('zeta_MAX_Pv', [T,W], 'LowerBound', 0, 'UpperBound', M4);
% prob = MAX_AB(prob, delta_MAX_Pv, zeta_MAX_Pv, 'MAX_Pv', y_MAX_Pv, 0, y_MAX_Pv_tmp, M4, -M4, epsilon);

% zeta_tmp = optimvar('zeta_tmp', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob.Constraints.Pv_cumsum = zeta_tmp == y_MAX_Pv;
% prob.Constraints.Pv_cumsum = cumsum(Pv) <= y_MAX_Pv;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M4 = 1e7;
% Sum_Prec_Pl = cumsum(Pload - P_REC_max, 1);

% y_MAX_Pv = optimvar('y_MAX_Pv', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% delta_MAX_Pv = optimvar('delta_MAX_Pv', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MAX_Pv = optimvar('zeta_MAX_Pv', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob = MAX_AB(prob, 'MAX_Pv', delta_MAX_Pv, zeta_MAX_Pv, y_MAX_Pv, 0, Sum_Prec_Pl, M4, -M4, epsilon);

% % prob.Constraints.Pv_cumsum = cumsum(Pv) <= y_MAX_Pv;


% zeta_tmp = optimvar('zeta_tmp', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob.Constraints.Pv_cumsum = zeta_tmp == y_MAX_Pv;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = repmat([1:1:T]', [1,W]);
% Sum_ESS_NIV = x_ESS_NIV*t;
% Sum_Prec_Pl = cumsum(Pload - P_REC_max, 1);

% M4 = 1e5;
% y_MIN_Pbt = optimvar('y_MIN_Pbt', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% delta_MIN_Pbt = optimvar('delta_MIN_Pbt', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MIN_Pbt = optimvar('zeta_MIN_Pbt', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob = MIN_AB(prob, 'MIN_Pbt', delta_MIN_Pbt, zeta_MIN_Pbt, y_MIN_Pbt, Sum_Prec_Pl, Sum_ESS_NIV, M4, -M4, epsilon);

% y_MIN_Ebt = optimvar('y_MIN_Ebt', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% delta_MIN_Ebt = optimvar('delta_MIN_Ebt', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MIN_Ebt = optimvar('zeta_MIN_Ebt', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob = MIN_AB(prob, 'MIN_Ebt', delta_MIN_Ebt, zeta_MIN_Ebt, y_MIN_Ebt, y_MIN_Pbt + E0 - cumsum(Pdc,1), x_ESS_IV*BAT.C_batt*BAT.SOC_max, M4, -M4, epsilon);

% y_MAX_Pv = optimvar('y_MAX_Pv', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% delta_MAX_Pv = optimvar('delta_MAX_Pv', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MAX_Pv = optimvar('zeta_MAX_Pv', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob = MAX_AB(prob, 'MAX_Pv', delta_MAX_Pv, zeta_MAX_Pv, y_MAX_Pv, 0, Sum_Prec_Pl - y_MIN_Ebt, M4, -M4, epsilon);

% % prob.Constraints.Pv_cumsum = cumsum(Pv) <= y_MAX_Pv;
% zeta_tmp = optimvar('zeta_tmp', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob.Constraints.Pv_cumsum = zeta_tmp == y_MAX_Pv;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = repmat([1:1:T]', [1,W]);
% Sum_ESS_NIV = x_ESS_NIV*t;
% Sum_Prec_Pl = cumsum(Pload - P_REC_max + Pch - Pdc, 1) - E0;

% M4 = 1e5;
% % y_MAX_Pc = optimvar('y_MAX_Pc', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% % delta_MAX_Pc = optimvar('delta_MAX_Pc', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% % zeta_MAX_Pc = optimvar('zeta_MAX_Pc', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% % prob = MIN_AB(prob, 'MAX_Pc', delta_MAX_Pc, zeta_MAX_Pc, y_MAX_Pc, Sum_ESS_NIV, Sum_Prec_Pl, M4, -M4, epsilon);

% y_MAX_Pv = optimvar('y_MAX_Pv', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% delta_MAX_Pv = optimvar('delta_MAX_Pv', [T,W], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
% zeta_MAX_Pv = optimvar('zeta_MAX_Pv', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob = MAX_AB(prob, 'MAX_Pv', delta_MAX_Pv, zeta_MAX_Pv, y_MAX_Pv, 0, Sum_Prec_Pl, M4, -M4, epsilon);

% % prob.Constraints.Pv_cumsum = cumsum(Pv) <= y_MAX_Pv;
% zeta_tmp = optimvar('zeta_tmp', [T,W], 'LowerBound', -M4, 'UpperBound', M4);
% prob.Constraints.Pv_cumsum = zeta_tmp == y_MAX_Pv;