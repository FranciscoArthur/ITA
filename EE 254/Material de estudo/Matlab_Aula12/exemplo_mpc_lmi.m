clear,clc,close all

% Integrador duplo
Ac = [0 1;0 0];
Bc = [0;1];
C = [0 1]; % Velocidade sujeita a restrições
D = 0;

T = 1;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');