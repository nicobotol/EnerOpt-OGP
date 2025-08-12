function prob = BESS_P_minmax(prob, Pbt, x_ESS_NIV)
  prob.Constraints.Pch_max = Pbt <= x_ESS_NIV;
  prob.Constraints.Pdc_max = Pbt >= -x_ESS_NIV;
end