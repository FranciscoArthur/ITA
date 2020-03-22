%
% This software is shareware courtesy of the authors.   
% All rights reserved. No part of this software package 
% may be altered or reproduced, in any form or by any means, 
% without the written consent of the author.   
% The package is provided as is with no warantee intended or implied. 
% Please report any bugs or possible 
% enhancements to: Email: nam_ase@msn.com
% 6/1/01
% Copyright (C) C. Nam 2001
%
% version May 2001
% By changho nam
% 2 dof system 
% xth ; x _ theta
% rth2 ; ( r _theta)^2
% R2 ; (omega h /omega alpha)^2
xth =0.2;   
R2  =(0.3)^2;
rth2=(0.5)^2;
mu  =20.0 ; 
a   =-0.1 ;
b=1;
%
i=sqrt(-1);
rst1=zeros(2,400); rst2=zeros(2,400); vel=zeros(2,400);
a11=(m*s^3*c)/3 + M*s^3/3;  % I kappa
a22= m*s*(c^3/3 - c*c*xf + xf*xf*c) + M*(xf^2*s); % I theta
a12 = m*s*s/2*(c*c/2 - c*xf) - M*xf*s^2/2;  %I kappa theta
a21 = a12;
A=[a11,a12;a21,a22];

k1=(kappa_freq*pi*2)^2*a11; %k kappa
k2=(theta_freq*pi*2)^2*a22; %k theta
E=[k1 0; 0 k2];

for kk=400:-1:1;
rk=kk*0.01;

%
% Theodorsen Function Calculation
C=0.5+0.0075/(i*rk+0.0455)+0.10055/(i*rk+0.3);

% % Mass
% % ms=[ 1     xth
% %      xth   rth2];
% % 
% % stiffness matrix
% % ks=[ R2  0
% %      0   rth2];
% % 
lh=1-i*2*C/rk;    la=.5-i*(1+2*C)/rk-2*C/rk/rk;
mh=0.5;           ma=3/8-i/rk;

Ca=rho*V*[c*s^3*a/6,0;-c^2*s^2*e*a/4,-c^3*s*Mthetadot/8] + alpha*A + beta*E; % aero and structural damping

% % aero=[ lh               la-(.5-a)*lh
% %        mh-(.5+a)*lh     ma-(.5+a)*(la+mh)+(.5+a)*(.5+a)*lh]/mu;

ddd=eig(inv(ks)*(aero+ms));  rrr=real(ddd); iii= imag(ddd);
rst1(:,kk)=sqrt(1./rrr);  rst2(:,kk)=iii./rrr;
vel(:,kk)=sqrt(1./rrr)/rk; % normalized velocity = V/(omega theta * b)
end

xxx=[vel(1,:); rst1(1,:); rst2(1,:); vel(2,:); rst1(2,:); rst2(2,:)]';
figure(1);
plot(vel(1,:),rst1(1,:),'*r',vel(2,:),rst1(2,:),'*r'),axis([0.0 5.00 0 1.60]),
xlabel('Velocity (V/\omega_\theta b)'),ylabel('Frequency Ratio (\omega / \omega_\theta )'),grid;
figure(2);
plot(vel(1,:),rst2(1,:),'*r',vel(2,:),rst2(2,:),'*r'),axis([0.0 5.00 -1.2 1.0]),
xlabel('Velocity  (V/\omega_\theta b)'),ylabel('g'),grid;


