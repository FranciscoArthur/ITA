function [Jmin,Jmax]=busca_J(M,J)

if M==0
    lista_J=[0 0.2 0.4 0.6 0.8 1];
elseif M==0.03
    lista_J=[0.13 0.15 0.2 0.25 0.3];
elseif M==0.06
    lista_J=[0.25 0.3 0.35 0.4 0.45 0.5 0.55];
elseif M==0.1
    lista_J=[0.4 0.45 0.5 0.55 0.6 0.65 0.7];
elseif M==0.15
    lista_J=[0.6 0.7 0.8 0.9 1 1.1 1.2];
elseif M==0.2
    lista_J=[0.7 0.8 0.9 1 1.2 1.4 1.6 1.8 2];
elseif M==0.3
    lista_J=[1.2 1.4 1.6 1.8 2 2.2];
elseif M==0.4
    lista_J=[1.5 1.6 1.8 2 2.2 2.4 2.6 2.8];
elseif M==0.45
    lista_J=[1.8 2 2.2 2.4 2.6 2.8 2.9];
elseif M==0.5
    lista_J=[2.1 2.3 2.5 2.7 2.9 3.1];
end

n=numel(lista_J);
i=find(lista_J>J,1); % busca o 1o indice maior que J
if i==1 % se for o primeiro
    Jmin=lista_J(1); Jmax=lista_J(2);
elseif isempty(i) % J é maior que qualquer elemento na lista
    Jmin=lista_J(n-1); Jmax=lista_J(n);
else % se i=2...10
    Jmin=lista_J(i-1); Jmax=lista_J(i);
end
    



        