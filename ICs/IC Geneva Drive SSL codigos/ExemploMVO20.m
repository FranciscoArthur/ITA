%% Parametros
clear all
M = 10; % massa (Kg)
K = 1;  % constante da mola (Nm)
B = 5;  % amortecimento
tempoFim = 80; % tempo de simulação
Tempo =  linspace(0,tempoFim); %cria a matriz de linha para o tempo
Xinici = -2; % posição inicial do sistema, em t = 0 (m)

%% Resolvendo analiticamente o sistema
%em casos de simulação é bem comum resolver iterativamente, resolvendo o
%sistema para cada step de tempo no loop, no entanto, será resolvido
%analiticamente para poder praticar a teoria

%Nossa lei de controle fica mXpp+cXp+kX = F, com "p" representando a
%derivada, ou seja, p é derivada primeira (x ponto) e pp derivada segunda)

%Dessa forma, teremos a seguinte equação característica:
%m*lambda^2+c*lambda+k = F, representada pelas funções caract apresentadas
%a seguir

% Cria um menu para poder escolher qual simulação fazer
Caso = menu('Qual sistema de controle você quer?','Autônomo','Proporcional','Integrativo','Derivativo',...
    'Proporcional e Derivativo', 'Proporcional e Integrativo', 'Proporcional, Integrativo e Derivativo');

%autonomo quer dizer caso = 1, proporcional caso = 2 etc

%Buscasse fazer o sistema retornar para a origem
%O caso escolhido definirá a equação característica
if Caso == 1 %autônomo
    F = 0; %Nossa variável de controle é nula na resposta autônoma
    caract = @(lamb)M*lamb^2+B*lamb+K;
    
    lambda = roots([M B K]);%roots acha as raizes de um polinomio com esses coeficientes, observe-os na equação caract.
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
elseif Caso == 2 %proporcional
    Kp = 1; %ganho do proporcional
    caract = @(lamb)M*lamb^2+B*lamb+K+Kp;
    
    lambda = roots([M B K+Kp]);%roots acha as raizes de um polinomio com esses coeficientes, observe-os na equação caract.
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
elseif Caso == 3 %integrativo
    Ki = 0.5; %ganho do integrativo
    caract = @(lamb)M*lamb^3+B*lamb^2+K*lamb+Ki;
    
    lambda = roots([M B K Ki]);
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
    lambda3 = lambda(3,1);
    
    K2 = K;
elseif Caso == 4 %derivativo
    Kd = 0.5; %ganho do derivativo
    caract = @(lamb)M*lamb^2+(B+Kd)*lamb+K;
    
    lambda = roots([M B+Kd K]);%roots acha as raizes de um polinomio com esses coeficientes, observe-os na equação caract.
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
    
elseif Caso == 5 %Proporcional e Derivativo
    Kp = 0.5;
    Kd = 5;
    caract = @(lamb)M*lamb^2+(B+Kd)*lamb+K+Kp;
    
    lambda = roots([M B+Kd K+Kp]);
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
    
elseif Caso == 6 %Proporcional e Integrativo
    Kp = 1.5;
    Ki = 0.5;
    caract = @(lamb)M*lamb^3+B*lamb^2+(K+Kp)*lamb+Ki;
    
    lambda = roots([M B K+Kp Ki]);
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
    lambda3 = lambda(3,1);
    
    K2 = K+Kp;
elseif Caso == 7 %Proporcional, Integrativo e Derivativo
    Kp = 1.5;
    Ki = 0.5;
    Kd = 5;
    
    caract = @(lamb)M*lamb^3+(B+Kd)*lamb^2+(K+Kp)*lamb+Ki;
    
    lambda = roots([M B+Kd K+Kp Ki]);
    
    lambda1 = lambda(1,1);
    lambda2 = lambda(2,1);
    lambda3 = lambda(3,1);
    
    K2 = K+Kp;
end

% agora, encontra o valor de x no tempo com base na eq caracteristica de
% cada caso

%acha as duas soluções
if Caso == 3 || Caso == 6 || Caso == 7 %casos específicos por causa do integrativo, que é do 3° grau. Não foi implementado caso de raizes iguais
    
    if imag(lambda1) == 0 && imag(lambda2) == 0 && imag(lambda3) == 0

    ABC = [ 1 1 1; lambda1 lambda2 lambda3; lambda1^2 lambda2^2 lambda3^2]\[Xinici; 0; K2*Xinici/M];
    A = ABC(1,1);
    B = ABC(2,1);
    C = ABC(3,1);
    
    funcaoX = @(t) A*exp(lambda1*t)+B*exp(lambda2*t) + C*exp(lambda3*t);
    
    else
        %Reajusta quais raizes sao imaginarias, apenas para diminuir o 
        %codigo, nao ter que fazer muitos casos
        if imag(lambda1) ~=0 && imag(lambda3) ~=0 
            
            gamma = lambda3; %variável auxiliar para segurar valor de lambda3
            lambda3 = lambda2;
            lambda2 = gamma;
            clear gamma; %apaga a variável auxiliar
            
        elseif imag(lambda2) ~=0 && imag(lambda3) ~=0
            
            gamma = lambda3; %variável auxiliar para segurar valor de lambda3
            lambda3 = lambda1;
            lambda1 = gamma;
            clear gamma; %apaga a variável auxiliar
            
        end
        
        lambda3 = real(lambda3); %para evitar erros numéricos que façam ele acreditar que é complexo
        
        ABC = [ 1 0 1; real(lambda1) imag(lambda2) lambda3; real(lambda1)^2-imag(lambda1)^2 2*real(lambda1)*imag(lambda2)^2 lambda3^2]\[Xinici; 0; K2*Xinici/M];
        A = ABC(1,1);
        B = ABC(2,1);
        C = ABC(3,1);
        
        funcaoX = @(t) exp(real(lambda1)*t).*(A*cos(imag(lambda1)*t) + B*sin(imag(lambda2)*t)) + C*exp(lambda3*t);
    end

