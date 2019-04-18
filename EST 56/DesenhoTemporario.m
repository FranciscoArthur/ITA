% Desenhando uma simulação com feedback visual de movimento de um sistema
% equivalente
Xcg = 2; % posição do referencial horizontal
scrsz = get(groot,'ScreenSize'); % Coletando o tamanho da tela do computador
% plot limits baseado no deslocamento dos corpos (cm)
Ymin = min(x(1,:)*100)-50;
Ymax = max(x(2,:)*100)+max(x(1,:)*100)+100;
Xmin = 0.7;
Xmax = 3.2;

HH = figure('Position',[ 900 300 scrsz(3)*.45 scrsz(4)*.55]); % Posiciona a imagem na tela
 
for i = 1:length(x) % Plot procedural da simulação
    Ycg1 = 0+x(1,i)*100; % Posição em centimetros do CG da massa 1
    Ycg2 = Ycg1+abs(Ymin)+x(2,i)*100; % Posição em centimetros do CG da massa 2
    
    % Parametros de dimensão do corpo, arbitrários
    L = 15; 
    H = 0.5;
    
    
    subplot(2,3,[1,4]) % Subplot dos corpos em movimento
    plot(0,0) % Reseta a imagem do plot
    
    % Plotando as linhas de referencial 
    plot(linspace(Xmin,Xmax),(0)*ones(1,100),'--r') 
    hold all
    plot(linspace(Xmin,Xmax),(abs(Ymin))*ones(1,100),'--r')
    xlabel('Altura [cm]')
    plot(Xcg*ones(1,100),linspace(Ymin,Ymax),'--r')
    
    % Linhas para representar a posição do CG das massas
    plot(linspace(Xmin,Xmax),(Ycg1)*ones(1,100),'--k')
    plot(linspace(Xmin,Xmax),(Ycg2)*ones(1,100),'--k')
    
    % massa 1
    patch(Xcg+[H H -H -H] ,Ycg1+[-L L L -L],'g') % Gera o desenho da massa 1
    text(Xcg-0.25,Ycg1,'Massa 1'); % Nomeia a massa
    grid on
    
    plot([Xmax Xmin],[Ymin Ymin],'k','LineWidth',4) % Base onde os corpos estão fixados.
    
    plot(Xcg+H/2+[0 0 0 H/3 -H/3 H/3 -H/3 H/3 -H/3 H/3 -H/3 0 0 0],...
        [Ymin, Ymin+L/4, (Ymin+L/4):(((-Ymin-L/4) +Ycg1-1.2*L)/9):Ycg1-1.2*L, Ycg1-1.2*L, Ycg1-L],'r','LineWidth',2) % Mola
    
    plot(Xcg-H/2+[0 0],[Ymin Ymin+1.5*L],'b',Xcg-H/2+[H/5 -H/5],[Ymin+1.5*L Ymin+1.5*L],'b',...
        Xcg-H/2+[H/3 H/3 -H/3 -H/3],[Ycg1-3.2*L, Ycg1-1.2*L,Ycg1-1.2*L,Ycg1-3.2*L],'b',...
        Xcg-H/2+[0 0],[ Ycg1-1.2*L,Ycg1-L],'b','LineWidth',2)    % Amortecedor
    
    
    % massa 2
    patch(Xcg+[H H -H -H] ,Ycg2+[-L L L -L],'g') % % Gera o desenho da massa 2
    text(Xcg-0.25,Ycg2,'Massa 2'); % Nomeia a massa
    
    plot(Xcg+H/2+[0 0 0 H/3 -H/3 H/3 -H/3 H/3 -H/3 H/3 -H/3 0 0 0],...
        [(Ycg1+L), (Ycg1+L)+L/4, ((Ycg1+L)+L/4):((-(Ycg1+L)-L/4 +(Ycg2-1.2*L))/9):Ycg2-1.2*L, Ycg2-1.2*L, Ycg2-L],'r','LineWidth',2) % Mola
    
    plot(Xcg-H/2+[0 0],[(Ycg1+L)+1*L (Ycg1+L)],'b',Xcg-H/2+[H/5 -H/5],[(Ycg1+L)+1*L (Ycg1+L)+1*L],'b',...
        Xcg-H/2+[H/3 H/3 -H/3 -H/3],[Ycg2-2.2*L, Ycg2-1.2*L,Ycg2-1.2*L,Ycg2-2.2*L],'b',...
        Xcg-H/2+[0 0],[ Ycg2-1.2*L,Ycg2-L],'b','LineWidth',2)    % Amortecedor
    
    hold off % "Libera" a imagem para poder ser resetada
    
    axis([Xmin Xmax Ymin Ymax ]) % Define os limites dos eixos
    
    % Subplot do gráfico da massa 2
    subplot (2,3,[2,3])
    plot (t(1:i,1),x(2,1:i),'k');
    xlabel ('t(s)');
    ylabel ('x2 [m]');
    grid on
    title('Deslocamento no tempo para a massa 2');
    
    % Subplot do gráfico da massa 1
    subplot (2,3,[5,6])
    plot (t(1:i,1),x(1,1:i),'r');
    xlabel ('t(s)');
    ylabel ('x1 [m]');
    grid on
    title('Deslocamento no tempo para a massa 1');
    
    % Pequena pausa para evitar que o plot trave
    pause(10^-15);

end