Ac = [-0.003 0.039 0 -0.322;
      -0.065 -0.319 7.74 0;
      0.0201 -0.101 -0.429 0;
      0 0 1 0];
Bc = [0.01 1; -0.18 -0.04;-1.16 0.598;0 0];
C = [1 0 0 0;0 -1 0 7.74];
D = zeros(2,2);

T = 0.3; 

[A,B] = c2dm(Ac,Bc,C,D,T,'zoh');