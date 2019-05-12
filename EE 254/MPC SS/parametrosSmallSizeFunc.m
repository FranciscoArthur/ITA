function parametrosSmallSizeFunc()
clear,clc,close all

% Parametros fisicos
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
w_equilibrio = [0]';
u_equilibrio = [0]';

% Matrizes do espa�o de estados
Jeq = (redu^2*eta*InerciaMotor+InerciaRoda)*eye(4);
Hj = RobotDynamicMatrixH(Jeq,m,r,l,ycm,xcm,InerciaCM);

Cv = (redu^2*eta*CoefAtritViscMotor+CoefAtritViscRoda+redu*eta*ConstanteTorqueMotor^2/ResistMot)*eye(4);

Ac = -inv(Hj)*Cv;
Ac = diag(diag(Ac));
Ac = Ac(1,1);
Bc = ConstanteTorqueMotor.*inv(Hj);
Bc = diag(diag(Bc));
Bc = Bc(1,1);
C = [1];
D = [0];

% Discretizacao
T = 0.005;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');
