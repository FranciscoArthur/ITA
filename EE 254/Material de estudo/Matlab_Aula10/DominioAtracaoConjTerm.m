function [Px,Polf] = DominioAtracaoConjTerm(A,B,K,N,umin,umax,xmin,xmax)

% [Px,Polf] = DominioAtracaoConjTerm(A,B,K,N,umin,umax,xmin,xmax)
%
% Px: Domínio de atração
% Polf: Conjunto terminal

n = size(A,1);
p = size(B,2);

H = zeros(n*N,p*N);
for i = 1:N
   for j = 1:i
       H(1+(i-1)*n:i*n , 1+(j-1)*p:j*p) = (A^(i-j))*B;
   end
end

HN = H(end-n+1:end,:);

Af = A-B*K;
In = eye(n);
Sxu = [In;-In;-K;K];
bxu = [xmax;-xmin;umax;-umin];
max_iter = 100;
[Sf,bf] = conjunto_inv(Af,Sxu,bxu,max_iter);
SfA = Sf*(A^N);

Phiu = A;
for i = 2:N
    Phiu = [Phiu;A^i];
end

IpN = eye(p*N);

Sz = [zeros(n,p*N) In;
      zeros(n,p*N) -In;
      IpN zeros(p*N,n);
     -IpN zeros(p*N,n);
      H Phiu;
     -H -Phiu;
      Sf*HN SfA];

bz = [xmax;
     -xmin;
      repmat(umax,N,1);
     -repmat(umin,N,1);
      repmat(xmax,N,1);
     -repmat(xmin,N,1);
      bf];
   
Pz = Polyhedron('H',[Sz bz]);

Polf = Polyhedron('H',[Sf bf]);

Px = projection(Pz,p*N+1:p*N+n);