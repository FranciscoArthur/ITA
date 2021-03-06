function robotTrajectoryAnimation(xtraj,ytraj,x,y,theta)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Fun��o que gera uma anima��o da simula��o do Rob� Small Size 
%  no campo de Div. B. Feito para projeto de controlador, 
%  recebe a trajetoria de refer�ncia e a trajetoria real.
%  
%     Leva em conta a posi��o do rob� e o �ngulo dele com a trajet�ria.
%  
%     Feito em 13/05/2019
%     Autor: Arthur Azevedo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Xini = [0;0];

%rota��o
Rot =@(thet) [cos(thet) -sin(thet); sin(thet) cos(thet)];

a = cos(linspace(0,2*pi));
b = sin(linspace(0,2*pi));
X = [x,y];

limx = max(X(:,1))*1.2;
limy = max(X(:,2))*1.2;

aceleracao = 7;%acelerado em 10x
j = 1;
for i = 1:aceleracao:length(x)
    xRedu(j,1) = x(i);
    j = j+1;
end

j=1;
for i = 1:aceleracao:length(y)
    yRedu(j,1) = y(i);
    j = j+1;
end

j=1;
for i = 1:aceleracao:length(theta)
    thetaRedu(j,1) = theta(i);
    j = j+1;
end

X = [xRedu,yRedu];

for i = 1:length(X)%para ver o movimento da bola
    
    Xc = X(i,:);
    thetai = thetaRedu(i);
    
    plot(X(:,1),X(:,2),'--r')% trajet�ria do controle
    hold on
    plot(xtraj,ytraj,'k')% trajet�ria de refer�ncia
    
    
    %campo
    plot([0 0 0 -6 6],[9 -9 0 0 0],'k','LineWidth',0.5) %regi�es do campo
    hold all
    xlim([-limx limx])
    ylim([-limy limy])
    axis equal
    xlabel('X(m)', 'FontSize',14)
    ylabel('Y(m)', 'FontSize',14)
    title('Trajet�ria do rob� sobre o campo','FontSize',14)
    set(gca, 'FontSize',14)
    grid minor
    plot(a,b,'k','Linewidth',0.2) %centro
    plot([6 6 -6 -6 6],[9 -9 -9 9 9],'k','LineWidth',0.5) %limites do campo

    %gol
    plot([2 2 -2 -2],[-9 -8 -8 -9],'k','LineWidth',2) %gol
    plot([2 2 -2 -2],[9 8 8 9],'k','LineWidth',2) %gol advers�rio
    
    %small 
    as = cos(linspace(pi-0.8671,2*pi+0.8671));
    bs = sin(linspace(pi-0.8671,2*pi+0.8671));
    
    ABrot = Rot(thetai)*[as;bs];
    arot = ABrot(1,:);
    brot = ABrot(2,:);
    
    patch(2*0.085*arot+Xini(1,1)+Xc(1,1),2*0.085*brot+Xini(2,1)+Xc(1,2),'k')
    patch(2*0.05*a+Xini(1,1)+Xc(1,1),2*0.05*b+Xini(2,1)+Xc(1,2),rgb('blue'));
  
    %% gerando anima��o
    % movimento+video
    
    hold off

    videoFrame(i) = getframe(gcf);
    %pause(0.000000000007/length(X))
end

    video = VideoWriter('SimulSSLissajousTrajectory','MPEG-4');
    video.FrameRate = 120;
    open(video);
    writeVideo(video,videoFrame);
    close(video);
