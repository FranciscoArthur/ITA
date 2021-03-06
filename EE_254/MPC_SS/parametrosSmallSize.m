clear,clc,close all

% Parametros fisicos
alpha = deg2rad([45; 135; 225; 315]); % ITAndroids
beta = [0; 0; 0; 0];
ResistMot = 1;
m = 0.9;
r = 51.5*10^-3;
l = 84*10^-3;
ycm = 0;
xcm = 0;
InerciaCM = 0.0044;
redu = 3;
eta = 0.9;
InerciaMotor = 0.0300;
InerciaRoda = 2.1602e-05;
ConstanteTorqueMotor = 1;
CoefAtritViscMotor = 1;
CoefAtritViscRoda = 1;

M_2 = [-sin(alpha(1,1)+beta(1,1)), cos(alpha(1,1)+beta(1,1)), l*cos(beta(1,1));...
     -sin(alpha(2,1)+beta(2,1)), cos(alpha(2,1)+beta(2,1)), l*cos(beta(2,1));...
     -sin(alpha(3,1)+beta(3,1)), cos(alpha(3,1)+beta(3,1)), l*cos(beta(3,1));...
     -sin(alpha(4,1)+beta(4,1)), cos(alpha(4,1)+beta(4,1)), l*cos(beta(4,1))];

Jeq = (redu^2*eta*InerciaMotor+InerciaRoda)*eye(4);
Hj = RobotDynamicMatrixH(Jeq,m,r,l,ycm,xcm,InerciaCM);

Cv = (redu^2*eta*CoefAtritViscMotor+CoefAtritViscRoda+redu*eta*ConstanteTorqueMotor^2/ResistMot)*eye(4);

% Discretizacao
T = 0.005;

