function Px = DominioAtracao(A,B,N,umin,umax,xmin,xmax)

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

In = eye(n);
IpN = eye(p*N);

Sz = [zeros(n,p*N) In;
      zeros(n,p*N) -In;
      IpN zeros(p*N,n);
     -IpN zeros(p*N,n);
      H Phiu;
     -H -Phiu];

bz = [xmax;
      -xmin;
      repmat(umax,N,1);
      - repmat(umin,N,1);
      repmat(xmax,N,1);
      - repmat(xmin,N,1);];
   
Aeq = H(end-n+1:end,:);
Szeq = [Aeq A^N];

Pzlinha = Polyhedron('H',[Sz bz],'He',[Szeq zeros(n,1)]);

Px = projection(Pzlinha,p*N+1:p*N+n);