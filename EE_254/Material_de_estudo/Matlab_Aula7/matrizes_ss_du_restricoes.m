function [Phi,G,Hqp,Aqp] = matrizes_ss_du_restricoes(A,B,C,N,M,rho);

% [Phi,G,Hqp,Aqp] = matrizes_ss_du_restricoes(A,B,C,N,M,rho);
%
% SISO case (single input - single output)
% Input parameters:
%    - Model matrices: A, B, C 
%    - Prediction horizon: N
%    - Control horizon: M
%    - Control weight ("move suppression parameter"): rho

n = size(A,1);

At = [A B;zeros(1,n) 1];
Bt = [B;1];
Ct = [C 0];

col = Ct*Bt;
for i = 1:N-1
    col = [col;Ct*(At^i)*Bt];
end
aux = toeplitz(col,[Ct*Bt zeros(1,N-1)]);

G = aux(:,1:M);

for i = 1:N
    Phi(i,:) = Ct*At^i;
end

TM = toeplitz(ones(M,1),[1 zeros(1,M-1)]);

Hqp = 2*(G'*G + rho*eye(M));
Aqp = [eye(M);-eye(M);TM;-TM;G;-G];
