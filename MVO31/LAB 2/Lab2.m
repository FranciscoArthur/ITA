m =  1315;% kg
s = 16.25;% m2
Pmax_s = 216253; %W


P = @(delt,eta,rho) = delt*eta*(rho/1.225)^0.6*Pmax_s; %W
Cd0 = 0.026;
k = 0.054;

CD =@(CL) Cd0 + k*CL^2;

CLmax = 2.4;
CL =@(alfa) 0.02 + 0.12*alfa;
CM =@(alfa,delta_elev) 0.12 - 0.08alfa + 0.075*delta_elev;
nmax = 2;
 