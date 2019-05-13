function robotTrajectoryAnimation(xtraj,ytraj,x,y,theta)

Xini = [0;0];

%rota��o
Rot =@(thet) [cos(thet) -sin(thet); sin(thet) cos(thet)];

a = cos(linspace(0,2*pi));
b = sin(linspace(0,2*pi));
X = [x;y];




for i = 1:length(X)%para ver o movimento da bola
    
    Xc = X(:,i);
    thetai = theta(i);
    
    plot(X(1,:),X(2,:),'--r')
    hold on
    plot(xtraj,ytraj,'k')
    
    
    %campo
    plot([0 0 0 -6 6],[9 -9 0 0 0],'k','LineWidth',0.5) %regi�es do campo
    hold all
    xlim([-3 3])
    ylim([-5 5])
    axis equal
    xlabel('X(m)', 'FontSize',14)
    ylabel('Y(m)', 'FontSize',14)
    set(gca, 'FontSize',14)
    grid on
    plot(a,b,'k','Linewidth',0.5) %centro
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
    
    patch(2*0.085*arot+Xini(1,1)+Xc(1,1),2*0.085*brot+Xini(2,1)+Xc(2,1),'k')
    patch(2*0.05*a+Xini(1,1)+Xc(1,1),2*0.05*b+Xini(2,1)+Xc(2,1),rgb('blue'));
  
    %% gerando anima��o
    %bal movimento+video
    
    hold off
    %plot(0,0)
    %hold on
    %videoFrame(i) = getframe(gcf);
    pause(0.07)
end

%     video = VideoWriter('SimulGolOlimpico','MPEG-4');
%     video.FrameRate = 20;
%     open(video);
%     writeVideo(video,videoFrame);
%     close(video);
