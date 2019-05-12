function [sys,dummy0,str,ts] = mpc_ss_delta(t,dummy,inputs,flag,Nx,Nu,Kdelta,T)

% Input parameters:
% Nx, Nu: Matrices employed in the calculation of xref and uref
% Kdelta: Controller gain
% T: Sampling period
%
% Input variables (in this order): yref(k), x(k), d(k)
%
% Author: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Date: 17 December 2018

switch flag,

case 0
n = size(Nx,1); % Dimensão de x(k). 
[sys,dummy0,str,ts] = mdlInitializeSizes(T,n); % S-function Initialization

case 2
sys = mdlUpdate(t);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

yref = inputs(1); % yref(k)
xk = inputs(2:end-1);  % x(k)
dk = inputs(end); % d(k)
    
xref = Nx*(yref - dk);
uref = Nu*(yref - dk);

dxk = xk - xref;

% Variação do controle com respeito ao valor de equilíbrio
duk = -Kdelta*dxk;

sys =  duk + uref; % S-function output (controle)

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,dummy0,str,ts] = mdlInitializeSizes(T,n)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1; % u(k)
sizes.NumInputs      = 2 + n; % yref(k), x(k), d(k)
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