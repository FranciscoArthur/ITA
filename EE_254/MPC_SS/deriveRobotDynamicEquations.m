%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   C�digo que gera a Matriz H da dinamica do rob� small size segundo 
% modelagem feita por Marcos M�ximo. Equacionamento retirado do c�digo 
% deriveRobotDynamicEquations formulado por Marcos M�ximo e alterado para
% autogerar uma fun��o e um bloco no simulink que utilizam os resultados
% desse c�digo.
% 
% Vers�o 1.0: 07/05/2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Declarando as vari�veis simbolicas
syms w1 w2 w3 w4 r l N m Icm xcm ycm real
syms Input

% �ngulos de posi��o das rodas
% alpha = deg2rad([33; 147; 225; 315]); % Skuba
alpha = deg2rad([45; 135; 225; 315]); % ITAndroids
beta = [0; 0; 0; 0];

col1 = -sin(alpha + beta);
col2 = cos(alpha + beta);
col3 = l * cos(beta);

M = [col1, col2, col3];


% pseudoinversa de Moore-Penrose
Mpinv = (M' * M)^-1 * M';

vr = r * Mpinv * [w1; w2; w3; w4]; 
cm = [xcm; ycm; 0]; % posi��o do centro de massa
 
vcm = [vr(1); vr(2); 0] + cross([0; 0; vr(3)], cm); %vetor velocidade do CM
w = vr(3); % velocidade de rota��o do rob�

T = (1/2) * m * (vcm' * vcm) + (1/2) * Icm * (w' * w); % Energia cin�tica

V = 0; % Energia potencial
 
L = T - V; % Lagrangeana

% Derivadas da lagrangeana
dLdw1 = expand(simplify(diff(L, w1))); 
dLdw2 = expand(simplify(diff(L, w2)));
dLdw3 = expand(simplify(diff(L, w3)));
dLdw4 = expand(simplify(diff(L, w4)));

dLdw = [dLdw1; dLdw2; dLdw3; dLdw4];

% Formula��o da matriz H da din�mica do rob�
H1 = subs(dLdw, [w1 w2 w3 w4], [1 0 0 0]);
H2 = subs(dLdw, [w1 w2 w3 w4], [0 1 0 0]);
H3 = subs(dLdw, [w1 w2 w3 w4], [0 0 1 0]);
H4 = subs(dLdw, [w1 w2 w3 w4], [0 0 0 1]);

H = simplify([H1, H2, H3, H4]);


%% Autogera uma fun��o e um bloco do simulink que soma um valor a matriz H

sysName = 'RobotDynamicMatrixH'; %nome dos arquivos
par = {m r l ycm xcm Icm}; %parametros
Output = H; %opera��o

m_fileName  = strcat(sysName,'.m');
s_fileName  = strcat(sysName,'_block');
s_blockName = strcat(s_fileName,'/',sysName);

% create MATLAB function
matlabFunction(Output,...
    'file',     m_fileName,...
    'vars',   [ Input, par],...%variaveis de input
    'outputs', {'InputPlusH'});
% create Simulink block
new_system  (s_fileName)
matlabFunctionBlock(s_blockName,Output,...
    'functionName', sysName,...
    'vars',       [Input, par],...%variaveis de input
    'outputs',     {'InputPlusH'});
save_system (s_fileName)
close_system(s_fileName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Observa��o importante:
% 
% Ap�s auto gerar o c�digo, 
% deve-se adicionar a seguinte linha
% no final do c�digo:
% InputPlusH = (InputPlusH + Input);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
