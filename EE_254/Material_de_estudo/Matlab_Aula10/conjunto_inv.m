function [Sf,bf] = conjunto_inv(A,Sx,bx,max_iter)

% [Sf,bf] = conjunto_inv(A,Sx,bx,max_iter)

r = size(Sx); % No. restrições

S = Sx;
b = bx;
flag_redund = 0;
i = 1;
while ( (i <= max_iter) && (flag_redund == 0) )
    disp(['Iteração ' num2str(i) ' / ' num2str(max_iter)])
    flag_redund = 1; % Se esse flag não for mudado, o algoritmo será encerrado 
                     % pois terá havido redundância de todas as restrições
    SxA = Sx*(A^i);
    for j = 1:r % Teste de redundância de cada restrição
        c = SxA(j,:)';
        d = bx(j);
        % A restrição será redundante se e somente se t(j) <= 0
        t(j) = teste_redundancia(S,b,c,d);
        if t(j) > 0 % Se a restrição não for redundante
            flag_redund = 0; % Pelo menos uma restrição não foi redundante
            % Agrega-se essa restrição às anteriores
            S = [S;c']; b = [b;d];
        end
    end
    i = i + 1;
end

if (flag_redund == 0) % O algoritmo foi encerrado sem que houvesse redundância
    disp('Não foi possível caracterizar o maior conjunto invariante')
    Sf = []; bf = [];
else
    Sf = S; bf = b;
end