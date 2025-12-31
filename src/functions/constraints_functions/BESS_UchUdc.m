function prob = BESS_UchUdc(prob, name, Uch, Udc)
% This constraint avoids simultaneous charge and discharge of the BESS

prob.Constraints.(name) = Uch + Udc <= 1;

end