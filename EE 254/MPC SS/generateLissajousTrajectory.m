function X = generateLissajousTrajectory(A,B,a,b,tspan)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Fun��o que gera os pontos de uma trajet�ria que segue as fun��es
%  de Lissajous. Feita para simula��es do rob� Small Size, necessita do
%  tempo de simula��o e calcula o �ngulo do rob� com a trajet�ria.
%  
%     Feito em 13/05/2019
%     Autor: Arthur Azevedo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = linspace(0,tspan,300); %tempo total da trajet�ria

x = A*sin(a*t); % trajet�ria param�trica em x
y = B*sin(b*t); % trajet�ria param�trica em y


dx = A * a * cos(a * t); % derivada de x
dy = B * b * cos(b * t); % derivada de y

theta = atan2(dy,dx)-pi/2; % �ngulo que o rob� (SS) faz com a trajet�ria

X = [x',y',theta'];

end