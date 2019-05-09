function [KMPC,Phi] = matrizes_ss_du_mimo(A,B,C,N,M,mu,rho)

% [KMPC,Phi] = matrizes_ss_du_mimo(A,B,C,N,M,mu,rho)
%
% Caso MIMO (multiple input - multiple output)
% Parâmetros de entrada:
%    - Matrizes do modelo: A, B, C 
%    - Horizonte de predição: N
%    - Horizonte de controle: M
%    - Vetor de pesos do erro de rastreamento: mu
%    - Vetor de pesos do controle: rho

n = size(A,1);
p = size(B,2);
q = size(C,1);

At = [A B;zeros(p,n) eye(p)];
Bt = [B;eye(p)];
Ct = [C zeros(q,p)];

G = zeros(q*N,p*M);
for i = 1:N
   for j = 1:min(i,M)
       G(1+(i-1)*q:i*q , 1+(j-1)*p:j*p) = Ct*(At^(i-j))*Bt;
   end
end

Phi = Ct*At;
for i = 2:N
    Phi = [Phi;Ct*At^i];
end

Q = diag(mu);
R = diag(rho);
Qbar = Q;
for i = 2:N
    Qbar = blkdiag(Qbar,Q);
end
Rbar = R;
for j = 2:M
    Rbar = blkdiag(Rbar,R);
end

aux = inv(G'*Qbar*G + Rbar) * G' * Qbar;
KMPC = aux(1:p,:);