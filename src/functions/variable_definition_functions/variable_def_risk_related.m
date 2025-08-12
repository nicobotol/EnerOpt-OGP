cvar_s    = optimvar('cvar_s',W,'LowerBound',0);
cvar_zeta = optimvar('cvar_zeta','LowerBound',0);

x0.cvar_s = zeros([W, 1]);
x0.cvar_zeta = 0;