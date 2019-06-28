function [sys,past_x0,str,ts] = mpc_lmi(t,past_x,inputs,flag,S,R,A,B,C,umax,ymax,T)

switch flag,

case 0
n = size(A,1);
p = size(B,2);
[sys,past_x0,str,ts] = mdlInitializeSizes(T,p,n); % S-function Initialization

case 2
sys = mdlUpdate(t,inputs);
   
case {1,4,9}
sys = []; % Unused Flags
   
case 3 % Evaluate Function

n = size(A,1);
p = size(B,2);
q = size(C,1);
    
xk = inputs;  % Measured state: x(k)
    
n = size(A,1);
p = size(B,2);
Ssqrt = sqrtm(S); 
Rsqrt = sqrtm(R); 

E = eye(p); % Identity matrix. en = nth column of E

setlmis([])
g = lmivar(1,[1 0]);
Q = lmivar(1,[n,1]);
Y = lmivar(2,[p,n]);
X = lmivar(1,[p,1]); % Symmetric block diagonal, 1 full block n x n

% 1st LMI
lmiterm([-1 1 1 Q],1,1);
lmiterm([-1 1 2 0],xk);
lmiterm([-1 2 2 0],1);

% 2nd LMI
lmiterm([-2 1 1 Q],1,1);
lmiterm([-2 1 4 Q],A,1);
lmiterm([-2 1 4 Y],B,1);
lmiterm([-2 2 2 g],1,1);
lmiterm([-2 2 4 Q],Ssqrt,1);
lmiterm([-2 3 3 g],1,1);
lmiterm([-2 3 4 Y],Rsqrt,1);
lmiterm([-2 4 4 Q],1,1);

% 3rd LMI
lmiterm([-3 1 1 X],1,1);
lmiterm([-3 1 2 Y],1,1);
lmiterm([-3 2 2 Q],1,1);

% 4th LMI
for i = 1:p
    e = E(:,i);
    lmiterm([4 i i X],e',e);
    lmiterm([-4 i i 0],(umax(i))^2);
end

% 5th LMI
for j = 1:q
    Cj = C(j,:);
    lmiterm([-(4+j) 1 1 Q],1,1);
    lmiterm([-(4+j) 2 1 Q],Cj*A,1);
    lmiterm([-(4+j) 2 1 Y],Cj*B,1);
    lmiterm([-(4+j) 2 2 0],(ymax(j))^2);
end

lmisys = getlmis;

ndecvar = decnbr(lmisys);
c = zeros(ndecvar,1);
c(1) = 1; % Cost = 1*gamma

options = [0 0 0 0 1]; % Trace off

[copt,xopt] = mincx(lmisys,c,options);

Ysol = dec2mat(lmisys,xopt,Y);
Qsol = dec2mat(lmisys,xopt,Q);

K = Ysol*inv(Qsol);
uk = K*xk;

sys =  uk; % S-function output (control value)

end

%%%%%%%%%%%%%%%%%%%%%%%%

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,past_x0,str,ts] = mdlInitializeSizes(T,p,n)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = p;
sizes.NumInputs      = n;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % Just one sample time

sys = simsizes(sizes);

%
% initialize the initial conditions
%
past_x0  = []; 

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

% Housekeeping
sys = [];

%end mdlUpdate