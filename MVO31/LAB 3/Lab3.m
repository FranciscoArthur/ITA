%% Lab 3 de MVO 31 - Voo Horizontal em Curva
% C�digo para solu��o das equa��es do Laborat�rio 3 de MVO-31.
% No fim do c�digo ha algumas linhas de c�digo comentadas que geram a 
% vers�o publicada do c�digo, para facilitar a corre��o.
% Para isso, basta copiar os comandos comentados na Command Window e
% apertar enter.
%                                   Autor: Francisco Arthur Bonfim Azevedo


%% Parametros da Aeronave
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

options = optimoptions('fsolve','Display','none');

%% item 1
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
ylabel('Tra��o [N]')
title('Gr�fico da Tra��o requerida numa dada velocidade');
legend('Tra��o requerida','Velocidade de estol');

%% item 2
% Caso da formula de tra��o minima
VtracMin = sqrt((2*W/(rho*s))*sqrt(k/(Cd0*cos(phi)^2)))
TracMinTeo = 2*W*sqrt(k*Cd0/(cos(phi)^2))

% raio de curva
RtracMin = VtracMin^2/(9.81*tan(phi))

% velocidade angular
OmegaTracMin = VtracMin/RtracMin

% per�odo necess�rio
Period = 2*pi/OmegaTracMin

% angulo de ataque
CLTracMin = W/(0.5*rho*VtracMin^2*s*cos(phi));
alfaTracMin = fsolve(@(alfa) CL(alfa) - CLTracMin,0.5,options)

% Deflex�o de profundor
deflexProfundTracMin = fsolve(@(delta) CM(alfaTracMin,delta),0.5,options)

% Posi��o de manete
PosicManeteTracMin = fsolve(@(delta) T(delta,rho)-TracMinTeo,10^5,options)

%% Item 3
poli = [0.5*rho*s*Cd0 0 (-(rho/1.225)^0.6*Tmax_s) 0 2*k*W^2/(rho*s*cos(phi)^2)];
VMaxMin = sort(roots(poli),'descend');
Vmin = VMaxMin(2,1);
Vmax = VMaxMin(1,1)

% raio de curva
Rvmax = Vmax^2/(9.81*tan(phi))

% velocidade angular
OmegaVmax = Vmax/Rvmax

% per�odo necess�rio
PeriodVmax = 2*pi/OmegaVmax

% angulo de ataque
CLVelMax = W/(0.5*rho*Vmax^2*s*cos(phi));
alfaVelMax = fsolve(@(alfa) CL(alfa) - CLVelMax,0.5,options)

% Deflex�o de profundor
deflexProfundVelMax = fsolve(@(delta)CM(alfaVelMax,delta),0.5,options)

%% Item 4

Vstall = sqrt(2*W/(rho*s*CLmax));

if Vmin < Vstall
    Vmin = Vstall;
end

Vmin 

% raio de curva
Rvmin = Vmin^2/(9.81*tan(phi))

% velocidade angular
OmegaVmin = Vmin/Rvmin

% per�odo necess�rio
PeriodVmin = 2*pi/OmegaVmin

% angulo de ataque
CLVelMin = W/(0.5*rho*Vmin^2*s*cos(phi));
alfaVelMin = fsolve(@(alfa) CL(alfa) - CLVelMin,0.5,options)

% Deflex�o de profundor
deflexProfundVelMin = fsolve(@(delta)CM(alfaVelMin,delta),0.5,options)

%% Item 5

TetoVoo = @(rhoTeto) 2*W*sqrt(Cd0*k)/cos(phi) - T(1,rhoTeto);

rhoTeto = fsolve(TetoVoo, 0.1,options);

HtetoAux = 12000:.05:15000;
[~,~,~,rhoTetoAux] = atmosisa(HtetoAux);
rhoTetoAuxPosic = find(abs(rhoTetoAux - rhoTeto) < 10^-4);
Hteto = HtetoAux(rhoTetoAuxPosic(1,1))
clear HtetoAux rhoTetoAux rhoTetoAuxPosic

%% Item 6
HEnvel = linspace(0,0.9999*Hteto,100);
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

HEnvel = [ HEnvel HEnvel(sort(1:1:length(HEnvel),'descend'))];
Vreq = [ (Vreq2)' (Vreq(sort(1:1:length(Vreq),'descend')))' ];
Vstall = sqrt(2*W./(rhoEnvel*s*CLmax));


color = HEnvel;

figure
patch(Vreq,HEnvel,color)
hold on
colorbar
plot(Vstall, HEnvel(1,1:100),'LineWidth',2)
xlabel('Velocidade [m/s]')
ylabel('Altitude da aeronave [m]')
title('Envelope de voo da aeronave')
grid on
hold off

%% Item 7

Vel = linspace(0,VmaxOper,1000);


[~,~,~,rho] = atmosisa(3000);

%limite do cosseno:
cosMax = 1*ones(1,length(Vel));

%limite de velocidade:
Vstall = sqrt(2*W/(rho*s*CLmax))*ones(1,length(Vel));

%limite estrutural: 
cosPhiMaxEstrutural = (1/nmax)*ones(1,length(Vel));

%limite aerodin�mico:
cosPhiMaxAerodinamico = 2*W./(rho.*Vel.^2*s*CLmax).*(2*W./(rho.*Vel.^2*s*CLmax)<1); %a desigualdade limita a valor do cosseno entre 0 e 1

%limite propulsivo:
cosPhiMaxPropulsivo = (2*k*W^2./(2*Vel.^2*s))./(-0.5*rho.*Vel.^2*s*Cd0 + T(1,rho)).*((2*k*W^2./(2*Vel.^2*s))./(-0.5*rho.*Vel.^2*s*Cd0 + T(1,rho))<1); %a desigualdade limita a valor do cosseno entre 0 e 1

m1 = min(find(cosPhiMaxEstrutural>0)); %Remove os zeros que existem repetidos no vetor

m2 = min(find(cosPhiMaxAerodinamico>0));

m3 = min(find(cosPhiMaxPropulsivo>0));

figure
plot(Vel,cosMax,'--r')
hold on
grid on
plot(Vel(1,m1:end),cosPhiMaxEstrutural(1,m1:end))
plot(Vel(1,m2:end),cosPhiMaxAerodinamico(1,m2:end))
plot(Vel(1,m3:end),cosPhiMaxPropulsivo(1,m3:end))
plot(Vstall,linspace(0,1,length(Vstall)),'--k')
text(76.15,0.5,'\leftarrow Ponto de raio minimo')
plot(76.15,0.5,'or')
text(150,0.7,'Regi�o permitida')
hold off
ylim([0 1.1])
xlabel('Velocidade [m/s]')
ylabel('cos(\phi)')
title('Gr�fico da Tra��o requerida numa dada velocidade');
legend('Limite do cosseno','Limite estrutural', 'Limite aerodin�mico', 'Limite propulsivo','Velocidade de estol');


VRaioMin = 76.15;
phiRaioMin = acos(0.5);
Rmin = VRaioMin^2/(9.81*tan(phiRaioMin))

%% Gera a vers�o html do c�digo
%     publish('Lab3.m');
%     web('html/Lab3.html');
