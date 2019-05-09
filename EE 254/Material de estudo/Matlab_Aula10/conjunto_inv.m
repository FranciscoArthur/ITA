function [Sf,bf] = conjunto_inv(A,Sx,bx,max_iter)

% [Sf,bf] = conjunto_inv(A,Sx,bx,max_iter)

r = size(Sx); % No. restri��es

S = Sx;
b = bx;
flag_redund = 0;
i = 1;
while ( (i <= max_iter) && (flag_redund == 0) )
    disp(['Itera��o ' num2str(i) ' / ' num2str(max_iter)])
    flag_redund = 1; % Se esse flag n�o for mudado, o algoritmo ser� encerrado 
                     % pois ter� havido redund�ncia de todas as restri��es
    SxA = Sx*(A^i);
    for j = 1:r % Teste de redund�ncia de cada restri��o
        c = SxA(j,:)';
        d = bx(j);
        % A restri��o ser� redundante se e somente se t(j) <= 0
        t(j) = teste_redundancia(S,b,c,d);
        if t(j) > 0 % Se a restri��o n�o for redundante
            flag_redund = 0; % Pelo menos uma restri��o n�o foi redundante
            % Agrega-se essa restri��o �s anteriores
            S = [S;c']; b = [b;d];
        end
    end
    i = i + 1;
end

if (flag_redund == 0) % O algoritmo foi encerrado sem que houvesse redund�ncia
    disp('N�o foi poss�vel caracterizar o maior conjunto invariante')
    Sf = []; bf = [];
else
    Sf = S; bf = b;
end