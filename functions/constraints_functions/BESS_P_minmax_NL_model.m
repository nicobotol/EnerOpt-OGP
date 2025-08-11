function prob = BESS_P_minmax_NL_model(prob, Pch, Pdc, x_ESS_NIV)
  prob.Constraints.Pch_max = Pch <= x_ESS_NIV;
  prob.Constraints.Pdc_max = -Pdc >= -x_ESS_NIV;
end