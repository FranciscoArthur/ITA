m = 1; %kg
c = 1; 
k = 1;

m2 = 1;
k2 = 0.3;

M = [ m 0; 0 m2];
K = [k+k2 -k2; -k2 k2];
C = [c 0; 0 0];
F0 = 3;

% Frequências naturais do sistema
W1 = sqrt(k/m); %frequências naturais



for i = 1: 101
wFor(i) = 3 * (i - 1) / 100;
Z = @(r,s) -wFor(i).^2*M(r,s)+1i*wFor(i)*C(r,s)+K(r,s);

X1(i) = real(Z(2,2)*F0./(Z(1,1).*Z(2,2)-Z(1,2).^2));
X2(i) = real(-Z(1,2)*F0./(Z(1,1).*Z(2,2)-Z(1,2).^2));


end

M2 = [m 0; 0 0];
C2 = [c 0; 0 0];
K2 =  [k 0; 0 0];
Z2 = @(r,s) -wFor.^2*M2(r,s)+1i*wFor*C2(r,s)+K2(r,s);
X0 = real(3./Z2(1,1));


subplot (211);
plot (wFor/W1, abs(X1*k/F0),'k');
hold on
plot(wFor/W1,abs(X0*k/F0),'--r')
plot(1*ones(100,1),linspace(0,max(X1*k/F0)),'b')
hold off
xlabel ('w/w_1');
ylabel ('X_1*K/F_1_0');
grid on;
subplot (212);
plot (wFor/W1, abs(X2*k/F0),'k');
xlabel ('w/w_1');
ylabel ('X_2*K/F_1_0');
grid on

