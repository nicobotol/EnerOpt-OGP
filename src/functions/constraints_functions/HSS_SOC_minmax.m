function prob = HSS_SOC_minmax(prob, name, H, x_HSS_IV, HSS)
  prob.Constraints.([name, '_max']) = H  <= x_HSS_IV*HSS.C_storage_u*HSS.SOC_max;
  prob.Constraints.([name, '_min']) = H  >= x_HSS_IV*HSS.C_storage_u*HSS.SOC_min;
end