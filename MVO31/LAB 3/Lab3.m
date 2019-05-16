W =  33100*9.81;% kg
s = 88;% m2
Tmax_s = 55600; %N


T = @(delt,rho) delt*(rho./1.225).^0.6*Tmax_s; %W
Cd0 = 0.015;
k = 0.05;

CD =@(CL) Cd0 + k*CL^2;

CLmax = 2.8;
CL =@(alfa) 0.02 + 0.12*alfa;
CM =@(alfa,delta_profund) 0.24 - 0.18*alfa + 0.28*delta_profund;
nmax = 2;

VmaxOper = 247;% m/s
% 
% Vclimb = 5;%m/s
% eta = 0.8;



%% item 2
phi = deg2rad(30);
[~,~,~,rho] = atmosisa(3000);
Vel = linspace(40,VmaxOper,1000);
Vstall = sqrt(2*W/(rho*s*CLmax));
Treq =  0.5*rho*Vel.^2*s*Cd0+2*k*W^2./(rho*Vel.^2*s*cos(phi)^2);

figure
plot(Vel,Treq)
hold on
grid on
plot(Vstall*ones(1,1000), linspace(0,max(Treq),1000),'--k')
hold off
xlabel('Velocidade [m/s]')
ylabel('Tração [N]')
title('Gráfico da Tração requerida numa dada velocidade');
legend('Tração requerida','Velocidade de estol');

%% item 3
% Caso da formula de tração minima
VtracMin = sqrt((2*W/(rho*s))*sqrt(k/(Cd0*cos(phi)^2)))
TracMinTeo = 2*W*sqrt(k*Cd0/(cos(phi)^2))

% raio de curva
RtracMin = VtracMin^2/(9.81*tan(phi))

% velocidade angular
OmegaTracMin = VtracMin/RtracMin

% período necessário
Period = 2*pi/OmegaTracMin

% angulo de ataque
CLTracMin = W/(0.5*rho*VtracMin^2*s);
alfaTracMin = fsolve(@(alfa) CL(alfa) - CLTracMin,0.5)

% Deflexão de profundor
deflexProfundTracMin = fsolve(@(delta)CM(alfaTracMin,delta),0.5)

% Posição de manete
PosicManeteTracMin = fsolve(@(delta) T(delta,rho)-TracMinTeo,10^5)

%% Item 4
poli = [0.5*rho*s*Cd0 0 (-(rho/1.225)^0.6*Tmax_s) 0 2*k*W^2/(rho*s*cos(phi)^2)];
VMaxMin = sort(roots(poli),'descend');
Vmin = VMaxMin(2,1);
Vmax = VMaxMin(1,1)

% raio de curva
Rvmax = Vmax^2/(9.81*tan(phi))

% velocidade angular
OmegaVmax = Vmax/Rvmax

% período necessário
PeriodVmax = 2*pi/OmegaVmax

% angulo de ataque
CLVelMax = W/(0.5*rho*Vmax^2*s);
alfaVelMax = fsolve(@(alfa) CL(alfa) - CLVelMax,0.5)

% Deflexão de profundor
deflexProfundVelMax = fsolve(@(delta)CM(alfaVelMax,delta),0.5)

%% Item 5

Vstall = sqrt(2*W/(rho*s*CLmax));

if Vmin < Vstall
    Vmin = Vstall;
end

Vmin 

% raio de curva
Rvmin = Vmin^2/(9.81*tan(phi))

% velocidade angular
OmegaVmin = Vmin/Rvmin

% período necessário
PeriodVmin = 2*pi/OmegaVmin

% angulo de ataque
CLVelMin = W/(0.5*rho*Vmin^2*s);
alfaVelMin = fsolve(@(alfa) CL(alfa) - CLVelMin,0.5)

% Deflexão de profundor
deflexProfundVelMin = fsolve(@(delta)CM(alfaVelMin,delta),0.5)

%% Item 8

TetoVoo = @(rhoTeto) 2*W*sqrt(Cd0*k)/cos(phi) - T(1,rhoTeto)

rhoTeto = fsolve(TetoVoo, 0.1);

HtetoAux = 0:5:20000;
[~,~,~,rhoTetoAux] = atmosisa(HtetoAux);
rhoTetoAuxPosic = find(abs(rhoTetoAux - rhoTeto) < 10^-4);
Hteto = HtetoAux(rhoTetoAuxPosic(1,1))
clear HtetoAux rhoTetoAux rhoTetoAuxPosic

%% Item 9
HEnvel = linspace(0,Hteto,100);
[~,~,~,rhoEnvel] = atmosisa(HEnvel);
rhoEnvel = rhoEnvel';


PoliVreq = [0.5*rhoEnvel*s*Cd0, zeros(length(rhoEnvel),1),  (- T(1,rhoEnvel)), zeros(length(rhoEnvel),1), 2*k*W^2./(rhoEnvel*s*cos(phi)^2)];

Vreq = zeros(length(rhoEnvel),1);
Vreq2 = zeros(length(rhoEnvel),1);

for i = 1:length(rhoEnvel)
VreqAux = sort(roots(PoliVreq(i,:)),'descend');
Vreq(i) = VreqAux(1,1);
Vreq2(i) = VreqAux(2,1);
end

HEnvel = [HEnvel HEnvel];
Vreq = [Vreq' sort(Vreq2','ascend')];
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

%% Item 7