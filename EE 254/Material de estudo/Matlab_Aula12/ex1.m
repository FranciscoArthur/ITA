clear,clc,close all

% A = [0 1;-2 -3] % Stable
A = [0 1;2 -1] % Unstable
disp('Autovalores de A:')
eig(A)

setlmis([])
P = lmivar(1,[2 1]);

% 1st LMI
LyapEq = newlmi;
lmiterm([LyapEq 1 1 P],1,A,'s')

% 2nd LMI
Ppos = newlmi;
lmiterm([-Ppos 1 1 P],1,1)

LMIsys = getlmis;

[tmin,xfeas] = feasp(LMIsys);

disp('Mínimo valor de t obtido:')
tmin

% The LMI system is feasible iff. TMIN <= 0

Psol = dec2mat(LMIsys,xfeas,P);
disp('Autovalores de P:')
eig(Psol)
disp('Autovalores de A´P + PA')
eig(A'*Psol + Psol*A)

