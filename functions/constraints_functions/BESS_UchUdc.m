function prob = BESS_UchUdc(prob, Uch, Udc)
% This constraint avoids simultaneous charge and discharge of the BESS

prob.Constraints.UchUdc = Uch + Udc <= 1;

end