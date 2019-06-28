function [dXdV] = dinamica_pista(V, X)
    %UNTITLED2 Summary of this function goes here
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

    
    t = X(1); %tempo
    x = X(2); %posicao
    m = X(3); % massa
    
    rho = 1.225;
    T = Tmax * (rho/1.225)^nrho;
    L = 0.5*rho*S*V^2* CL;
    D = 0.5*rho*S*V^2* CD;

    Vdot = (T-D-mu_r*(m*g - L))/m;
    xdot = V;
    mdot = -T*0.7/3600/g; %consumo de combustivel

    dXdV = [1; xdot; mdot]/Vdot;
end

