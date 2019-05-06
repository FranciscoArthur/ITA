function u = computeMpc(k,input,qr,ur,Qbar,Rbar,S,b,p,n,M,N,T)

qrLength = size(qr, 1);

N = min(qrLength - k + 1, N);
M = min(N, M);

Qbar = Qbar(1:N*n,1:N*n);
Rbar = Rbar(1:M*p,1:M*p);

thetark = input(3);%qr(k,3);
transform = [cos(thetark), sin(thetark), 0; -sin(thetark), cos(thetark), 0; 0, 0, 1];

ek = transform * (qr(k,:)' - input);
ek(3) = atan2(sin(ek(3)), cos(ek(3)));

[Phi,G] = computeSystemMatrices(qr(k:(k+N-1),:), ur(k:(k+N-1),:), M, T);

% % Valores futuros de referência
% ekaux = 0.75*ek;
% er = ekaux;
% for i=2:N
%     ekaux = 0.75*ekaux;
%     er = [er; ekaux];
% end
er = zeros(N*n,1);

% Resposta livre
F = Phi*ek;

% Cálculo do controle ótimo
Gn = Qbar*G;

Hqp = 2*(G'*Qbar*G + Rbar);

fqp = 2*Gn'*(F - er);

[Aqp, bqp] = computeConstraintsMatrices(S, b, ur(k:(k+M-1),:), M);

options = optimset('Algorithm','active-set','Display','off');
u = quadprog(Hqp,fqp,Aqp,bqp,[],[],[],[],[],options);

% u = -(G'*Qbar*G+Rbar)^-1*G'*Qbar*F;

% g = 60;
% ksi = 0.7;
% wn = sqrt(ur(k,2)^2+g*ur(k,1)^2);
% k1 = 2*ksi*wn;
% k3 = 2*ksi*wn;
% k2 = g*ur(k,1);
% 
% k1 = 1;
% k2 = 1;
% k3 = 1;

% u(1) = k1*ek(1);
% u(2) = k2*ek(2) + k3*ek(3);
% F
% F + G*u

u = u(1:p);