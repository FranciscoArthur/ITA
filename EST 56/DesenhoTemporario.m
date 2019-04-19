wFor = linspace(0,2.5);
M = [1 0; 0 1];
C = [0 0; 0 0];
K =  [2 -1; -1 2];

Z = @(r,s) -wFor.^2*M(r,s)+1i*wFor*C(r,s)+K(r,s)

X1 = real(Z(2,2)*3./(Z(1,1).*Z(2,2)-Z(1,2).^2))

plot(wFor/(sqrt(1/1)),X1)
hold on

M2 = [1 0; 0 0];
C2 = [0 0; 0 0];
K2 =  [1 0; 0 0];
Z2 = @(r,s) -wFor.^2*M2(r,s)+1i*wFor*C2(r,s)+K2(r,s)
X0 = real(3./Z(1,1))
plot(wFor/(sqrt(1/1)),X0,'--')
grid on
axis([0 2.5 -8 8 ])
plot(linspace(-8,8),0*ones(100,1),'-r')