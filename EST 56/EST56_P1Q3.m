%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Código para analise modal de sistemas com múltiplos 
%                   graus de liberdade (GDL)
%     
%     
%  Para utilizar o código, basta modelar o problema, obter a 
%  matriz de massa, rigidez e amortecimento.
%  
%  Autor: Arthur Azevedo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pop-up que coleta as propriedades do problema
openfig('EqAnaliseModal.fig');
prompt = {'Entre com os valores da Matriz de Massa','m_{1}:','m_{2}:'};
dlgtitle = 'Matriz de Massa, PARTE 1/5';
dims = [0 50;1 15;1 15];
definput = {'','1','2'};
opts.Interpreter = 'tex';
answerMassa = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores da Matriz de Rigidez','k_{11}:','k_{12}:','k_{21}:','k_{22}:'};
dlgtitle = 'Matriz de rigidez, PARTE 2/5';
dims = [0 50;1 15;1 15;1 15;1 15];
definput = {'','3','4','5','6'};
opts.Interpreter = 'tex';
answerRigidez = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores da Matriz de Amortecimento','c_{11}:','c_{12}:','c_{21}:','c_{22}:'};
dlgtitle = 'Matriz de Amortecimento, PARTE 3/5';
dims = [0 50;1 15;1 15;1 15;1 15];
definput = {'','3','4','5','6'};
opts.Interpreter = 'tex';
answerAmortecimento = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores do Vetor de Forças','F_1:','F_2:' };
dlgtitle = 'Forças Externas, PARTE 4/5';
dims = [0 50;1 15;1 15];
definput = {'','3','4','5','6'};
opts.Interpreter = 'tex';
answerForcas = inputdlg(prompt,dlgtitle,dims,definput,opts);

% Matrizes características do problema

M = [str2double(answerMassa{2,1}) 0; 0 str2double(answerMassa{3,1})]

K = [str2double(answerRigidez{2,1}) str2double(answerRigidez{3,1}); str2double(answerRigidez{4,1}) str2double(answerRigidez{5,1})]

D = [str2double(answerAmortecimento{2,1}) str2double(answerAmortecimento{3,1}); str2double(answerAmortecimento{4,1}) str2double(answerAmortecimento{5,1})]

% Vetor de forças

F = [str2double(answerForcas{2,1});str2double(answerForcas{3,1})]

% Condições iniciais do problema

prompt = {'Entre com as condições iniciais',...
          'Corpo 1','Posição inicial:','Velocidade inicial:'...
          'Corpo 2','Posição inicial:','Velocidade inicial:'};
dlgtitle = 'Condições iniciais, PARTE 5/5';
dims = [0 50;0 30;1 30;1 30;0 30;1 30;1 30];
definput = {'','','0','1','','0','0'};
answerCondIni = inputdlg(prompt,dlgtitle,dims,definput,opts);

x10 = str2double(answerCondIni{3,1});
xdot10 = str2double(answerCondIni{4,1});
x20 = str2double(answerCondIni{6,1});
xdot20 = str2double(answerCondIni{7,1});


% Problema de autovalor
[autovec,autoval] = eig(inv(M)*K);

% Frequências naturais do sistema
W = diag(sqrt(autoval)); %frequências naturais
phi = autovec; %autovetores representando os modos

% Transformação modal

Mcursiv = phi'*M*phi;
Kcursiv = phi'*K*phi;
Ccursiv = phi'*C*phi;
Fcursiv = phi'*F;

EtaIni = phi\[x10 x20]';
EtaDotIni = phi\[xdot10 xdot20]';

% Resolvendo a EDO
tspan = 10; %tempo total em segundos
y0 = [xdot10,x10,xdot20,x20]'; %Condições iniciais do problema
[t,eta] = ode45(@(temp,y) Equacionando(temp,y,Mcursiv,Kcursiv,Ccursiv,phi), tspan, y0);


% Equacionando as EDOs
function eta = Equacionando(t,y,Mcursiv,Kcursiv,Ccursiv,phi)
F_1 = @(t) 3*cos(t);
F_2 = @(t) 4*sin(t);

Fcursiv_1 = @(t) phi(1,1)*F_1(t) + phi(2,1)*F_2(t);
Fcursiv_2 = @(t) phi(1,2)*F_1(t) + phi(2,2)*F_2(t);

eta = zeros(4, 1);
eta(1) = y(1);
eta(2) = Mcursiv(1,1)^-1*Fcursiv_1(t)-Mcursiv(1,1)^-1*Ccursiv(1,1)*y(1)+Mcursiv(1,1)^-1*Kcursiv(1,1)*y(2);
eta(3) = y(3);
eta(4) = Mcursiv(2,2)^-1*Fcursiv_2(t)-Mcursiv(2,2)^-1*Ccursiv(2,2)*y(3)+Mcursiv(2,2)^-1*Kcursiv(2,2)*y(4);
end
