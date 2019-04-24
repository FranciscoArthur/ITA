W =  1315*9.81;% kg
s = 16.25;% m2
Pmax_s = 216253; %W


P = @(delt,eta,rho) delt*eta*(rho./1.225).^0.6*Pmax_s; %W
Cd0 = 0.026;
k = 0.054;

CD =@(CL) Cd0 + k*CL^2;

CLmax = 2.4;
CL =@(alfa) 0.02 + 0.12*alfa;
CM =@(alfa,delta_profund) 0.12 - 0.08*alfa + 0.075*delta_profund;
nmax = 2;
Vclimb = 5;%m/s
eta = 0.8;



%% item 2
[~,~,~,rho] = atmosisa(3000);
Vel = linspace(1,100,1000);
Vstall = sqrt(2*W/(rho*s*CLmax));
Preq =  W*Vclimb +0.5*rho*Vel.^3*s*Cd0+2*k*W^2./(rho*Vel*s);

figure
plot(Vel,Preq)
hold on
grid on
plot(Vel,Pmax_s*ones(1,1000))
plot(Vstall*ones(1,1000), linspace(0,max(Preq),1000))
hold off

%% item 3
% Caso do grafico
PminGraf = min(Preq)
VpotMinGraf = interp1(Preq,Vel,PminGraf)

% Caso da formula de potencia minima
VpotMinTeo = sqrt((2*W/(rho*s))*sqrt(k/(3*Cd0)))
PminTeo = W*Vclimb +0.5*rho*VpotMinTeo.^3*s*Cd0+2*k*W^2./(rho*VpotMinTeo*s)

% Erro relativo
ErroVpotMin = abs(VpotMinTeo - VpotMinGraf)/VpotMinGraf*100
ErroPmin = abs(PminGraf-PminTeo)/PminGraf*100

% angulo de ataque
CLPotMin = W/(0.5*rho*VpotMinTeo^2*s);
alfaPotMin = fsolve(@(alfa) CL(alfa) - CLPotMin,0.5)

% Deflexão de profundor
deflexProfundPotMin = fsolve(@(delta)CM(alfaPotMin,delta),0.5)

% Posição de manete
PosicManetePotMin = fsolve(@(delta) P(delta,eta,rho)-PminTeo,10^5)

%% Item 4
poli = [0.5*rho*s*Cd0 0 0 (W*Vclimb-eta*(rho/1.225)^0.6*Pmax_s) 2*k*W^2/(rho*s)];
VMaxMin = sort(roots(poli));
Vmin = VMaxMin(1,1)
Vmax = VMaxMin(2,1)

% angulo de ataque
CLVelMax = W/(0.5*rho*Vmax^2*s);
alfaVelMax = fsolve(@(alfa) CL(alfa) - CLVelMax,0.5)

% Deflexão de profundor
deflexProfundVelMax = fsolve(@(delta)CM(alfaVelMax,delta),0.5)

%% Item 5

% angulo de ataque
CLVelMin = W/(0.5*rho*Vmin^2*s);
alfaVelMin = fsolve(@(alfa) CL(alfa) - CLVelMin,0.5)

% Deflexão de profundor
deflexProfundVelMin = fsolve(@(delta)CM(alfaVelMin,delta),0.5)

%% Item 6
% Variando a altitude
HVarAlt = 0:5000:20000;
[~,~,~,rhoVarAlt] = atmosisa(HVarAlt);
rhoVarAlt = rhoVarAlt';
Vel = linspace(1,50,1000);
PreqVarAlt =  W*Vclimb +0.5*rhoVarAlt*Vel.^3*s*Cd0+2*k*W^2./(rhoVarAlt*Vel*s);

figure
plot(Vel,PreqVarAlt)
grid on
legend('Altitude 0 m', 'Altitude 5000 m', 'Altitude 10000 m', 'Altitude 15000 m', 'Altitude 20000 m');

% Variando a Vclimb
HVarRazSub = 3000;
[~,~,~,rhoVarRazSub] = atmosisa(HVarRazSub);
Vel = linspace(1,50,1000);
VclimbVarRazSub = (0:50:200)';
PreqVarRazSub =  W*VclimbVarRazSub +0.5*rhoVarRazSub*Vel.^3*s*Cd0+2*k*W^2./(rhoVarRazSub*Vel*s);

figure
plot(Vel,PreqVarRazSub)
grid on
legend('Razão de subida 0 m/s', 'Razão de subida 50 m/s', 'Razão de subida 100 m/s', 'Razão de subida 150 m/s', 'Razão de subida 200 m/s');

%% Item 7

[~,~,~,rho] = atmosisa(3000);
VVelClimbMax = sqrt((2*W/(rho*s))*sqrt(k/(3*Cd0)))
VclimbMax = P(1,eta,rho)/W - (4/3)*sqrt(2*W/(rho*s)*sqrt(3*k^3*Cd0))

% Angulo de ataque
CLVclimbMax = W/(0.5*rho*VVelClimbMax^2*s)
alfaVclimbMax = fsolve(@(alfa) CL(alfa) - CLVclimbMax,0.5)

% Deflexão de profundor
deflexProfundVclimbMax = fsolve(@(delta)CM(alfaVclimbMax,delta),0.5)

%% Item 8
VclimbTeto = 5;

TetoVoo = @(rhoTeto) W*VclimbTeto + 2*W*sqrt(k*Cd0) - P(1,eta,rhoTeto); % corrigir

rhoTeto = fsolve(TetoVoo, 0.8);

HtetoAux = 0:5:20000;
[~,~,~,rhoTetoAux] = atmosisa(HtetoAux);
rhoTetoAuxPosic = find(abs(rhoTetoAux - rhoTeto) < 10^-4);
Hteto = HtetoAux(rhoTetoAuxPosic(1,1))
clear HtetoAux rhoTetoAux rhoTetoAuxPosic

%% Item 9
HEnvel = linspace(0,80000,10000);
Vclimb = 5;
[~,~,~,rhoEnvel] = atmosisa(HEnvel);

PoliVreq = [0.5*rhoEnvel*s*Cd0 0 0 (W*Vclimb - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];

Vreq = sort(roots(PoliVreq));
Vreq = Vreq(1,1)
