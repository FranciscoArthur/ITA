close all
clear all
% ASA HANKOCK
s=7.5;          % semi span
c=2;            % chord
m=100;          % unit mass / area of wing
kappa_freq = 5; % flapping freq in Hz
theta_freq = 10;% torsion (pitch) freq in Hz
xcm=0.5*c;     % position of centre of mass from nose 
rho=1.225;      %air density      
xf=0.48*c;      % position of flexural axis from nose
Mthetadot=-1.2;   % unsteady damping term
e=xf/c - 0.25;  % eccentricity between flexural axis and aero centre (1/4 chord)

%Mass
M = (m*c^2 - 2*m*c*xcm)/(2*xcm);   % leading edge mass term to allow mass axis to move
a11=(m*s^3*c)/3 + M*s^3/3;  % I kappa
a22= m*s*(c^3/3 - c*c*xf + xf*xf*c) + M*(xf^2*s); % I theta
a12 = m*s*s/2*(c*c/2 - c*xf) - M*xf*s^2/2;  %I kappa theta
a21 = a12;
ms=[a11,a12;a21,a22];

%stiffness matrix
k1=(kappa_freq*pi*2)^2*a11; %k kappa
k2=(theta_freq*pi*2)^2*a22; %k theta
ks=[k1 0; 0 k2];

%
i=sqrt(-1);
rst1=zeros(2,400); 
rst2=zeros(2,400); 
vel=zeros(2,400);
aw = 2*pi;

for kk=400:-1:20
    
rk=kk*0.01;

%
% Theodorsen Function Calculation APROXIMADA
C=0.5+0.0075/(i*rk+0.0455)+0.10055/(i*rk+0.3);


aero=[ i*rho*c^2*s^3*aw/(6*rk)            aw*rho*s^2*c^3/(4*rk^2)
       i*rho*c^3*s^3*e*aw/(4*rk)     i*rho*c^4*s^2*Mthetadot/(8*rk)+0.5*rho*c^4*s^2*e*aw/(2*rk^2)];
%SOLUÇÃO DO PROBLEMA DE AUTOVALOR
ddd=eig(inv(ks)*(aero+ms)); 
rrr=real(ddd); 
iii= imag(ddd);

rst1(:,kk)=sqrt(1./rrr);  
rst2(:,kk)=iii./rrr;
vel(:,kk)=sqrt(1./rrr)/rk; % normalized velocity = V/(omega theta * b)
end

xxx=[vel(1,:); rst1(1,:); rst2(1,:); vel(2,:); rst1(2,:); rst2(2,:)]';
figure(1);
plot(vel(1,:),rst1(1,:),'*r',vel(2,:),rst1(2,:),'*r'),%axis([0.0 5.00 0 1.60]),
xlabel('Velocity (V/\omega_\theta b)'),ylabel('Frequency Ratio (\omega / \omega_\theta )'),grid;
figure(2);
plot(vel(1,:),rst2(1,:),'*r',vel(2,:),rst2(2,:),'*r'),%axis([0.0 5.00 -1.2 1.0]),
xlabel('Velocity  (V/\omega_\theta b)'),ylabel('g'),grid;


