m = 2; %kg
c = 1; 
k = 2;

m2 = 3;
k2 = 5;

M = [ m 0; 0 m2];
K = [k+k2 -k2; -k2 k2];
C = [c 0; 0 0];

F0 = 3;

% Problema de autovalor
[autovec,autoval] = eig(M\K);

% Frequências naturais do sistema
W = sort(diag(sqrt(autoval))); %frequências naturais

wFor = linspace(0,2.5);


Z = @(r,s) -wFor.^2*M(r,s)+1i*wFor*C(r,s)+K(r,s)

X1 = real(Z(2,2)*F0./(Z(1,1).*Z(2,2)-Z(1,2).^2))

plot(wFor/W(1),abs(X1.*k./F0))
hold on

% M2 = [1 0; 0 0];
% C2 = [0 0; 0 0];
% K2 =  [1 0; 0 0];
% Z2 = @(r,s) -wFor.^2*M2(r,s)+1i*wFor*C2(r,s)+K2(r,s)
% X0 = real(3./Z(1,1))
% plot(wFor/(sqrt(1/1)),X0,'--')
% grid on
% axis([0 2.5 -8 8 ])
% plot(linspace(-8,8),0*ones(100,1),'-r')