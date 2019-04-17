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

exemplo = openfig('EqAnaliseModal.fig');

prompt = {'Entre com os valores da Matriz de Massa','m_{1}:','m_{2}:'};
dlgtitle = 'Matriz de Massa, PARTE 1/5';
dims = [0 50;1 15;1 15];
definput = {'','1','1'};
opts.Interpreter = 'tex';
answerMassa = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores da Matriz de Rigidez','k_{11}:','k_{12}:','k_{21}:','k_{22}:'};
dlgtitle = 'Matriz de rigidez, PARTE 2/5';
dims = [0 50;1 15;1 15;1 15;1 15];
definput = {'','2','-1','-1','1'};
opts.Interpreter = 'tex';
answerRigidez = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores da Matriz de Amortecimento','c_{11}:','c_{12}:','c_{21}:','c_{22}:'};
dlgtitle = 'Matriz de Amortecimento, PARTE 3/5';
dims = [0 50;1 15;1 15;1 15;1 15];
definput = {'','2','-1','-1','1'};
opts.Interpreter = 'tex';
answerAmortecimento = inputdlg(prompt,dlgtitle,dims,definput,opts);

close(exemplo);
% Matrizes características do problema

M = [str2double(answerMassa{2,1}) 0; 0 str2double(answerMassa{3,1})]

K = [str2double(answerRigidez{2,1}) str2double(answerRigidez{3,1}); str2double(answerRigidez{4,1}) str2double(answerRigidez{5,1})]

C = [str2double(answerAmortecimento{2,1}) str2double(answerAmortecimento{3,1}); str2double(answerAmortecimento{4,1}) str2double(answerAmortecimento{5,1})]


% Condições iniciais do problema

prompt = {'Entre com as condições iniciais',...
          'Corpo 1','Posição inicial:','Velocidade inicial:'...
          'Corpo 2','Posição inicial:','Velocidade inicial:'};
dlgtitle = 'Condições iniciais, PARTE 5/5';
dims = [0 50;0 30;1 30;1 30;0 30;1 30;1 30];
definput = {'','','0','0','','1','0'};
answerCondIni = inputdlg(prompt,dlgtitle,dims,definput,opts);

x10 = str2double(answerCondIni{3,1});
xdot10 = str2double(answerCondIni{4,1});
x20 = str2double(answerCondIni{6,1});
xdot20 = str2double(answerCondIni{7,1});


% Problema de autovalor
[autovec,autoval] = eig(M\K);

% Frequências naturais do sistema
W = sort(diag(sqrt(autoval))); %frequências naturais

if W(1,1) == sqrt(autoval(1,1))
    phi = autovec; %autovetores representando os modos
else 
    phi = [autovec(:,2) autovec(:,1)];
end
% Transformação modal

Mcursiv = phi'*M*phi;
Kcursiv = phi'*K*phi;
Ccursiv = phi'*C*phi;

EtaIni = phi\[x10 x20]';
EtaDotIni = phi\[xdot10 xdot20]';

% Resolvendo a EDO
tspan = 0: 0.01: 20; %tempo total em segundos
eta0 = [EtaIni(1,1),EtaDotIni(1,1),EtaIni(2,1),EtaDotIni(2,1)]'; %Condições iniciais do problema
[t,eta] = ode45(@(temp,y) Equacionando(temp,y,Mcursiv,Kcursiv,Ccursiv,phi), tspan, eta0);


x = phi*[eta(:,1)';eta(:,3)'];

subplot (211)
plot (t,x(1,:),'r');
xlabel ('t');
ylabel ('x1 (t)');
grid on
title('Deslocamento no tempo para a massa 1');
subplot (212)
plot (t,x(2,:),'k');
xlabel ('t');
ylabel ('x2 (t)');
grid on
title('Deslocamento no tempo para a massa 2');

% Equacionando as EDOs
function ydot = Equacionando(t,y,Mcursiv,Kcursiv,Ccursiv,phi)
F_1 = @(t) 0*1*cos(3*t);
F_2 = @(t) 0*2*cos(3*t);

Fcursiv_1 = @(t) phi(1,1)*F_1(t) + phi(2,1)*F_2(t);
Fcursiv_2 = @(t) phi(1,2)*F_1(t) + phi(2,2)*F_2(t);

ydot = zeros(4, 1);
ydot(1) = y(2);
ydot(2) = Mcursiv(1,1)^-1*Fcursiv_1(t)-(Mcursiv(1,1)^-1)*Ccursiv(1,1)*y(2)-(Mcursiv(1,1)^-1)*Kcursiv(1,1)*y(1);
ydot(3) = y(4);
ydot(4) = Mcursiv(2,2)^-1*Fcursiv_2(t)-(Mcursiv(2,2)^-1)*Ccursiv(2,2)*y(4)-(Mcursiv(2,2)^-1)*Kcursiv(2,2)*y(3);
end
