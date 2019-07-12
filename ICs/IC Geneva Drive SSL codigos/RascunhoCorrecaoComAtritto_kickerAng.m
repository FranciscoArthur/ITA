clear all
%% Defini��o de parametros gerais

m = 0.046; %kg %Massa da bola
g = 9.81; %m/s� %Gravidade
r = 0.043; %m %Raio da bola
Vchute = 8; % m/s %Velocidade de chute da bola
Wdribbler = 15000*2*pi/60; %rad/s %Velocidade que o dribbler gira a bola
theta = 10*(pi/180); %Angulo do chute, equivale ao angulo da engrenagem 
I = (1/0.5805-1)*m*r; %Momento de inercia da bola, corre��o com artigo robocup

%% Defini��o de par�metros para itera��o

TempoTot = 11; %s %Tempo total do movimento da bola
deltaT = 10^-5; %s %Intervalo de tempo entre dois steps da itera��o
K = TempoTot/deltaT; %Quantidade de steps da itera��o

%% Defini��o dos vetores para cada vari�vel

%Linha 1 equivale a coordenada em x, 2 a coordenada em y, e as Colunas
%equivalem a cada step da itera��o. Como o CoefAtrito nao tem dire��o x e
%y, utilizou-se apenas 1 linha

CoefAtrit = zeros(1,K); % Coeficiente de atrito de rolamento e deslizamento, muda com a velocidade
Vcom = zeros(2,K); % Velocidade do centro de massa (m/s)
W = zeros(2,K); % Velocidade angular da bola (rad/s)
Vpc = zeros(2,K); % Velocidade do ponto de contato bola-carpete (m/s)
Fat = zeros(2,K); % For�a de atrito do solo na bola (N)
T = zeros(2,K); % Torque que o atritio causa na bola (Nm)
acom = zeros(2,K); % Acelera��o do centro de massa (m/s�)
X = zeros(2,K); % Posi��o no tempo do centro de massa da bola (m)
Tempo = zeros(1,K); %Tempo (s)

%% Defini��o das condi��es iniciais

Vcom(:,1) = Vchute.*[cos(theta); sin(theta)]; %%bola sai com a velocidade que foi chutada
W(:,1) = Wdribbler.*[cos(pi); sin(pi)]; %Rota��o inicial da bola � em apenas 1 eixo, igual a rota��o do dribbler
X(:,1) = [ 0; 0]; %Bola come�a na origem
TempoInici = 0; %s %Tempo inicial 

%% Processo iterativo
tic
for k = 1:K-1

    Vpc(:,k) = Vcom(:,k)-r*[-W(2,k); W(1,k)]; %esse vetor com W equivale a W vetorial versor k da dire��o Z
    
    if sqrt(Vcom(1,k)^2+Vcom(2,k)^2)>0.5805*sqrt(Vcom(1,1)^2+Vcom(2,1)^2)
        CoefAtrit(1,k) = 3.47/g; %Retirado do artigo da robocup
  
    else 
        CoefAtrit(1,k) = 0.305/g; %Retirado do artigo da robocup
    end
    
    Fat(:,k) = -(CoefAtrit(1,k)*m*g/sqrt((Vcom(1,k)+r*W(2,k))^2+(Vcom(2,k)-r*W(1,k))^2)).*[Vcom(1,k)+r*W(2,k); Vcom(2,k) - r*W(1,k)];
    
    acom(:,k) = (m^-1).*Fat(:,k);
    T(:,k) = -r.*[-Fat(2,k); Fat(1,k)];
    
    %agora determinar Vk+1,Wk+1 e Xk+1 para proxima itera��o
    
    Vcom(:,k+1) = Vcom(:,k) + acom(:,k)*deltaT; %verdade para intervalo de tempo pequeno tendendo a 0
    W(:,k+1) = W(:,k) + (1/I)*T(:,k)*deltaT;
    X(:,k+1) = X(:,k) + Vcom(:,k).*deltaT+acom(:,k).*deltaT^2/2;
    Tempo(1,k+1) = Tempo(1,k)+deltaT;
    
    if (X(2,k+1) < -0.5) || (X(1,k+1) > 4)
        break
    end
end
toc
plot(X(1,:),X(2,:))
%% plot

%subplot(2,2,[1,3]) plot da simula��o