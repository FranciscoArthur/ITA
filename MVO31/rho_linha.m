function [ rho ] = rho_linha( h )

T0 = 288;
rho0 = 1.225;
Tlinha = -6.5*10^-3;
g = 9.80665;
R = 287;

rho =  rho0*(1+Tlinha/T0*h)^(-(1/Tlinha)*(g/R+Tlinha));

end

