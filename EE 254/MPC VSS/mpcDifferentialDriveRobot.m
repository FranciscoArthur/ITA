function [sys,state0,str,ts] = mpcDifferentialDriveRobot(t,state,input,flag,qr,ur,Qbar,Rbar,S,b,p,n,M,N,T)

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
% Data: 09 de maio de 2011

switch flag,

case 0
[sys,state0,str,ts] = mdlInitializeSizes(T,p,n); % S-function Initialization

case 2
sys = mdlUpdate(t,state);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

k = state;

k

qr(k,:)

input

u = computeMpc(k,input,qr,ur,Qbar,Rbar,S,b,p,n,M,N,T);

sys =  ur(k,:)' + u;%[ur(k,1)*cos(qr(k,3)-input(3)) ur(k,2)]' + u; % Saída da S-function (p controles)

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,state0,str,ts] = mdlInitializeSizes(T,p,n)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 1;
sizes.NumOutputs     = p; % u(k)
sizes.NumInputs      = n; % x(k)
sizes.DirFeedthrough = 1; % Yes
sizes.NumSampleTimes = 1;   % Just one sample time

sys = simsizes(sizes);

%
% initialize the initial conditions
%
state0  = 1;

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
function sys = mdlUpdate(t,state)

sys = state + 1;

%end mdlUpdate