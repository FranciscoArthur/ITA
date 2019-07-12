%% Parâmetros

E = 72*10^9; %(Pa) Modulo de elasticidade do Al 5054-H32

b1 = 0.00771; %(m) largura da viga do quadrante 1

b2 = 0.00781; %(m) largura da viga do quadrante 2

b3 = 0.00808; %(m) largura da viga do quadrante 3

b4 = 0.00815; %(m) largura da viga do quadrante 4

h = (4.76+3.5/2)*10^-3; %(m) espessura da chapa

x1 = (6+3.5/2)*10^-3; %(m) distância da ponta mais próxima do SG ao pino do pé do quadrante 1

x2 = (11.83+3.5/2)*10^-3; %(m) distância da ponta mais próxima do SG ao pino do pé do quadrante 2

x3 = (9.20+3.5/2)*10^-3; %(m) distância da ponta mais próxima do SG ao pino do pé do quadrante 3

x4 = (9.60+3.5/2)*10^-3; %(m) distância da ponta mais próxima do SG ao pino do pé do quadrante 4

Xp = [0.022 -0.048 -0.048 0.022; 0.065 0.065 -0.065 -0.065]; %coordenadas dos pinos do pé, Xp = [ x1 x2 x3 x4; y1 y2 y3 y4]

deltaX = 0.0085; %(m) comprimento do SG

%% Calculos

I = [b1 b2 b3 b4]'*h^3/12;

X = [x1 x2 x3 x4]';

deform = [ Beam1 Beam2 Beam3 Beam4]'*10^-6;

F = 2*I*E.*deform./(10*h*(X+deltaX/2));

ForceCalc = (F(1,:)+F(2,:)+F(3,:)+F(4,:));

Xcop = (F(1,:)+F(2,:)+F(3,:)+F(4,:)).^-1.*(Xp*F);

Xcop = Xcop*10000;

imdata = imread('Chuteira2D.png');

image([-50 25], [70 -70],imdata); %aqui selecionar o tamanho do pé, em centimetros

hold on;
set(gca,'ydir','normal');
axis equal
grid on
xlabel('CoP x position (mm)');
ylabel('CoP y position (mm)');
plot(Xcop(1,:), Xcop(2,:),'r*');
text(Xcop(1,1:1:6), Xcop(2,1:1:6)+4,{'1','2','3','4','5','6'});

hold off

figure
plot(1:1:13,abs(ForceCalc-ForceN')./ForceN'*100,'*r')
title('Error in the total force applied')
xlabel('Number of the measure');
ylabel('Absolute error (%)');
grid on
