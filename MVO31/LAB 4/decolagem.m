
% inicialização das constantes
CL0 = 0.3;
CD0 = 0.03; K = 0.07;
CLmax = 2.5;
Tmax = 55600; %N
nrho = 0.6;
S = 88; %m^2
g = 9.8;
m = 33100; %kg (tanques cheios)
mu_r = 0.02;
% aerodinamica 
CL = CL0;
CD = CD0 + K* CL^2;

% item A: nivel do mar, condições ISA
%         dado o peso
%         determinar comprimento de pista

% solução simbólica
syms V;
rho = 1.225;
T = Tmax * (rho/1.225)^nrho;
L = 0.5*rho*S*V^2* CL;
D = 0.5*rho*S*V^2* CD;

dVdt = (T - D - mu_r*(m*g-L))/m;
Vstall = sqrt(2*m*g/(rho*S*CLmax));
V_decolagem = 1.1*Vstall;
S = int(V/dVdt, V, 0, V_decolagem);
double(S)

% solução numérica (ODE45)

[V X] = ode45(@dinamica_pista, [0 V_decolagem], [0;0;m])
figure();
subplot(3,1,1); plot(V, X(:,1)); hold on;
%plot(V, V_decolagem*ones(size(V)));
ylabel('t (s)'); xlabel('V (m/s)');
subplot(3,1,2);
plot(V, X(:,2));
ylabel('S (m)'); xlabel('V (m/s)');
subplot(3,1,3);
plot(V, X(:,3));
ylabel('m (kg)'); xlabel('V (m/s)');
% item B: nivel do mar
%         dado o comprimento de pista
%         determinar peso em função da temperatura
syms V;
T = Tmax * (rho/1.225)^nrho;
L = 0.5*rho*S*V^2* CL;
D = 0.5*rho*S*V^2* CD;
dVdt = (T - D - mu_r*(m*g-L))/m;
Vstall = sqrt(2*m*g/(rho*S*CLmax));
V_decolagem = 1.1*Vstall;
S = int(V/dVdt, V, 0, V_decolagem);

