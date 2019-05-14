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
w_equilibrio = [0]';
u_equilibrio = [0]';

M = [-sin(alpha(1,1)+beta(1,1)), cos(alpha(1,1)+beta(1,1)), l*cos(beta(1,1));...
     -sin(alpha(2,1)+beta(2,1)), cos(alpha(2,1)+beta(2,1)), l*cos(beta(2,1));...
     -sin(alpha(3,1)+beta(3,1)), cos(alpha(3,1)+beta(3,1)), l*cos(beta(3,1));...
     -sin(alpha(4,1)+beta(4,1)), cos(alpha(4,1)+beta(4,1)), l*cos(beta(4,1))];

% Matrizes do espaço de estados

% %% linearizando no MatLab
% % Essa linearização demora muito, então recomenda-se linearizar 1 vez
% % e guardar o valor das matrizes A, B, C e D e comentar o código
% % Cuidado ao tirar as matrizes do resultado! Sai como 7x7 ou 7x4 e
% % deve-se tirar as correspondentes a Integrator(1), Integrator(2) etc.
%
% sys = 'ModelSmallSize';
% open_system(sys)
% 
% % Nome do caminho para o bloco que se deseja linearizar
% blockpath = 'ModelSmallSize/Modelo do robô Small Size';
% 
% % Linearize the specified block at the model operating point.
% linsys = linearize(sys,blockpath);
% 
% %%




Jeq = (redu^2*eta*InerciaMotor+InerciaRoda)*eye(4);
Hj = RobotDynamicMatrixH(Jeq,m,r,l,ycm,xcm,InerciaCM);

Cv = (redu^2*eta*CoefAtritViscMotor+CoefAtritViscRoda+redu*eta*ConstanteTorqueMotor^2/ResistMot)*eye(4);

Ac = [-48.420000   0.02062   -0.09803    0.02062;...
         0.02062 -48.42000    0.02062   -0.09803;...
        -0.09803   0.02062  -48.42000    0.02062;...
         0.02062  -0.09803    0.02062  -48.42000];
     
     
Bc = [-11.0800000  -0.004718   0.022430   -0.004718;...
        -0.004718 -11.080000  -0.004718    0.022430;...
         0.022430  -0.004718  11.080000   -0.004718;...
        -0.004718   0.022430  -0.004718  -11.080000];
C = eye(3);
D = zeros(4,4);

% Discretizacao
T = 0.005;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');

