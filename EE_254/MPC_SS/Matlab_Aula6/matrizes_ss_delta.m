function [Nx,Nu,Kdelta] = matrizes_ss_delta(A,B,C,N,M,rho)

% [Nx,Nu,Kdelta] = matrizes_ss(A,B,C,N,M,rho)
%
% SISO case (single input - single output)
% Input parameters:
%    - Model matrices: A, B, C 
%    - Prediction horizon: N
%    - Control horizon: M
%    - Control weight ("move suppression parameter"): rho

n = size(A,1);

In = eye(n);
aux = inv([(A - In) B; C 0])*[zeros(n,1);1];
Nx = aux(1:n,:);
Nu = aux(end,:);

col = C*B;
for i = 1:N-1
    col = [col;C*(A^i)*B];
end
aux = toeplitz(col,[C*B zeros(1,N-1)]);

H = aux(:,1:M);

for i = 1:N
    Phiu(i,:) = C*A^i;
end

aux2 = inv(H'*H + rho*eye(M)) * H' * Phiu;
Kdelta = aux2(1,:);