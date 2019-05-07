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
definput = {'','1','2'};
opts.Interpreter = 'tex';
answerMassa = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores da Matriz de Rigidez','k_{11}:','k_{12}:','k_{21}:','k_{22}:'};
dlgtitle = 'Matriz de rigidez, PARTE 2/5';
dims = [0 50;1 15;1 15;1 15;1 15];
definput = {'','4','-1','-1','2'};
opts.Interpreter = 'tex';
answerRigidez = inputdlg(prompt,dlgtitle,dims,definput,opts);

prompt = {'Entre com os valores da Matriz de Amortecimento','c_{11}:','c_{12}:','c_{21}:','c_{22}:'};
dlgtitle = 'Matriz de Amortecimento, PARTE 3/5';
dims = [0 50;1 15;1 15;1 15;1 15];
definput = {'','5','-2','-2','3'};
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
definput = {'','','0.2','1','','0','0'};
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
tspan = 0: 0.01: 50; %tempo total em segundos
eta0 = [EtaIni(1,1),EtaDotIni(1,1),EtaIni(2,1),EtaDotIni(2,1)]'; %Condições iniciais do problema
[t,eta] = ode45(@(temp,y) Equacionando(temp,y,Mcursiv,Kcursiv,Ccursiv,phi), tspan, eta0);


x = phi*[eta(:,1)';eta(:,3)'];

figure
subplot (211)
plot (t,x(1,:),'r');
xlabel ('t(s)');
ylabel ('x1 [m]');
grid on
title('Deslocamento no tempo para a massa 1');
subplot (212)
plot (t,x(2,:),'k');
xlabel ('t(s)');
ylabel ('x2 [m]');
grid on
title('Deslocamento no tempo para a massa 2');




