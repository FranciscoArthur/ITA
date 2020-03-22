function [sys,dummy0,str,ts] = mpc_ss_du(t,dummy,inputs,flag,KMPC,Phi,T)

% Input parameters:
% KMPC: MPC gain vector
% Phi: Column vector (N x 1) --> [CA;CA^2; ... ; CA^N]
% T: Sampling period
%
% Input variables (in this order): yref(k), x(k), u(k-1)
%
% Autor: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Data: 15 de março de 2011

switch flag,

case 0
n = size(Phi,2) - 1; % Dimensão de x(k). Vale notar que Phi multiplica o estado aumentado xi(k)
[sys,dummy0,str,ts] = mdlInitializeSizes(T,n); % S-function Initialization

case 2
sys = mdlUpdate(t);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

yref = inputs(1); % yref(k)
xk = inputs(2:end-1);  % x(k)
uk1 = inputs(end); % u(k-1)

xik = [xk;uk1]; % Estado aumentado xi(k)
    
% Valores futuros de referência
N = size(Phi,1);
r = yref*ones(N,1);
    
% Resposta livre
f = Phi*xik;

% Incremento no controle
duk = KMPC*(r - f);
sys =  duk; % S-function output (incremento no controle)

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
sizes.NumOutputs     = 1; % du(k)
sizes.NumInputs      = 2 + n; % yref(k), x(k), u(k-1)
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