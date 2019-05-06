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
plot(Vel,Pmax_s*ones(1,1000),'--r')
plot(Vstall*ones(1,1000), linspace(0,max(Preq),1000),'--k')
hold off
xlabel('Velocidade [m/s]')
ylabel('Potência [W]')
title('Gráfico da potência requerida numa dada velocidade');
legend('Potência requerida','Potência máxima','Velocidade de estol');

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
xlabel('Velocidade [m/s]')
ylabel('Potencia requerida [W]')
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
xlabel('Velocidade [m/s]');
ylabel('Potência requerida [W]');
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

TetoVoo = @(rhoTeto) W*VclimbTeto + (4/3)*sqrt(2*W^3/(rhoTeto*s)*sqrt(3*k^3*Cd0)) - P(1,eta,rhoTeto); % corrigir

rhoTeto = fsolve(TetoVoo, 0.8);

HtetoAux = 0:5:20000;
[~,~,~,rhoTetoAux] = atmosisa(HtetoAux);
rhoTetoAuxPosic = find(abs(rhoTetoAux - rhoTeto) < 10^-4);
Hteto = HtetoAux(rhoTetoAuxPosic(1,1))
clear HtetoAux rhoTetoAux rhoTetoAuxPosic

%% Item 9
HEnvel = linspace(0,Hteto,100);
Vclimb = 5;
[~,~,~,rhoEnvel] = atmosisa(HEnvel);
rhoEnvel = rhoEnvel';

PoliVreq = [0.5*rhoEnvel*s*Cd0 zeros(length(rhoEnvel),1) zeros(length(rhoEnvel),1) (W*Vclimb - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];

Vreq = zeros(length(rhoEnvel),1);
Vreq2 = zeros(length(rhoEnvel),1);

for i = 1:length(rhoEnvel)
VreqAux = sort(roots(PoliVreq(i,:)));
Vreq(i) = VreqAux(1,1);
Vreq2(i) = VreqAux(2,1);
end

HEnvel = [HEnvel HEnvel];
Vreq = [Vreq' sort(Vreq2','descend')];
Vstall = sqrt(2*W./(rhoEnvel*s*CLmax));

figure
area(Vreq,HEnvel)
hold on
plot(Vstall, HEnvel(1,1:100),'LineWidth',2)
xlabel('Velocidade [m/s]')
ylabel('Altitude da aeronave [m]')
title('Envelope de voo da aeronave')
grid on
hold off

%% Item 10

HEnvel1 = linspace(0,Hteto,100);
Vclimb = linspace(1,5,5);
[~,~,~,rhoEnvel] = atmosisa(HEnvel1);
rhoEnvel = rhoEnvel';

PoliVreq1 = [0.5*rhoEnvel*s*Cd0 zeros(length(rhoEnvel),1) zeros(length(rhoEnvel),1) (W*Vclimb(1) - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];

PoliVreq2 = [0.5*rhoEnvel*s*Cd0 zeros(length(rhoEnvel),1) zeros(length(rhoEnvel),1) (W*Vclimb(2) - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];

PoliVreq3 = [0.5*rhoEnvel*s*Cd0 zeros(length(rhoEnvel),1) zeros(length(rhoEnvel),1) (W*Vclimb(3) - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];

PoliVreq4 = [0.5*rhoEnvel*s*Cd0 zeros(length(rhoEnvel),1) zeros(length(rhoEnvel),1) (W*Vclimb(4) - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];

PoliVreq5 = [0.5*rhoEnvel*s*Cd0 zeros(length(rhoEnvel),1) zeros(length(rhoEnvel),1) (W*Vclimb(5) - P(1,eta,rhoEnvel)) 2*k*W^2./(rhoEnvel*s)];



Vreq1 = zeros(length(rhoEnvel),1);
Vreq12 = zeros(length(rhoEnvel),1);
Vreq2 = zeros(length(rhoEnvel),1);
Vreq22 = zeros(length(rhoEnvel),1);
Vreq3 = zeros(length(rhoEnvel),1);
Vreq32 = zeros(length(rhoEnvel),1);
Vreq4 = zeros(length(rhoEnvel),1);
Vreq42 = zeros(length(rhoEnvel),1);
Vreq5 = zeros(length(rhoEnvel),1);
Vreq52 = zeros(length(rhoEnvel),1);

for i = 1:length(rhoEnvel)
VreqAux1 = sort(roots(PoliVreq1(i,:)));
Vreq1(i) = VreqAux1(1,1);
Vreq12(i) = VreqAux1(2,1);

VreqAux2 = sort(roots(PoliVreq2(i,:)));
Vreq2(i) = VreqAux2(1,1);
Vreq22(i) = VreqAux2(2,1);

VreqAux3 = sort(roots(PoliVreq3(i,:)));
Vreq3(i) = VreqAux3(1,1);
Vreq32(i) = VreqAux3(2,1);

VreqAux4 = sort(roots(PoliVreq4(i,:)));
Vreq4(i) = VreqAux4(1,1);
Vreq42(i) = VreqAux4(2,1);

VreqAux5 = sort(roots(PoliVreq5(i,:)));
Vreq5(i) = VreqAux5(1,1);
Vreq52(i) = VreqAux5(2,1);
end

HEnvel1 = [HEnvel1 HEnvel1];
Vreq1 = [Vreq1' sort(Vreq12','descend')];

Vreq2 = [Vreq2' sort(Vreq22','descend')];

Vreq3 = [Vreq3' sort(Vreq32','descend')];

Vreq4 = [Vreq4' sort(Vreq42','descend')];

Vreq5 = [Vreq5' sort(Vreq52','descend')];

figure
h1=area(Vreq1,HEnvel1);
h1.FaceColor = [0.8 0.8 0];
hold on
h2=area(Vreq2,HEnvel1);
h2.FaceColor = [0.8 0 0.8];
h3=area(Vreq3,HEnvel1);
h3.FaceColor = [0.8 0 0];
h4=area(Vreq4,HEnvel1);
h4.FaceColor = [0 0 0.8];
h5=area(Vreq5,HEnvel1);
h5.FaceColor = [0 0 0];
plot(Vstall, HEnvel(1,1:100),'LineWidth',2)
grid on
hold off

xlabel('Velocidade [m/s]')
ylabel('Altitude [m]')
legend('Razão de Subida 1 m/s', 'Razão de Subida 2 m/s', 'Razão de Subida 3 m/s', 'Razão de Subida 4 m/s', 'Razão de Subida 5 m/s')
title('Envelope de voo da aeronave para várias razões de subida')

%% Item 11

[~,~,~,rhoDisp] = atmosisa(Hteto/2);
Vel = linspace(1,25);
VclimbDisp = 0;

Treq = W*VclimbDisp./Vel + 0.5*rhoDisp*Vel.^2*s*Cd0 + 2*k*W^2./(rhoDisp*s*Vel.^2);
TDisp = P(1,eta,rhoDisp)./Vel;

figure
plot(Vel,Treq)
hold on
plot(Vel,TDisp)
hold off
grid on
xlabel('Velocidade [m/s]');
ylabel('Tração [N]')
title('Gráfico da velocidade em função da tração')
legend('Tração requerida', 'Tração disponível')