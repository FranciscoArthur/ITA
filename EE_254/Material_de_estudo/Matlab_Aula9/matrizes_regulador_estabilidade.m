function [Phiu,Hn,Hqp,Aqp,Aeq] = matrizes_regulador_estabilidade(A,B,N,Q,R)

% [Phiv,Gamma,Hn,Hqp,Aqp] = matrizes_regulador_estabilidade(A,B,N,Q,R)
%
% Parâmetros de entrada:
%    - Matrizes do modelo: A, B
%    - Horizonte de predição: N
%    - Matriz de pesos dos estados: Q
%    - Matriz de pesos dos controles: R

n = size(A,1);
p = size(B,2);

H = zeros(n*N,p*N);
for i = 1:N
   for j = 1:i
       H(1+(i-1)*n:i*n , 1+(j-1)*p:j*p) = (A^(i-j))*B;
   end
end

Phiu = A;
for i = 2:N
    Phiu = [Phiu;A^i];
end

Qbar = Q;
for i = 2:N
    Qbar = blkdiag(Qbar,Q);
end
Rbar = R;
for j = 2:N
    Rbar = blkdiag(Rbar,R);
end

Hn = Qbar*H;

Hqp = 2*(H'*Qbar*H + Rbar);

IpN = eye(p*N);

Aqp = [IpN; -IpN; H; -H];

Aeq = H(end-n+1:end,:);