% %% Desenhando uma simulação com feedback visual de movimento de um sistema
% % equivalente
% Xcg = 2; % posição do referencial horizontal
% scrsz = get(groot,'ScreenSize'); % Coletando o tamanho da tela do computador
% % plot limits baseado no deslocamento dos corpos (cm)
% Ymin = min(x(1,:)*100)-50;
% Ymax = max(x(2,:)*100)+max(x(1,:)*100)+100;
% Xmin = 0.7;
% Xmax = 3.2;
% 
% HH = figure('Position',[ 900 300 scrsz(3)*.45 scrsz(4)*.55]); % Posiciona a imagem na tela
% 
% for i = 1:length(x(1,:)) % Plot procedural da simulação
%     Ycg1 = 0+x(1,i)*100; % Posição em centimetros do CG da massa 1
%     Ycg2 = Ycg1+abs(Ymin)+x(2,i)*100; % Posição em centimetros do CG da massa 2
%     
%     % Parametros de dimensão do corpo, arbitrários
%     L = 15; 
%     H = 0.5;
%    
%     figure(HH)
%     subplot(2,3,[1,4]) % Subplot dos corpos em movimento
%     plot(0,0) % Reseta a imagem do plot
%     
%     % Plotando as linhas de referencial 
%     plot(linspace(Xmin,Xmax),(0)*ones(1,100),'--r') 
%     hold on
%     plot(linspace(Xmin,Xmax),(abs(Ymin))*ones(1,100),'--r')
%     ylabel('Altura [cm]')
%     plot(Xcg*ones(1,100),linspace(Ymin,Ymax),'--r')
%     
%     % Linhas para representar a posição do CG das massas
%     plot(linspace(Xmin,Xmax),(Ycg1)*ones(1,100),'--k')
%     plot(linspace(Xmin,Xmax),(Ycg2)*ones(1,100),'--k')
%     
%     % massa 1
%     patch(Xcg+[H H -H -H] ,Ycg1+[-L L L -L],'g') % Gera o desenho da massa 1
%     text(Xcg-0.25,Ycg1,'Massa 1'); % Nomeia a massa
%     grid on
%     
%     plot([Xmax Xmin],[Ymin Ymin],'k','LineWidth',4) % Base onde os corpos estão fixados.
%     
%     plot(Xcg+H/2+[0 0 0 H/3 -H/3 H/3 -H/3 H/3 -H/3 H/3 -H/3 0 0 0],...
%         [Ymin, Ymin+L/4, (Ymin+L/4):(((-Ymin-L/4) +Ycg1-1.2*L)/9):Ycg1-1.2*L, Ycg1-1.2*L, Ycg1-L],'r','LineWidth',2) % Mola
%     
%     plot(Xcg-H/2+[0 0],[Ymin Ymin+1.5*L],'b',Xcg-H/2+[H/5 -H/5],[Ymin+1.5*L Ymin+1.5*L],'b',...
%         Xcg-H/2+[H/3 H/3 -H/3 -H/3],[Ycg1-3.2*L, Ycg1-1.2*L,Ycg1-1.2*L,Ycg1-3.2*L],'b',...
%         Xcg-H/2+[0 0],[ Ycg1-1.2*L,Ycg1-L],'b','LineWidth',2)    % Amortecedor
%     
%     
%     % massa 2
%     patch(Xcg+[H H -H -H] ,Ycg2+[-L L L -L],'g') % % Gera o desenho da massa 2
%     text(Xcg-0.25,Ycg2,'Massa 2'); % Nomeia a massa
%     
%     plot(Xcg+H/2+[0 0 0 H/3 -H/3 H/3 -H/3 H/3 -H/3 H/3 -H/3 0 0 0],...
%         [(Ycg1+L), (Ycg1+L)+L/4, ((Ycg1+L)+L/4):((-(Ycg1+L)-L/4 +(Ycg2-1.2*L))/9):Ycg2-1.2*L, Ycg2-1.2*L, Ycg2-L],'r','LineWidth',2) % Mola
%     
%     plot(Xcg-H/2+[0 0],[(Ycg1+L)+1*L (Ycg1+L)],'b',Xcg-H/2+[H/5 -H/5],[(Ycg1+L)+1*L (Ycg1+L)+1*L],'b',...
%         Xcg-H/2+[H/3 H/3 -H/3 -H/3],[Ycg2-2.2*L, Ycg2-1.2*L,Ycg2-1.2*L,Ycg2-2.2*L],'b',...
%         Xcg-H/2+[0 0],[ Ycg2-1.2*L,Ycg2-L],'b','LineWidth',2)    % Amortecedor
%     
%     hold off % "Libera" a imagem para poder ser resetada
%     
%     axis([Xmin Xmax Ymin Ymax ]) % Define os limites dos eixos
%     
%     % Subplot do gráfico da massa 2
%     subplot (2,3,[2,3])
%     plot (t(1:i,1),x(2,1:i),'k');
%     xlabel ('t(s)');
%     ylabel ('x2 [m]');
%     grid on
%     title('Deslocamento no tempo para a massa 2');
%     
%     % Subplot do gráfico da massa 1
%     subplot (2,3,[5,6])
%     plot (t(1:i,1),x(1,1:i),'r');
%     xlabel ('t(s)');
%     ylabel ('x1 [m]');
%     grid on
%     title('Deslocamento no tempo para a massa 1');
%     
%     % Pequena pausa para evitar que o plot trave
%     pause(10^-15);
% 
% end

% Equacionando as EDOs
function ydot = Equacionando(t,y,Mcursiv,Kcursiv,Ccursiv,phi)
F_1 = @(t) 0*cos(1*t);
F_2 = @(t) 1*cos(1*t);

Fcursiv_1 = @(t) phi(1,1)*F_1(t) + phi(2,1)*F_2(t);
Fcursiv_2 = @(t) phi(1,2)*F_1(t) + phi(2,2)*F_2(t);

ydot = zeros(4, 1);
ydot(1) = y(2);
ydot(2) = Mcursiv(1,1)^-1*Fcursiv_1(t)-(Mcursiv(1,1)^-1)*Ccursiv(1,1)*y(2)-(Mcursiv(1,1)^-1)*Kcursiv(1,1)*y(1);
ydot(3) = y(4);
ydot(4) = Mcursiv(2,2)^-1*Fcursiv_2(t)-(Mcursiv(2,2)^-1)*Ccursiv(2,2)*y(4)-(Mcursiv(2,2)^-1)*Kcursiv(2,2)*y(3);
end
