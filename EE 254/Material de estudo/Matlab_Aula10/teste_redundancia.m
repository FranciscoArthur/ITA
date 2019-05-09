function t = teste_redundancia(S,b,c,d)

% A restrição c'*x <= d será redundante se e somente se t <= 0

x = linprog(-c,S,b);
t = (c'*x - d);