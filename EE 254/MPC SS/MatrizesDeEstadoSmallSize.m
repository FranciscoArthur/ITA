function [A,B] = MatrizesDeEstadoSmallSize(Wr)
wr = Wr(end);
Ac = [0  wr 0;
     -wr 0  0;
      0  0  0];
     
     
Bc = -eye(3);
C = eye(3);
D = zeros(3,3);

% Discretizacao
T = 0.005;
[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');