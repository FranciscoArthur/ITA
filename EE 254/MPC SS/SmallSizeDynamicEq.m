% Monta a formulação lagrangeana e transforma em uma função do matlab e um
% bloco do simulink
syms m r l ycm xcm Icm
syms theta1 theta2 theta3 theta4  
syms w1 w2 w3 w4  
syms tal1 tal2 tal3 tal4

v   = r*sqrt(2)/4*(-w1-w2+w3+w4);
vn  = r*sqrt(2)/4*(w1-w2-w3+w4);
w   = r/(4*l)*(w1+w2+w3+w4);

Vcm = [ v-w*ycm; vn+w*xcm; 0];

Vcm_quad = (v-w*ycm)^2+(vn+w*xcm)^2;

T   = (1/2)*m*Vcm_quad + (1/2)*Icm*w^2;
V   = 0;
L   = T - V;
E   = T + V;
X   = {theta1 w1 theta2 w2 theta3 w3 theta4 w4};
Q_i = {0 0 0 0}; 
Q_e = {tal1 tal2 tal3 tal4};
R   = 0;
par = {m r l ycm xcm Icm};
% Solve Lagrange equations and save DE as .m file
VF  = EulerLagrange(L,X,Q_i,Q_e,R,par,'m','SmallSizeDinamic_sys');