%Dimensões geométricas
h = 4.9e-3; %m
l = 1; %m
b = 38.8e-3;%m

I = b*(h^3)/12;%m^4


V = b*l*h;%m^3


%Propiedades do material
E = 97e9;%Pa
rho = 7860.687092;%Kg/m^3

m = rho*V;  

%Cálculo das frequências naturais
theta1 = 10.995; theta2 = 7.853; theta3 = 4.73; theta4 = 14.137;

u1 = theta1/l;
u2 = theta2/l;
u3 = theta3/l;
u4 = theta4/l;

w1 = (u1^2)*sqrt(E*I/m);
w2 = (u2^2)*sqrt(E*I/m);
w3 = (u3^2)*sqrt(E*I/m);
w4 = (u4^2)*sqrt(E*I/m);
%w1 = 18; w2 = 50; w3 = 98; w4 = 163;

%Cálculo da amplitude em função do x


%A fim de simplificação consideraremos que C2,i = 1
C2_1 = 18.2/1.4171; C2_2 = -9.5/-1.3244; C2_3 = -2.8/-1.2141; C2_4 = 10.1/1.4125;


%

C1_1 = C2_1*(cos(theta1) - cosh(theta1))/(sinh(theta1) - sin(theta1));
C1_2 = C2_2*(cos(theta2) - cosh(theta2))/(sinh(theta2) - sin(theta2));
C1_3 = C2_3*(cos(theta3) - cosh(theta3))/(sinh(theta3) - sin(theta3));
C1_4 = C2_4*(cos(theta4) - cosh(theta4))/(sinh(theta4) - sin(theta4));

Y_1 = @(x) (C1_1*sin(u1*x) + C2_1*cos(u1*x) + C1_1*sinh(u1*x) + C2_1*cosh(u1*x));
Y_2 = @(x) (C1_2*sin(u2*x) + C2_2*cos(u2*x) + C1_2*sinh(u2*x) + C2_2*cosh(u2*x));
Y_3 = @(x) (C1_3*sin(u3*x) + C2_3*cos(u3*x) + C1_3*sinh(u3*x) + C2_3*cosh(u3*x));
Y_4 = @(x) (C1_4*sin(u4*x) + C2_4*cos(u4*x) + C1_4*sinh(u4*x) + C2_4*cosh(u4*x));


y_1 = @(x,t) (Y_1(x).*cos(w1*t));
y_2 = @(x,t) (Y_2(x).*cos(w2*t));
y_3 = @(x,t) (Y_3(x).*cos(w3*t));
y_4 = @(x,t) (Y_4(x).*cos(w4*t));

t = 0:0.01:20;

X = linspace(0,1,length(t));



plot3 (w1*ones(length(X),1)/(2*pi),X,y_1(X,t));
grid on
hold on

plot3 (w2*ones(length(X),1)/(2*pi),X,y_2(X,t));

hold on
 
plot3 (w3*ones(length(X),1)/(2*pi),X,y_3(X,t));

hold on

plot3 (w4*ones(length(X),1)/(2*pi),X,y_4(X,t));
hold off