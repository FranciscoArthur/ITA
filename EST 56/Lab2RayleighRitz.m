% Parametros
E = 1;
A = 1;
rho = 1;
L = 1;

m = [1 1];
x_m = [0.5 1];

if length(m) ~= length(x_m)
    error('A quantidade de pontos de massa � diferente da quantidade de posi��es, checar os vetores m e x_m');
end

x_compr = linspace(0,L);
% Fun��o phi
phi = @(x) [sin(x) cos(x) sinh(x) cosh(x) sin(2*x) cos(2*x) sinh(2*x) cosh(2*x)];

n = length(phi(1));

% Inicializa matrizes de massa e rigidez
K = zeros(n,n);
M = zeros(n,n);

syms xx;
phi_xx = phi(xx);

% phi_deriv = eval(['@(x)' char(diff(phi(xx)))]);
% Aloca os valores das matrizes de massa e rigidez
for i = 1:1:n
    for j =1:1:n
        massa = 0;
        
        phi_i = phi_xx(i);
        phi_j = phi_xx(j);
        phi_i_deriv = eval(['@(x)' char(diff(phi_xx(i)))]);
        phi_j_deriv = eval(['@(x)' char(diff(phi_xx(j)))]);
        
        k_ij_deriv =@(x) E*A*phi_i_deriv(x)*phi_j_deriv(x);
        K(i,j) = int(k_ij_deriv(xx),0,L);
        
        for p = 1:1:length(m)
            massa = massa + m(p)*subs(phi_i,x_m(p))*subs(phi_j,x_m(p));          
        end
        
        M(i,j) = eval(int(rho*xx*A*phi_i*phi_j,0,L)) + subs(massa);
        
    end
end

[autovet,lambda] = eig(M\K);
Wn = sqrt(diag(lambda));

x = linspace(0,L)';

U1 = @(x) phi(x)*autovet(:,1);
U2 = @(x) phi(x)*autovet(:,2);
U3 = @(x) phi(x)*autovet(:,3);
U4 = @(x) phi(x)*autovet(:,4);

Y1 = @(x,t) U1(x)*cos(Wn(1)*t);
Y2 = @(x,t) U2(x)*cos(Wn(2)*t);
Y3 = @(x,t) U3(x)*cos(Wn(3)*t);
Y4 = @(x,t) U4(x)*cos(Wn(4)*t);