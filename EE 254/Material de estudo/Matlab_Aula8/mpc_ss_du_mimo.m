function [sys,dummy0,str,ts] = mpc_ss_du_mimo(t,dummy,inputs,flag,KMPC,Phi,p,q,n,N,T)

% Parâmetros de entrada:
% KMPC: Vetor de ganho (p x qN)
% Phi: Vetor coluna (qN x (n+p)) --> [CA;CA^2; ... ; CA^N]
% p: Número de variáveis manipuladas
% q: Número de variáveis controladas
% n: Número de estados da planta
% N: Horizonte de predição
%
% T: Período de amostragem
%
% Variáveis de entrada (nesta ordem): yref(k), x(k), u(k-1)
%
% Autor: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Data: 11 de abril de 2017

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