%% item B: nivel do mar
%         dado o comprimento de pista
%         determinar peso em função da temperatura
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

syms V;

[Temp,~,P,~] = atmosisa(0); 
massa = linspace(1,5,5);
Temp_vec = linspace(-10,30,5);

for i=1:1:10
    m2 = 35700;
    flag=0;
    while flag==0
        m2 = m2+100
        rho_var = P/(287*(Temp+Temp_vec(i)));
        T = Tmax * (rho_var/1.225)^nrho;
        L = 0.5*rho_var*S*V^2* CL;
        D = 0.5*rho_var*S*V^2* CD;
        dVdt = (T - D - mu_r*(m2*g-L))/m2;
        Vstall_var = sqrt(2*m2*g/(rho_var*S*CLmax));
        V_decolagem_var = 1.1*Vstall_var;
        massa(i) = fsolve (@(m2) 1500-eval(int(V*m2/(T-D-mu_r*(m2*g-L)), V, 0, V_decolagem_var)),1);
        Peso = massa.*g;
        if m2>massa
            flag=1;
        end
    end
end