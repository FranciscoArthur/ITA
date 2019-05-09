function [Ta,Sa,Tb,Sb,invTa] = matrizes_arx_du(a,b,N,M)

% [Ta,Sa,Tb,Sb,invTa] = matrizes_arx_du(a,b,N,M)
%
% Dados: Coeficientes a = [a1 a2 ... an], b = [b1 b2 ... bn]
% Horizonte de Previsao N
% Horizonte de Controle M

n = length(a);

if (length(b) ~= n)
    error('a, b devem ter o mesmo número de elementos !')
end

a = [a 0] - [1 a]; % Modificacao para uso do modelo incremental em u. O novo a passa a ter (n + 1) elementos.

% Construcao de Ta e inversa de Ta (invTa)
Ta = toeplitz([1 a zeros(1,N-n-2)],[1 zeros(1,N-1)]);
q = long_division(a,N);
invTa = toeplitz([1 q],[1 zeros(1,N-1)]);

% Construcao de Sa
Sa = [];
for i = 1:(n+1)
    Sa(i,:) = [a(i:n+1) zeros(1,i-1)];
end
Sa = [Sa;zeros(N-n-1,n+1)];

% Construcao de Tb
Tb_temp = toeplitz([b zeros(1,N-n)],[b(1) zeros(1,N-1)]);
Tb = Tb_temp(:,1:M);

% Construcao de Sb
Sb = [];
for i = 1:(n-1)
    Sb(i,:) = [b(i+1:n) zeros(i-1,1)];
end
Sb = [Sb;zeros(N-n+1,n-1)];