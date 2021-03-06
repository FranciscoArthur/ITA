% gr�fico de iso-torque

% gr�fico para n�vel do mar, atmosfera ISA+10 (i.e.,
% 25�C), de Tra��o x Velocidade verdadeira (KTAS), com Np=100%, com linhas de
% iso-torque: 120%, 100%, 50%, 20%, 13%, 10%, 5%, 0,001%, velocidades de 140
% KTAS a 90 KTAS.

clc
clear all
close all

% Intervalos de interesse
Vt = 140:2.5:280;
Tq = 1800*[32.4 32.4 36.9 40 48.4 55.9 81.8]/100;

% demais condi��es:
Np = 1300*85/100;
H = 10100; % ft (n�vel do mar)

Ta = [10 11 11 11.8 12.6 13.6 14.2]+273.15; % ISA + 10, K

for i=1:numel(Tq)
    for j=1:numel(Vt)
        thrust_N(i,j) = tracao_v2(Vt(j), H, Np, Tq(i), Ta(i))*4.45;
    end
%     plot(Vt,thrust_N(i,:));
end


figure; 
plot(Vt,thrust_N/4.45,'Linewidth',1); grid on; hold on; 
xlabel('Airspeed (KTAS)'); 
ylabel('Thrust (N)');
legend('Tq=32.4%','32.4%','36.9%','40%','45.4%','55.9%','81.8%');

