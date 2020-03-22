function X = generateLissajousTrajectory(A,B,a,b,tspan)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Função que gera os pontos de uma trajetória que segue as funções
%  de Lissajous. Feita para simulações do robô Small Size, necessita do
%  tempo de simulação e calcula o ângulo do robô com a trajetória.
%  
%     Feito em 13/05/2019
%     Autor: Arthur Azevedo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = linspace(0,tspan,300); %tempo total da trajetória

x = A*sin(a*t); % trajetória paramétrica em x
y = B*sin(b*t); % trajetória paramétrica em y


dx = A * a * cos(a * t); % derivada de x
dy = B * b * cos(b * t); % derivada de y

theta = atan2(dy,dx)-pi/2; % ângulo que o robô (SS) faz com a trajetória

X = [x',y',theta'];

end