%clear all

thetaGeneva = 15*pi/180; %�ngulo de inclina��o do robo
Xini = [0;0]; %posi��o inicial da bola
Xobjective = [3;0]; %posi��o que se deseja atingir com a bola
r = 0.043; %m %Raio da bola

%% Sem Rede Neural

% Vchute = 8; %Velocidade inicial do chute
% Wdribbler = 10000*2*pi/60; %rad/s %Velocidade que o dribbler gira a bola;
% thetaRot = 50*pi/180; %�ngulo de inclina��o do robo

%% Rede Neural

if exist('NetChuteAngulado','var') == 0
    NetChuteAngulado = TreinaSNNChuteCurvo();
end

% Outputs = net(Inputs), com Outputs = [Vchute, Wdribbler, thetaGeneva] e
% Inputs = [Xobjetivo], com Xobtjetivo = [x_objetivo; y_objetivo]

% Reposicionando o rob�

%transla��o
posTranslat =@(x) [x(1,1) - Xini(1,1);x(2,1) - Xini(2,1)]; 

Xobj_transl = posTranslat(Xobjective);

%rota��o
M =@(thet) [cos(thet) sin(thet); -sin(thet) cos(thet)];

thet = atan(Xobj_transl(2,1)/Xobj_transl(1,1));

% rob� reposicionado no (0,0), chutando na linha do gol (y = 0)
Xobj_transl_rot = abs(M(thet)*Xobj_transl);


Outputs = NetChuteAngulado(Xobj_transl_rot(1,1));

Vchute = Outputs(1,1);
Wdribbler = Outputs(2,1);
thetaRot = Outputs(3,1);
 
%%

X = kickerAngSolver(Vchute,Wdribbler,thetaGeneva,thetaRot,Xini,Xobjective);
X1 = X(1,:);
X2 = X(2,:);

%% desenhando o ambiente
figure

while 1
    for i = 1:length(X)%para ver o movimento da bola
        
        
        
        a = cos(linspace(0,2*pi));
        b = sin(linspace(0,2*pi));
        plot(0,0)
        %campo
        plot([0 0 2.5],[3 0 0],'k','LineWidth',0.5)
        hold all
        grid on
        plot([3.5 5],[0 0],'k','LineWidth',0.5)
        
        %gol
        plot([2 2 4 4],[0 1 1 0],'k','LineWidth',2) %gol
        plot([2.5 3.5],[0 0],'r--')%linha do gol
        
        %Area
        plot([2.5 2.5 3.5 3.5],[0 -0.5 -0.5 0],'k','LineWidth',4) %gol
        plot([2.5 3.5],[0 0],'r--')%linha do gol
        
        %small que chuta
        as = cos(linspace(pi-0.8671,2*pi+0.8671)+thetaRot+2*pi/2);
        bs = sin(linspace(pi-0.8671,2*pi+0.8671)+thetaRot+2*pi/2);
        patch(0.085*as+Xini(1,1),0.085*bs+Xini(2,1)-0.055,'k')
        patch(0.05*a+Xini(1,1),0.05*b+Xini(2,1)-0.055,rgb('blue'));
        