else
    if lambda1==lambda2
        A = Xinici;
        B = -Xinici*lambda1;
        
        funcaoX = @(t) A*exp(lambda1*t)+B*t*exp(lambda1*t);%funcao que descreve a posição 
    elseif imag(lambda1)==0
          
        A = Xinici*lambda2/(lambda1-lambda2);% para isso, ele deve começar com velocidade nula
        B = Xinici*lambda1/(lambda1-lambda2);
        
        funcaoX = @(t) A*exp(lambda1*t)+B*exp(lambda2*t);%funcao que descreve a posição
    else
        A = Xinici;
        B = -real(lambda1)*Xinici/imag(lambda2);
        
        funcaoX = @(t) exp(real(lambda1)*t).*(A*cos(imag(lambda1)*t)+B*sin(imag(lambda2)*t));%funcao que descreve a posição
    end
end
%% Preparando a animação
% Define a altura do carrinho constante
Ycg = 2;

%Definindo as variáveis encontradas
X = funcaoX(Tempo); %vetor de posição no tempo

%Encontrando Velocidade e Aceleração atras de derivação numérica-> método
%das diferenças finitas

funcaoV = @(t) (funcaoX(t+10^-5)-funcaoX(t))/10^-5; %Função que descreve a velocidade
Velocidade = funcaoV(Tempo); %Vetor velocidade no tempo

funcaoA = @(t) (funcaoX(t+10^-5)-2*funcaoX(t)+funcaoX(t-10^-5))/(10^-5)^2; %Função que descreve a aceleração, diferenças finitas de segunda ordem
Aceleracao = funcaoA(Tempo); %Vetor aceleração no tempo

%% Desenhando o sistema didaticamente

%Para desenhar circulos, usaremos as funções seno e coseno, linspace cria
%um vetor de 100 elementos igualmente espaçados entre os limites
a = cos(linspace(0,2*pi));
b = sin(linspace(0,2*pi));

%Para definir o tamanho dos eixos do desenho 
Xmin = -10;
Xmax = 10;
Ymin = 0;
Ymax = 5;

%Loop para animar o desenho, plotando frame por frame
figure
for i = 1:100

    subplot(2,1,1)
    plot(Tempo(1:i),Aceleracao(1:i),'g',Tempo(1:i),Velocidade(1:i),'r',Tempo(1:i),X(1:i),'b')%varios plots
    xlabel('Tempo(s)');
    grid on
    axis([0 tempoFim -2.5 2.5])
    legend('Aceleração','Velocidade','Posição')
    title('Simulação de sistema MMA')
    
    Xcg = X(i);
    subplot(2,1,2)
  	plot(0,0) %Pequeno macete para limpar a e desenhar um novo frame no subplot
    hold all %Segura as figura para plotar tudo junto
    %Função patch pega uma equação e faz um preenchimento, ficando parecido
    %com um desenho, da uma olhada na documentação dela depois =)
    patch(Xcg+[-2 2 2 -2] ,Ycg+[1.5 1.5 -1.5 -1.5],'g') % Desenho do carrinho; Xcg e Ycg sao a posição dele no tempo, Ycg constante

    patch(0.25*a+Xcg-1.8, 0.25*b+.25,'r'); % Roda esquerda
    patch(0.25*a+Xcg+1.8, 0.25*b+.25,'r'); % Roda direita
    plot([-10 -10 20],[5 0 0],'k','LineWidth',4) % Retas que representam solo e parede

    plot([-10, -9, -9:((+9 +Xcg-4)/9):Xcg-4, Xcg-4, Xcg-2],Ycg+1+[0 0 0 .5 -.5 .5 -.5 .5 -.5 .5 -.5 0 0 0],'r','LineWidth',2) % Mola. É um conjunto de retas
    
    plot([-10 -9],Ycg-.8+[0 0],'b',[-9 -9],Ycg-.8+[.5 -.5],'b',...
        [Xcg-15, Xcg-4,Xcg-4,Xcg-15,],Ycg-.8+[.6 .6 -.6 -.6],'b',...
        [ Xcg-4,Xcg-2],Ycg-.8+[0 0],'b','LineWidth',2)    %  Amortecedor. Parece complicado, mas é so um conjunto de retas =)
    
    axis([Xmin Xmax Ymin Ymax]) %seta o tamanho dos eixos
    hold off %Libera a figura para poder dar overwrite e começar uma nova
   
    pause(1/24)%pausa para nao rodar zilhoes de frames e nao dar pra ver nada
    
           
%% Descomente essa parte e comente o comando pause (linha 229) para gravar um video
%     videoFrame(i) = getframe(gcf);
%     video = VideoWriter('SimulMMA','MPEG-4');
%     video.FrameRate = 20;
%     open(video);
%     writeVideo(video,videoFrame);
%     close(video);
end
