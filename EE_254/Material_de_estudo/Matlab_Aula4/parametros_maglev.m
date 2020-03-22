clear,clc,close all

% Parametros fisicos
mass = 2.12e-2;
g = 9.8;
y0 = -7.47;
gamma = 328;
i0 = 0.514;
r = 0.166;
Kf = 1.2e-4;

% Linearizacao
yp_equilibrio = 0;
up_equilibrio = ( sqrt(mass*g/Kf)*(yp_equilibrio - y0) / gamma - i0 ) / r;
eta = 2*gamma*g/(yp_equilibrio - y0);
beta = sqrt(Kf*g/mass)*(2*r*gamma^2)/(yp_equilibrio - y0);

% Discretizacao
T = 0.005;
[NUMd,DENd] = c2dm(-beta,[1 0 -eta],T,'zoh')
b = NUMd(2:end)
a = DENd(2:end)