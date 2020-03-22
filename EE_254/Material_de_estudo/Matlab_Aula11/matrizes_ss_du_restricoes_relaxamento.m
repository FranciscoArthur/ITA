function [Phi,G,Hqp,Aqp,flp,Alp] = matrizes_ss_du_restricoes_relaxamento(A,B,C,N,M,rho,d1,d2);

% [Phi,G,Hqp,Aqp,flp,Alp] = matrizes_ss_du_restricoes_relaxamento(A,B,C,N,M,rho,d);
%
% Caso SISO 
% Parâmetros de entrada:
%    - Matrizes do modelo: A, B, C 
%    - Horizonte de predição: N
%    - Horizonte de controle: M
%    - Peso do controle ("move suppression parameter"): rho
%    - Pesos das variáveis de folga associadas a ymax e ymin: d1, d2

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

zeroM = zeros(M,1);
zeroN = zeros(N,1);
oneN = ones(N,1);
IM = eye(M);

flp = [zeroM;d1;d2];
Alp = [IM zeroM zeroM;
      -IM zeroM zeroM;
       TM zeroM zeroM;
      -TM zeroM zeroM;
       G  -oneN zeroN;
      -G  zeroN -oneN;
      zeroM'  1  0;
      zeroM' -1  0;
      zeroM'  0  1;
      zeroM'  0 -1];