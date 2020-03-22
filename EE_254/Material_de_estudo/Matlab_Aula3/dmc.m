function [sys,past_du0,str,ts] = dmc(t,past_du,inputs,flag,KMPC,N,g,Ns,T)

% A perturbação é assumida constante para fins de predição
% Parâmetros:
% KMPC: Vetor de ganho
% Ns: Número de elementos armazenados da resposta a degrau 
%    (Assume-se que a resposta a degrau seja constante após Ns passos)
%     Este é também o número de estados desta S-function (past_du: saídas passadas do controlador)
% T: Período de amostragem
%
% Autor: Roberto Kawakami Harrop Galvao
% ITA - Divisão de Engenharia Eletrônica
% Data: 15 de dezembro de 2018

switch flag,

case 0
[sys,past_du0,str,ts] = mdlInitializeSizes(T,Ns); % S-function Initialization

case 2
sys = mdlUpdate(t,past_du,inputs);

case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function
    
global duk
    
yref = inputs(1); % Referência
y = inputs(2);  % Saída da planta
    
r = yref*ones(N,1); % Vetor de valores futuros da referência
    
% Cálculo da resposta livre f
f = zeros(N,1);

for i = 1:N
   % Assume-se que a resposta a degrau seja constante após Ns passos
   if i < Ns
      gi = [g(1+i:Ns);g(Ns)*ones(i-1,1)]; 
   else
      gi = g(Ns)*ones(Ns-1,1);
   end
   f(i) = y + (gi - g(1:Ns-1))'*past_du;
end

% Cálculo do incremento de controle a ser aplicado
duk = KMPC*(r - f);
sys =  duk; % Saída da S-function (incremento de controle)

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,past_du0,str,ts] = mdlInitializeSizes(T,Ns)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = Ns-1;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % Just one sample time

sys = simsizes(sizes);

%
% initialize the initial conditions
%
past_du0  = zeros(Ns-1,1);

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
function sys = mdlUpdate(t,past_du,inputs)

global duk

% Housekeeping
sys = [duk;past_du(1:end-1)];

%end mdlUpdate