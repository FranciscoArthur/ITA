function [sys,dummy0,str,ts] = mpc_regulador_estabilidade(t,dummy,inputs,flag,Phiu,Hn,Hqp,Aqp,Aeq,umax,umin,xmax,xmin,p,n,N,T)

% Input parameters:
% Phiu: Column vector (nN x 1) --> [A;A^2; ... ; A^N]
% Hn: Normalized Dynamic matrix
% Hqp,Aqp: H,A matrices for use with the Quadprog function
% Aeq: For use in the equality constraint
% umax,umin,ymax,ymin: Constraints
% N: Prediction Horizon
% T: Sampling period
%
% Input variables: x(k)
%
% Autor: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Data: 23 de maio de 2017

switch flag,

case 0
[sys,dummy0,str,ts] = mdlInitializeSizes(T,p,n); % S-function Initialization

case 2
sys = mdlUpdate(t);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

xk = inputs;  % x(k)
    
% Resposta livre
fu = Phiu*xk;
   
% Cálculo do controle ótimo

fqp = 2*Hn'*fu;

bqp = [repmat(umax,N,1);
       - repmat(umin,N,1);
       repmat(xmax,N,1) - fu;
       fu - repmat(xmin,N,1);];

beq = -fu(end-n+1:end);
  
options = optimset('Display','final');
Uk = quadprog(Hqp,fqp,Aqp,bqp,Aeq,beq,[],[],[],options);

sys =  Uk(1:p); % Saída da S-function

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,dummy0,str,ts] = mdlInitializeSizes(T,p,n)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = p; % u(k)
sizes.NumInputs      = n; % x(k)
sizes.DirFeedthrough = 1; % Yes
sizes.NumSampleTimes = 1;   % Just one sample time

sys = simsizes(sizes);

%
% initialize the initial conditions
%
dummy0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [T 0];

% end mdlInitializeSizes

%=======================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=======================================================================
%
function sys = mdlUpdate(t)

sys = [];

%end mdlUpdate