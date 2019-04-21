m = 1; %kg
c = 1; 
k = 1;

m2 = 1.3;
k2 = 1;

M = [ m 0; 0 m2];
K = [k+k2 -k2; -k2 k2];
C = [c 0; 0 0];
%K = [2 -1; -1 2];
F0 = 3;

% Frequências naturais do sistema
W1 = sqrt(k/m); %frequências naturais
Zeta1 = c/(2*m*W1);
W1d = W1*sqrt(abs(Zeta1^2-1));


n = 201;
X1 = zeros(1,n);
X2 = zeros(1,n);
X0 = zeros(1,n);
wFor = zeros(1,n);
Omega = zeros(1,n);

for i = 1: n
wFor(i) = 3 * (i - 1) / (n-1);
Omega(i) = wFor(i)/W1;
Z = @(r,s) -wFor(i).^2*M(r,s)+1i*wFor(i)*C(r,s)+K(r,s);

X1(i) = (Z(2,2)*F0./(Z(1,1).*Z(2,2)-Z(1,2).^2));
X2(i) = (-Z(1,2)*F0./(Z(1,1).*Z(2,2)-Z(1,2).^2));

X0(i) = sqrt((1+(2*Zeta1*Omega(i))^2)/((1-Omega(i)^2)^2+(2*Zeta1*Omega(i))^2));
end




subplot (211);
plot (wFor/W1d, abs(X1*k/F0),'k');
hold on
plot(wFor/W1d,abs(X0*k/F0),'--r')
plot(1*ones(100,1),linspace(0,max(X1*k/F0)),'b')
hold off
xlabel ('w/w_1');
ylabel ('X_1*K/F_1_0');
grid on;
subplot (212);
plot (wFor/W1d, abs(X2*k/F0),'k');
xlabel ('w/w_1');
ylabel ('X_2*K/F_1_0');
grid on

