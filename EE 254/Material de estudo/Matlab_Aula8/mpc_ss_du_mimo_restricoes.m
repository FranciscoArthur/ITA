function [sys,dummy0,str,ts] = mpc_ss_du_mimo_restricoes(t,dummy,inputs,flag,Phi,Gn,Hqp,Aqp,dumax,dumin,umax,umin,ymax,ymin,p,q,n,M,N,T)

% Input parameters:
% Phi: Column vector (N x 1) --> [CA;CA^2; ... ; CA^N]
% Gn: Normalized Dynamic matrix
% Hqp,Aqp: H,A matrices for use with the Quadprog function
% dumax,dumin,umax,umin,ymax,ymin: Constraints
% M: Control Horizon
% N: Prediction Horizon
% T: Sampling period
%
% Input variables (in this order): yref(k), x(k), u(k-1)
%
% Autor: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Data: 10 de maio de 2017

switch flag,

case 0
[sys,dummy0,str,ts] = mdlInitializeSizes(T,p,q,n); % S-function Initialization

case 2
sys = mdlUpdate(t);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

yref = inputs(1:q); % yref(k)
xk = inputs(q+1:q+n);  % x(k)
uk1 = inputs(q+n+1:end); % u(k-1)

xik = [xk;uk1]; % Estado aumentado xi(k)
    
% Valores futuros de referência
r = repmat(yref,N,1);

% Resposta livre
f = Phi*xik;
   
% Cálculo do controle ótimo

bqp = [repmat(dumax,M,1); -repmat(dumin,M,1); repmat((umax - uk1),M,1); repmat((uk1 - umin),M,1); repmat(ymax,N,1) - f; f - repmat(ymin,N,1)];

fqp = 2*Gn'*(f - r);

options = optimset('Algorithm','active-set','Display','final');
DUk = quadprog(Hqp,fqp,Aqp,bqp,[],[],[],[],[],options);

sys =  DUk(1:p); % Saída da S-function (incremento nos p controles)

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,dummy0,str,ts] = mdlInitializeSizes(T,p,q,n)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = p; % du(k)
sizes.NumInputs      = q + n + p; % yref(k), x(k), u(k-1)
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