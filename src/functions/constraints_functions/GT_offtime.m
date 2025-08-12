function prob = GT_offtime(prob, n_GT, T, W, GT_obj, u_GT)
  % for g = 1:n_GT
  %   Toff =  GT_obj{g}.Toff;
  %   for t = 2:T
  %     k = t+1:1:min(t+Toff-1,T);
  %     minOffTimeCnstr(k,t,1:W,g) = u_GT(t-1,:,g) - u_GT(t,:,g) <= 1 - u_GT(k,:,g);
      
  %   end
  % end
  % prob.Constraints.minOffTimeCnstr = minOffTimeCnstr;
  
  
  for g = 1:n_GT
    Toff =  GT_obj{g}.Toff;
    lhs = u_GT(1:T-1,:,g) - u_GT(2:T,:,g);
    for k = 1:Toff
      idx_start = 2 + k;
      % idx_stop = min(2+k+Toff-1, T);
      idx_stop = T;
      minOffTimeCnstr(1:T-k-1,1:W,k,g) = lhs(1:T-k-1, 1:W) <= 1 - [u_GT(idx_start:idx_stop, :, g)];
    end
  end
  prob.Constraints.minOffTimeCnstr = minOffTimeCnstr;

end