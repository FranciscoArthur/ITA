function [sys,dummy0,str,ts] = mpc_ss_du_restricoes_relaxamento(t,dummy,inputs,flag,Phi,G,Hqp,Aqp,flp,Alp,dumax,dumin,umax,umin,ymax,ymin,ymax_physical,ymin_physical,M,N,relaxation_flag,T)

% Input parameters:
% Phi: Column vector (N x 1) --> [CA;CA^2; ... ; CA^N]
% G: "Dynamic matrix"
% Hqp,Aqp: H,A matrices for use with the Quadprog function
% flp,Alp: f vector and A matrix for use with the Linprog function
% dumax,dumin,umax,umin,ymax,ymin: Operational constraints
% ymax_physical, ymin_physical: Physical output constraints
% M: Control Horizon
% N: Prediction Horizon
% d1: Weight for the slack variable associated to ymax
% d2: Weight for the slack variable associated to ymin
% relaxation_flag = 0: Standard quadprog relaxation procedure 
% relaxation_flag = 1: Output relaxation using slack variables
% T: Sampling period
%
% Input variables (in this order): yref(k), x(k), u(k-1)
%
% Author: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Date: 16 May 2017

switch flag,

case 0
n = size(Phi,2) - 1; % Dimension of x(k)
[sys,dummy0,str,ts] = mdlInitializeSizes(T,n); % S-function Initialization

case 2
sys = mdlUpdate(t,inputs);
   
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

% Constrained optimal control

fqp = 2*G'*(f - r);

oneM = ones(M,1);
oneN = ones(N,1);
bqp = [oneM*dumax; -oneM*dumin; oneM*(umax - uk1); oneM*(uk1 - umin); oneN*ymax - f; f - oneN*ymin];

options_lp = optimset('LargeScale','off','Display','off');
options_qp = optimset('Algorithm','active-set','Display','on');

if (relaxation_flag == 1) % Uso de variáveis de folga
    blp = [oneM*dumax; -oneM*dumin; oneM*(umax - uk1); oneM*(uk1 - umin); oneN*ymax - f; f - oneN*ymin; ymax_physical - ymax; 0; ymin - ymin_physical;0];
    z = linprog(flp,Alp,blp,[],[],[],[],[],options_lp);
    DUk0 = z(1:M);
    epsilon1 = z(M+1);
    epsilon2 = z(M+2);
    bqp_relaxed = [oneM*dumax; -oneM*dumin; oneM*(umax - uk1); oneM*(uk1 - umin); oneN*(ymax + epsilon1) - f; f - oneN*(ymin - epsilon2)];
    DUk = quadprog(Hqp,fqp,Aqp,bqp_relaxed,[],[],[],[],DUk0,options_qp);
else % Uso direto do quadprog
    epsilon1 = 0;
    epsilon2 = 0;
    DUk = quadprog(Hqp,fqp,Aqp,bqp,[],[],[],[],[],options_qp);
end

sys =  [DUk(1);epsilon1;epsilon2]; % S-function output (control increment and slack variables)

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
sizes.NumOutputs     = 3; % du(k), epsilon1, epsilon2
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
function sys = mdlUpdate(t,inputs)

sys = [];

%end mdlUpdate