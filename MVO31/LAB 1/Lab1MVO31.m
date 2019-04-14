%%Parte 1
AltPres = [0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11000 12000 13000 ...
            14000 15000]*0.305; %m

[~,Tpres,Pres] = atmosferaISA(AltPres);

g = 9.80665;
rhoSolo = 1.225; %Kg/m³
Tsolo = 288.15; %K
Tlinha = -6.5*10^-3; %K/m
R = 287;%J/kgK

Temp = linspace(273-20,273+40,100);

rho = zeros(length(Pres),length(Temp));
AltDens = zeros(length(Pres),length(Temp));
for i = 1:length(Pres)
    rho(i,:) = (Pres(1,i)*((R*Temp).^-1));

     AltDens(i,:) = ((rho(i,:)/rhoSolo).^(-1/((1/Tlinha)*(g/R + Tlinha))) - 1)*Tsolo/Tlinha;
end

figure(1)
plot(Temp-273.15,AltDens,'b')
ylabel('Altitude-densidade (m)')
xlabel('Temperatura (°C)')
hold all
grid on
plot(Tpres-273.15, AltPres,'r')
axis([-20 40 0 3050])
%% Parte 2

% características do planador
%Constantes
mVazia = 200; %kg
mPiloto = 100; %kg
mCopiloto = 90; %kg

m = mVazia+mPiloto+mCopiloto;

Cd0 = 0.015;
k = 0.025;
S = 16; %m²



%modelo aerodinamico

% Item A

Cl = sqrt(Cd0/k);
%%%%

Cd = Cd0 + k*Cl^2; %polar de arrasto simetrica



%condição inicial

H0 = 2000; %m
x0 = 0; %m
[rho0,T0,~] = atmosferaISA(H0);
DT = 20; %K
ti = 0;
tf = 2210; %tempo em segundos (final)

%rho0 = rhoSolo*(1+(Tlinha/(Tsolo+DT))*H0)^((-1/Tlinha)*(g/R+Tlinha));

%item A

V0 = sqrt(2*m*g/(rho0*S))*(Cl^2+Cd^2)^(-1/4);
gamma0 = -atan(Cd/Cl);
%%%%%

[vetorT, vetorResult] = ode45(@(t,Input)EqMovimentoPlaneio(t,Input,m,S,Cl,Cd,g),[ti tf],[V0;gamma0;H0;x0]);

Vres = vetorResult(:,1);
gammares = vetorResult(:,2);
Hres = vetorResult(:,3);
xres = vetorResult(:,4);

Autonomia = interp1(Hres,vetorT,0)
Alcance = interp1(Hres,xres,0)


figure(2)
plot(vetorT, Vres)
grid on
xlabel('Tempo (s)')
ylabel('V (m)')
title('Velocidade resultante')


figure(3)
plot(vetorT, gammares)
grid on
xlabel('Tempo (s)')
ylabel('gamma (m)')
title('Gamma')


figure(4)
plot(vetorT, Hres,Autonomia,0,'o')
grid on
xlabel('Tempo (s)')
ylabel('H (m)')
title('Altura vertical')


figure(5)
plot(vetorT, xres,Autonomia,Alcance,'o')
grid on
xlabel('Tempo (s)')
ylabel('X (m)')
title('Distancia horizontal')


figure(6)
plot(Hres, xres)
grid on
xlabel('H (m)')
ylabel('X (m)')
title('Trajetoria horizontal por vertical')


figure(7)
plot(vetorT, (Vres.*cos(gammares)))
grid on
xlabel('Tempo (s)')
ylabel('Velocidade horizontal (m/s)')
title('Velocidade horizontal')


figure(8)
plot(vetorT, Vres.*sin(gammares))
grid on
xlabel('Tempo (s)')
ylabel('Velocidade vetical (m/s)')
title('Velocidade vetical')

figure(9)
plot(gammares, Vres)
grid on
xlabel('gamma')
ylabel('Velocidade (m/s)')
title('Velocidade por gamma')

figure(9)
plot(xres, Vres)
grid on
xlabel('X (m)')
ylabel('Velocidade (m/s)')
title('Velocidade por Alcance')


figure(2)
print('VresTemp122','-depsc')
figure(3)
print('GammaTempA','-depsc')
figure(4)
print('HresTempA','-depsc')
figure(5)
print('XresTempA','-depsc')
figure(6)
print('HresXresA','-depsc')
figure(7)
print('VresHorizA','-depsc')
figure(8)
print('VresVertA','-depsc')
figure(9)
print('VresXres','-depsc')


function Result = EqMovimentoPlaneio(t,Input,m,S,Cl,Cd,g)

V = Input(1,1);
gamma = Input(2,1);
H = Input(3,1);
x = Input(4,1);

[rho,~,~] = atmosferaISA(H);

rhoSolo = 1.225; %Kg/m³
Tsolo = 288.15; %K
DT=20;
Tlinha = -6.5*10^-3; %K/m
R = 287;%J/kgK
%rho = rhoSolo*(1+(Tlinha/(Tsolo+DT))*H)^((-1/Tlinha)*(g/R+Tlinha));

L =@(rho,V,S,Cl) 0.5*rho*V^2*S*Cl; %N
D =@(rho,V,S,Cd) 0.5*rho*V^2*S*Cd; %N

%equações de movimento
VDot = (-D(rho,V,S,Cd)-m*g*sin(gamma))/m; %aceleração
gammaDot = (L(rho,V,S,Cl)-m*g*cos(gamma))/(m*V); %Velocidade angular
HDot = V*sin(gamma); %Velocidade de subida
xDot = V*cos(gamma); %Velocidade horizontal

Result = [ VDot; gammaDot; HDot; xDot];

end