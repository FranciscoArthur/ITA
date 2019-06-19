clear,clc,close all

% Integrador duplo
Ac = [0 1;0 0];
Bc = [0;1];
C = [1 0];
D = 0;
T = 1;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');

n = size(A,1);
p = size(B,2);
S = eye(n); Ssqrt = sqrtm(S);  
R = eye(p); Rsqrt = sqrtm(R);  
xk = [1;2];

setlmis([])
g = lmivar(1,[1 0]);
Q = lmivar(1,[n,1]);
Y = lmivar(2,[p,n]);

% 1st LMI
lmiterm([-1 1 1 Q],1,1);
lmiterm([-1 1 2 0],xk);
lmiterm([-1 2 2 0],1);

% 2nd LMI
lmiterm([-2 1 1 Q],1,1);
lmiterm([-2 1 4 Q],A,1);
lmiterm([-2 1 4 Y],B,1);
lmiterm([-2 2 2 g],1,1);
lmiterm([-2 2 4 Q],Ssqrt,1);
lmiterm([-2 3 3 g],1,1);
lmiterm([-2 3 4 Y],Rsqrt,1);
lmiterm([-2 4 4 Q],1,1);

lmisys = getlmis;

ndecvar = decnbr(lmisys);
c = zeros(ndecvar,1);
c(1) = 1; % Cost = 1*gamma

[copt,xopt] = mincx(lmisys,c);

Ysol = dec2mat(lmisys,xopt,Y);
Qsol = dec2mat(lmisys,xopt,Q);
F = Ysol*inv(Qsol)

Psi = S + F'*R*F;
Amf = A + B*F;

Psi_infty = dlyap(Amf',Psi);
costlmi = xk'*Psi_infty*xk;

% DLQR para comparação
Kdlqr = dlqr(A,B,S,R)

Psi = S + Kdlqr'*R*Kdlqr;
Amf = A - B*Kdlqr;

Psi_infty = dlyap(Amf',Psi);
costdlqr = xk'*Psi_infty*xk;

disp(['Custo LMI : ' num2str(costlmi,8)])
disp(['Custo DLQR: ' num2str(costdlqr,8)])

