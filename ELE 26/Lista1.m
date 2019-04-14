%% Algebra de quaternions

%quaternion q = [lambda/rho] = [lambda rhox rhoy rhoz]

%funções: multplicação q1*q2 = quatmultiplu(q1,q2)
%inversao: q1^-1 = quatinv(q1)

%rotação:

r1 = [1 0 0];
theta = pi/2;
n = [0 0 1];
qv1 = [cos(theta/2) n*sin(theta/2)];
rq1 = [0 r1];
qvr = quatmultiply(quatmultiply(quatinv(qv1),rq1),qv1);
rv = qvr(1,2:4)'

%% cossenos diretores pelos angulos

psi = 30*pi/180;
theta = -45*pi/180;
phi = 30*pi/180;

D = [cos(psi)*cos(theta) sin(psi)*cos(theta) -sin(theta);
    cos(psi)*sin(theta)*sin(phi)-sin(psi)*cos(phi) sin(psi)*sin(theta)*sin(phi)+cos(psi)*cos(phi) cos(theta)*sin(phi);
    cos(psi)*sin(theta)*cos(phi)+sin(psi)*sin(phi) sin(psi)*sin(theta)*cos(phi)-cos(psi)*sin(phi) cos(theta)*cos(phi)]


%% cossenos diretores pelas medidas de sensores
lambda = -23*pi/180;
Lambdao = -23*pi/180;

g =1;
OmegE = 1;

gb = [0.1219 -0.0346 0.9919]'*(-g);
wb = [0.7960 -0.5380 0.2773]'*OmegE;

ge = [cos(lambda)*cos(Lambdao) cos(lambda)*sin(Lambdao) sin(lambda)]'*g;
we = [ 0 0 1]'*OmegE;

gNED = [0 0 -1]'*g;
wNED = [cos(lambda) 0 -sin(lambda)]'*OmegE;

VetorBody = [gb wb cross(gb,wb)];
VetorEarth = [ge we cross(ge,we)];
VetorNED = [gNED wNED cross(gNED,wNED)];

% dependendo da transformação de coordenadas, obtem-se D diferente
De2NED = VetorNED*inv(VetorEarth);

DNED2b = VetorBody*inv(VetorNED);

De2b = VetorBody*inv(VetorEarth);

D = DNED2b

theta_arfagem = asin(-D(1,3))*180/pi

phi_guinada = asin(D(1,2)/cos(theta_arfagem*pi/180))*180/pi

psi_rolamento = asin(D(2,3)/cos(theta_arfagem*pi/180))*180/pi

%% quaternion que vem da matriz de cossenos diretores
lambda = sqrt(1+trace(D))/2;
rhoz = (D(1,2)-D(2,1))/(4*lambda);
rhoy = (-D(1,3)+D(3,1))/(4*lambda);
rhox = (D(2,3)-D(3,2))/(4*lambda);

q = [lambda rhox rhoy rhoz]

phi2 = 2*acos(lambda);
phi2Deg=phi2*180/pi
n = [rhox rhoy rhoz]/sin(phi2/2)

%% leitura do acelerometro

%%%%%%%%%%%%%%%%%%%%%%%%%%
% wbI2b é a medida do girômetro
% DNED2b matriz de cossenos diretores de NED para o corpo (body b)
% wNEDI2NED = rhoNED + omegaNED
%%%%%%%%%%%%%%%%%%%%%%%%%%

lambda = 38*pi/180; %rad
h = 18*10^3; %m

VeNED = [450 600 1000]'; %m/s
OmegE = 7.292115*10^-5; %rad/s

Vn = VeNED(1,1); %m/s
Ve = VeNED(2,1); %m/s
Vd = VeNED(3,1); %m/s

R =6378.138*10^3; %m

DNED2b = D; %usar o bloco de codigo que gera D

wbI2b = [0.5056 -0.1380 -0.0638]';
rhoNED = [Ve/(R+h) -Vn/(R+h) -Ve*tan(lambda)/(R+h)]';
OmegaNED = [OmegE*cos(lambda) 0 -OmegE*sin(lambda)]';
wNEDI2NED = rhoNED + OmegaNED;

wbNED2b = wbI2b-DNED2b*wNEDI2NED

%para achar a derivada dos angulos de euler

psi = 30*pi/180;
theta = -45*pi/180;
phi = 30*pi/180;

A = [-sin(theta) 0 1; cos(theta)*sin(phi) cos(phi) 0; cos(theta)*cos(phi) -sin(phi) 0];

AngEuler_dot = inv(A)*wbNED2b;

psi_dot = AngEuler_dot(1,1)*180/pi %em graus/s
theta_dot = AngEuler_dot(2,1)*180/pi %em graus/s
phi_dot = AngEuler_dot(3,1)*180/pi %em graus/s
%% derivada temporal do quaternion qA2B

wBA2B = [0.5248 -0.0024 0.0024]';

qA2B = [0.8364 0.3266 0.4446 0.3266]';

wBA2B_X = [0 -wBA2B(3,1) wBA2B(2,1);wBA2B(3,1) 0 -wBA2B(1,1);-wBA2B(2,1) wBA2B(1,1) 0];


OmegaAng = [0 -wBA2B'; wBA2B -wBA2B_X];

qA2B_dot = 0.5*OmegaAng*qA2B

%% Ordem de grandeza do erro em metros por hora

deriva = 0.005; %°/h
t = 80/60; %horas
R = 6378.138*1000; %m

erro = deriva*pi/180*t*R