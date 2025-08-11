function prob = GT_startUP_firstTS(prob, n_GT, z_GT, u_GT)
  % GT startup constraints for the first time step
  for g = 1:n_GT
    strtUPCnstrInit(g) = sum(u_GT(1,2:W,g) - u_GT(T,1:W-1,g)) + u_GT(1,1,g) <= sum(z_GT(1,:,g));
  end
  prob.Constraints.strtUPCnstrInit = strtUPCnstrInit;
end