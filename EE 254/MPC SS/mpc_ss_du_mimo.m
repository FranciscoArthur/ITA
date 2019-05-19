function [sys,dummy0,str,ts] = mpc_ss_du_mimo(t,dummy,inputs,flag,dumax,dumin,umax,umin,ymax,ymin,p,q,n,N,M,mu,rho,T)

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
Ac = [0  0  0;
      0  0  0;
      0  0  0];
     
Bc = -eye(3);

C = eye(3);

D = zeros(3,3);

% Discretizacao
T = 0.005;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');

assignin('base','Ac',Ac)
assignin('base','Bc',Bc)
assignin('base','C',C)
assignin('base','D',D)
assignin('base','A',A)
assignin('base','B',B)

case 2
sys = mdlUpdate(t);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

yref = inputs(1:q); % yref(k)
xk = inputs(q+1:q+n);  % x(k)
uk1 = inputs(q+n+1:end-1); % u(k-1)
wr = inputs(end); % velocidade angular de referencia

xik = [xk;uk1]; % Estado aumentado xi(k)
    
% Valores futuros de referência
r = repmat(yref,N,1);
    
Ac = [0  wr 0;
     -wr 0  0;
      0  0  0];
     
Bc = -eye(3);

C = eye(3);

D = zeros(3,3);

% Discretizacao
T = 0.005;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');

assignin('base','Ac',Ac)
assignin('base','Bc',Bc)
assignin('base','C',C)
assignin('base','D',D)
assignin('base','A',A)
assignin('base','B',B)

[KMPC,Phi] = matrizes_ss_du_mimo(A,B,C,N,M,mu,rho);
%[Phi,Gn,Hqp,Aqp] = matrizes_ss_du_mimo_restricoes(A,B,C,N,M,mu,rho);

% Resposta livre
f = Phi*xik;


% %% Cálculo do controle ótimo
% 
% bqp = [repmat(dumax,M,1); -repmat(dumin,M,1); repmat((umax - uk1),M,1); repmat((uk1 - umin),M,1); repmat(ymax,N,1) - f; f - repmat(ymin,N,1)];
% 
% fqp = 2*Gn'*(f - r);
% 
% 
% DUk = quadprog(Hqp,fqp,Aqp,bqp);
% 
% sys =  DUk; % S-function output (incremento no controle)

%% Incremento no controle
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
sizes.NumInputs      = q + n + p+1; % yref(k), x(k), u(k-1) e wr
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