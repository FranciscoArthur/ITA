N = 10;
M = 10;
p = 2;
n = 3;

% xStd = 0;
% yStd = 0;
% thetaStd = 0;

xStd = 0.04;
yStd = 0.04;
thetaStd = 0.05;

T = 1 / 30;
omegaMax = 17;
r = 0.03;
l = 0.06;

times = 0:T:30;

a = 1;
b = 1;
omega1Multiplier = 3;
omega2Multiplier = 2;
m = findLimitLissajous(a,b,omega1Multiplier,omega2Multiplier,T,omegaMax,l,r);
omega1 = omega1Multiplier * m;
omega2 = omega2Multiplier * m;
[qr, ur] = computeReferenceFromLissajous(a, b, omega1, omega2, times);

x0 = qr(1,1) + 0.1;
y0 = qr(1,2) + 0.05;
theta0 = qr(1,3) + 0.05;

%Q = [4, 0 , 0; 0, 10, 0; 0, 0, 1];
Q = [4, 0, 0; 0, 40, 0; 0, 0, 0.1];
% R = eye(2) * 2 * 0.001;
R = eye(2);
[Qbar, Rbar] = computeWeightsMatrices(Q, R, N, M);

S = [1, l/2; -1, -l/2; 1 -l/2; -1 l/2];
b = repmat(omegaMax * r, 4, 1);