function trajetoria = kickerAngSolver(Vchute,Wdribbler,thetaGeneva,thetaRot,Xini,Xobjective)


%% Definição de parametros gerais

m = 0.046; %kg %Massa da bola
g = 9.81; %m/s² %Gravidade
r = 0.043; %m %Raio da bola
%Vchute = 6.08; % m/s %Velocidade de chute da bola; usar para definur a parábola
%Wdribbler = 1000*2*pi/60; %rad/s %Velocidade que o dribbler gira a bola;
%theta = 58.1*(pi/180); %Angulo do chute, equivale ao angulo da engrenagem + angulação do robo no chute; angulos da engrenagem: theta e theta/2
I = (1/0.5805-1)*m*r^2; %Momento de inercia da bola, correção com artigo robocup
%bizu: Vchute = 6.16 e theta = 58.1°

%% Definição de parâmetros para iteração

TempoTot = 1.2; %s %Tempo total do movimento da bola
deltaT = 1*10^-2; %s %Intervalo de tempo entre dois steps da iteração
K = TempoTot/deltaT; %Quantidade de steps da iteração

%% Definição dos vetores para cada variável

%Linha 1 equivale a coordenada em x, 2 a coordenada em y, e as Colunas
%equivalem a cada step da iteração. Como o CoefAtrito nao tem direção x e
%y, utilizou-se apenas 1 linha
Xini0 = [0;0];
CoefAtrit = zeros(1,K); % Coeficiente de atrito de rolamento e deslizamento, muda com a velocidade
Vcom = zeros(2,K); % Velocidade do centro de massa (m/s)
W = zeros(2,K); % Velocidade angular da bola (rad/s)
Vpc = zeros(2,K); % Velocidade do ponto de contato bola-carpete (m/s)
Fat = zeros(2,K); % Força de atrito do solo na bola (N)
T = zeros(2,K); % Torque que o atritio causa na bola (Nm)
acom = zeros(2,K); % Aceleração do centro de massa (m/s²)
X = zeros(2,K); % Posição no tempo do centro de massa da bola (m)
Tempo = zeros(1,K); %Tempo (s)

%% Definição das condições iniciais

Vcom(:,1) = Vchute.*[sin(thetaGeneva); cos(thetaGeneva)]; %%bola sai com a velocidade que foi chutada
W(:,1) = Wdribbler.*[sin(pi/2); cos(pi/2)]; %Rotação inicial da bola é em apenas 1 eixo, igual a rotação do dribbler
X(:,1) = Xini0;
TempoInici = 0; %s %Tempo inicial

%% Processo iterativo

for k = 1:K-1 
    
    
    
    if sqrt(Vcom(1,k)^2+Vcom(2,k)^2)>0.5805*sqrt(Vcom(1,1)^2+Vcom(2,1)^2)
        CoefAtrit(1,k) = 10/g; %Retirado do artigo da robocup
        Fat(:,k) = -(CoefAtrit(1,k)*m*g/sqrt((Vcom(1,k))^2+(Vcom(2,k))^2)).*[Vcom(1,k); Vcom(2,k)];
        acom(:,k) = Fat(:,k)/m;
        
        %agora determinar Vk+1,Wk+1 e Xk+1 para proxima iteração
        
        Vcom(:,k+1) = Vcom(:,k) + acom(:,k)*deltaT; %verdade para intervalo de tempo pequeno tendendo a 0
        W(:,k+1) = W(:,k) -(5/(2*r))*(Vcom(:,k+1)-Vcom(:,k)); %Retirado do artigo da robocup
        X(:,k+1) = X(:,k) + Vcom(:,k).*deltaT+acom(:,k).*deltaT^2/2;
        Tempo(1,k+1) = Tempo(1,k)+deltaT;
        
    else
        CoefAtrit(1,k) = 10/g; %Retirado do artigo da robocup
        
        Vpc(:,k) = Vcom(:,k)-r*[-W(2,k); W(1,k)]; %esse vetor com W equivale a W vetorial versor k da direção Z
        Fat(:,k) = -(CoefAtrit(1,k)*m*g/(sqrt((Vcom(1,k)+r*W(2,k))^2+(Vcom(2,k)-r*W(1,k))^2))).*[Vcom(1,k)+r*W(2,k); Vcom(2,k) - r*W(1,k)];
        
        acom(:,k) = Fat(:,k)/m;
        T(:,k) = r.*[-Fat(2,k); Fat(1,k)];
        
        %agora determinar Vk+1,Wk+1 e Xk+1 para proxima iteração
        
        Vcom(:,k+1) = Vcom(:,k) - acom(:,k)*deltaT; %verdade para intervalo de tempo pequeno tendendo a 0
        W(:,k+1) = W(:,k) + (1/I)*T(:,k)*deltaT;
        X(:,k+1) = X(:,k) + Vcom(:,k).*deltaT+acom(:,k).*deltaT^2/2;
        Tempo(1,k+1) = Tempo(1,k)+deltaT;
    end
    
    
        if X(2,k+1) < -1 %|| (X(1,k+1) > 4 
            break
        end
end

%% Rotacionando o Robo

%rotação
M =@(thet) [cos(thet) sin(thet); -sin(thet) cos(thet)];

for i = 1:length(X)
    X(:,i) = M(thetaRot)*X(:,i);
end

%% reposicionando a curva

x0 = Xini;
thet = -atan((Xobjective(2,1) - x0(2,1))/(Xobjective(1,1) - x0(1,1)));

%translação
posTranslat =@(x) [x(1,:) + x0(1,:);x(2,:) + x0(2,:)]; 



for i = 1:length(X)
    X(:,i) = M(thet)*X(:,i);
    X(:,i) = posTranslat(X(:,i));
end


trajetoria = X;

end
