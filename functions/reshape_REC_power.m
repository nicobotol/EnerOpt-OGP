function [REC_obj] = reshape_REC_power(REC_obj, Pload)

  for r = 1:size(REC_obj, 2)
    REC_obj{r}.Power = reshape(REC_obj{r}.Power, size(Pload, 1),  size(Pload, 2));
  end
end