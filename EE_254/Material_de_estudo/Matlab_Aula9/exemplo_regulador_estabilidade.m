T = 1;
Ac = [0 1;0 0];
Bc = [0;1];
[A,B] = c2dm(Ac,Bc,[],[],T,'zoh');

Q = eye(2);
R = 1;