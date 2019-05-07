%   An�lise de Vibra��es - Gerador de gr�ficos com base no tempo.
%
%   Sistema massa-mola-amortecedor de 1 grau de liberdade (gdl)
%
%   Dados de entrada :
%     m: massa.
%     k: constante el�stica da mola.   
%	  c: constante de amortecimento.
%	  xo: deslocamento inicial.
%	  vo: velocidade inicial.
%	  omega: frequencia da excita�ao harmonica.
%	  Fo: amplitude da for�a externa.
%
%   C�lculos: 
%     omega_n:  freq��ncia natural n�o-amortecida
%     zeta:     fator de amortecimento
%	  x: 		grau de liberdade ou deslocamento da massa
%
%   Airton Nabarrete, iniciado em 2005, atualizado em 2017
%   Refer.: Rao - topic 3.4.1 (5th edition)
%   Version 1.10
% **************************************************************************
clear all
clc
% 
% Dados do sistema massa-mola-amortecedor
m=1;        % [kg]
k=1000;     % [N/m]
c=1;       % [Ns/m]
%
% Condi��es iniciais
x_0=0.03;       % [m]
v_0=0;      % [m/s]
%
% For�a externa atuante na massa
F_0=1;       % [N]
omega=30;   % [rad/s]
%
% Par�metros da discretiza��o no tempo
omega_n=(k/m)^(0.5);
if omega>=omega_n
    freqref=omega;
else
    freqref=omega_n;
end
freqref=freqref/(2*pi);
dt=1/(25*freqref);
Fs=round(1/dt);
tmax=100/freqref;
%
%% C�lculos pr�vios e gera��o de resposta do sistema
% Fs=1024;
arg1=tmax;
arg2=Fs;
%
[t,u,udot,uddot] = genHarmonicForcedResp(m,k,c,F_0,omega,x_0,v_0,arg1,arg2);
%
%% Gerador de gr�ficos no tempo
%figure('Name','Time Response','NumberTitle','off'); 
figure(1)
max_axis=max(u)*1.2;
min_axis=min(u)*1.2;
hold on
plot (t,u,'r-');
hold off
axis ([0 tmax min_axis max_axis]);
grid off;
box on;
title (' ');
xlabel ('Time [s]');
ylabel ('Displacement [m]');
