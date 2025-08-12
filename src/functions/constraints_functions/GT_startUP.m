function prob = GT_startUP(prob, n_GT, T, W, z_GT, u_GT)
  % GT startup constraints
  for g = 1:n_GT
    strtUPCnstr(2:T,1:W,g) = u_GT(2:T,:,g) - u_GT(1:T-1,:,g) <= z_GT(2:T,:,g);
  end
  prob.Constraints.strtUPCnstr = strtUPCnstr;
end