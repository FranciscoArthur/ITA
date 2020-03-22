function [sys,past_ydu0,str,ts] = mpc_arx_du(t,past_ydu,inputs,flag,KMPC,Kdu,Ky,N,n,T)

% Notes:
% 1) At time k, the state past_ydu of this S-function comprises the following n past measurements and (n - 1) past control moves:
%    past_ydu = [y(k - 1) ... y(k - n) du(k - 1) ... du(k - n + 1)]'       
% 2) At time k, the inputs to the S-function are yref(k), y(k)
% 3) At each simulation iteration, the output of the S-function is calculated (case 3) and then the state is updated (case 2)
%
% Author: Roberto Kawakami Harrop Galvao
% ITA - Divisao de Engenharia Eletronica
% Date: 13 March 2019

switch flag,

case 0
[sys,past_ydu0,str,ts] = mdlInitializeSizes(T,n); % S-function Initialization

case 2
sys = mdlUpdate(t,past_ydu,inputs,n);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

global duk
    
yref = inputs(1); % Reference signal
yk = inputs(2);  % Measured Output
    
% r (future reference values)
r = yref*ones(N,1);
    
% f (free response)
yp = [yk;past_ydu(1 : n)];
f = Ky * yp;
if n > 1
    Dup = past_ydu(n + 1 : end);
    f = f + Kdu * Dup;
end

% Optimal control
duk = KMPC * (r - f);
sys =  duk; % S-function output (control increment)

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,past_ydu0,str,ts] = mdlInitializeSizes(T,n)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

Nstates = 2*n - 1;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = Nstates;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % Just one sample time

sys = simsizes(sizes);

%
% initialize the initial conditions
%
past_ydu0  = zeros(Nstates,1);

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
function sys = mdlUpdate(t,past_ydu,inputs,n)

global duk

% Housekeeping
yk = inputs(2);

past_y = [];
past_y = [yk;past_ydu(1 : n - 1)];

past_du = [];
if n > 1
    past_du = [duk;past_ydu(n + 1 : end - 1)];
end
    
sys = [past_y;past_du];

%end mdlUpdate