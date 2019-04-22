W =  1315*9.81;% kg
s = 16.25;% m2
Pmax_s = 216253; %W


P = @(delt,eta,rho) delt*eta*(rho/1.225)^0.6*Pmax_s; %W
Cd0 = 0.026;
k = 0.054;

CD =@(CL) Cd0 + k*CL^2;

CLmax = 2.4;
CL =@(alfa) 0.02 + 0.12*alfa;
CM =@(alfa,delta_elev) 0.12 - 0.08*alfa + 0.075*delta_elev;
nmax = 2;
Vclimb = 5;%m/s




% item 2
[~,~,~,rho] = atmosisa(3000);
V = linspace(1,100);
Vstall = sqrt(2*W/(rho*s*CLmax));
Preq =  W*Vclimb +0.5*rho*V.^3*s*Cd0+2*k*W^2./(rho*V.^2*s);

figure
plot(V,Preq)
hold on
plot(V,Pmax_s*ones(1,100))
plot(Vstall*ones(1,100), linspace(0,max(Preq)))

% item 3

PminGraf = min(Preq)
VpotMinGraf = interp1(Preq,V,PminGraf)
%VpotMinTeo = sqrt(-W*)
%PminTeo = W*Vclimb +0.5*rho*VpotMinTeo.^3*s*Cd0+2*k*W^2./(rho*VpotMinTeo.^2*s)