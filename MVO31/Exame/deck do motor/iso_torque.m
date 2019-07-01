% gráfico de iso-torque

% gráfico para nível do mar, atmosfera ISA+10 (i.e.,
% 25ºC), de Tração x Velocidade verdadeira (KTAS), com Np=100%, com linhas de
% iso-torque: 120%, 100%, 50%, 20%, 13%, 10%, 5%, 0,001%, velocidades de 140
% KTAS a 90 KTAS.

clc
clear all
close all

% Intervalos de interesse
Vt = 90:2.5:140;
Tq = 1800*[120 100 20 13 5 0.0001]/100;

% demais condições:
Np = 1300*100/100;
H = 0; % ft (nível do mar)
Ta = 15+10+273.15; % ISA + 10, K

for i=1:numel(Tq)
    for j=1:numel(Vt)
        thrust_N(i,j) = tracao_v2(Vt(j), H, Np, Tq(i), Ta)*4.45;
    end
%     plot(Vt,thrust_N(i,:));
end

figure; 
plot(Vt,thrust_N/4.45,'Linewidth',1); grid on; hold on; 
xlabel('Airspeed (KTAS)'); 
ylabel('Thrust (N)');
legend('Tq=120%','100%','20%','13%','5%','0%');