%         %small goleiro lat
%         as = cos(linspace(pi-0.8671,2*pi+0.8671));
%         bs = sin(linspace(pi-0.8671,2*pi+0.8671));
%         patch(0.085*as+2.5,0.085*bs+0.1,'k')
%         patch(0.05*a+2.5,0.05*b+0.1,rgb('yellow'));
%         
%         %small barreira lat 1
%         as = cos(linspace(pi-0.8671,2*pi+0.8671));
%         bs = sin(linspace(pi-0.8671,2*pi+0.8671));
%         patch(0.085*as+2,0.085*bs+0.07,'k')
%         patch(0.05*a+2,0.05*b+0.07,rgb('yellow'));
%         
%         %small barreira lat 2
%         as = cos(linspace(pi-0.8671,2*pi+0.8671));
%         bs = sin(linspace(pi-0.8671,2*pi+0.8671));
%         patch(0.085*as+2,0.085*bs+0.24,'k')
%         patch(0.05*a+2,0.05*b+0.24,rgb('yellow'));
%         
%         %small barreira lat 3
%         as = cos(linspace(pi-0.8671,2*pi+0.8671));
%         bs = sin(linspace(pi-0.8671,2*pi+0.8671));
%         patch(0.085*as+2,0.085*bs+0.4,'k')
%         patch(0.05*a+2,0.05*b+0.4,rgb('yellow'));
        
        %small goleiro front
        as = cos(linspace(pi-0.8671,2*pi+0.8671));
        bs = sin(linspace(pi-0.8671,2*pi+0.8671));
        patch(0.085*as+3,0.085*bs+0.5,'k')
        patch(0.05*a+3,0.05*b+0.5,rgb('yellow'));      
        
        %small barreira front 1
        as = cos(linspace(pi-0.8671,2*pi+0.8671));
        bs = sin(linspace(pi-0.8671,2*pi+0.8671));
        patch(0.085*as+3,0.085*bs+1,'k')
        patch(0.05*a+3,0.05*b+1,rgb('yellow'));
        
        %small barreira front 2
        as = cos(linspace(pi-0.8671,2*pi+0.8671));
        bs = sin(linspace(pi-0.8671,2*pi+0.8671));
        patch(0.085*as+2.5,0.085*bs+1,'k')
        patch(0.05*a+2.5,0.05*b+1,rgb('yellow'));
        
        %small barreira front 3
        as = cos(linspace(pi-0.8671,2*pi+0.8671));
        bs = sin(linspace(pi-0.8671,2*pi+0.8671));
        patch(0.085*as+3.5,0.085*bs+1,'k')
        patch(0.05*a+3.5,0.05*b+1,rgb('yellow'));
        
        % ponto que mirou
        plot(Xobjective(1,1)*ones(1,100) + linspace(-0.25,0.25),Xobjective(2,1)*ones(1,100),'--r');
        plot(Xobjective(1,1)*ones(1,100),Xobjective(2,1)*ones(1,100)+ linspace(-0.25,0.25),'--r');
        plot(Xobjective(1,1),Xobjective(2,1),'ob')
        plot(0.2*a+Xobjective(1,1),0.2*b+Xobjective(2,1),'--r');
        %% gerando anima��o
        %bal movimento+video
        
        plot(X(1,:),X(2,:));
        
        trajetoria = patch(r*a+X(1,i),r*b+X(2,i),rgb('orange'));
        hold off
        %plot(0,0)
        %hold on
        %videoFrame(i) = getframe(gcf);
        pause(0.000000000007)
        
    end
%     video = VideoWriter('SimulGolOlimpico','MPEG-4');
%     video.FrameRate = 20;
%     open(video);
%     writeVideo(video,videoFrame);
%     close(video);

end


plot(X(1,:),X(2,:))
hold on

%% fitting polinomial da curvahSurface = surf(peaks(20));


s = polyfit(X(1,:),X(2,:),4); %interpola��o do resultado
%plot(X(1,:),polyval(s,X(1,:)))

pos = @(x) s(1)*x.^4+s(2)*x.^3 + s(3)*x.^2 + s(4)*x + s(5);
% 
% Xf=@(v,theta,x) 3.097*10^-7*v^(-6.00713)*5.734*10^9*theta^(-3.7)*x.^4 + 0.0146*v^(-4.13024)*(0.4197*theta^4-31.46*theta^3-1172*theta^2+1.479*10^5*theta-5.017*10^6)/(theta^2+-6.64*theta+27.79)*x.^3+0.0058*v^(-2.27056)*(-3.629*10^-6*theta^5+0.00133*theta^4-0.2113*theta^3+15.97*theta^2-587*theta+1.058*10^4)/(theta+0.1656)*x.^2+0.0096*v^0.237667*(53.61*theta^(-1.092)-0.3465)*x;
% 
% figure
% hold on
% plot(X(1,:),pos(X(1,:)),'x')
% plot(X(1,:), Xf(Vchute,theta,X(1,:)),'--')


%% Coleta de par�metros da curva
% 
% Y = pos(X(1,:));
% 
% Ymax = max(Y);
% 
% Alc = max(X(1,:));
