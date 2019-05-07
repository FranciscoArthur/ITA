function [time,u,udot,uddot] = genHarmonicForcedResp(m,k,c,F_0,omega,x_0,v_0,arg1,arg2)
%General Time Response of the harmonic force applied to the mechanical system
%--------------------------------------------------------------------------
%
%   Mechanical system with one DOF
%
%   Data:
%     m: Mass
%     k: stiffness constant
%	  c: damping constant
%	  x_0: initial displacement 
%	  v_0: initial velocity
%	  F_0: harmonic force amplitude
%	  omega: frequency of the harmonic force
%
%   Calculation for
%     u:        displacement response
%     udot:     velocity response
%	  uddot: 	acceleration response
%
%   Airton Nabarrete, copyright 2017
%   Refer.: Rao - topic 3.4.1 (5th edition)
%   Version 1.10
% **************************************************************************
tmax=arg1;
Fs=arg2;
%
% Natural frequency and damping factor
omega_n=sqrt(k/m);
zeta=c/(2*m*omega_n);
omega_d=omega_n*(sqrt(1-zeta^2));
% 
% Stationary response
Omega=omega/omega_n;
x_est=F_0/k;
H=1/sqrt((1-Omega^2)^2+(2*zeta*Omega)^2);
Cx=1-Omega^2;
Cy=2*zeta*Omega;
phi_estac=atan2(Cy,Cx);
X=H*x_est;
%
% Transient response 
Cx=x_0-X*cos(phi_estac);
Cy=(v_0+zeta*omega_n*x_0-zeta*omega_n*X*cos(phi_estac)-omega*X*sin(phi_estac))/omega_d;
X_gen=sqrt(Cx^2+Cy^2);
phi_gen=atan2(Cy,Cx);
%
i=1;
for t= 0:1/Fs:tmax
    time(i)=t;
    u(i)=X_gen*exp(-zeta*omega_n*t)*cos(omega_d*t-phi_gen)+X*cos(omega*t-phi_estac);
    udot(i)=-X_gen*zeta*omega_n*exp(-zeta*omega_n*t)*cos(omega_d*t-phi_gen);
    udot(i)=udot(i)-X_gen*omega_d*exp(-zeta*omega_n*t)*sin(omega_d*t-phi_gen);
    udot(i)=udot(i)-X*omega*sin(omega*t-phi_estac);
    uddot(i)=X_gen*(zeta*omega_n)^2*exp(-zeta*omega_n*t)*cos(omega_d*t-phi_gen);
    uddot(i)=uddot(i)-X_gen*omega_d^2*exp(-zeta*omega_n*t)*cos(omega_d*t-phi_gen);
    uddot(i)=uddot(i)+X_gen*2*zeta*omega_n*omega_d*exp(-zeta*omega_n*t)*sin(omega_d*t-phi_gen);
    uddot(i)=uddot(i)-X*omega^2*cos(omega*t-phi_estac);
    i=i+1;
end
