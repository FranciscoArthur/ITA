%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                  %
% Código para gerar matrix que treina a rede                                       %   
% Gera uma matrix Nx6, com N o número de casos                                     %        
% Colunas da matrix: caso i: Vchute, Wdribbler, thetaGeneva, thetaRot, Xobjetivo   %  
%                                                                                  %
% Autor: Arthur Azevedo                                                            %
% Data: 22/12/2018                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Prepara a matriz

%Número de casos testes de Vchute 

Vchute0 = 2;
VchuteF = 8;
VchutePasso = 0.5;
VchuteCasos = (VchuteF - Vchute0)/VchutePasso+1;

%Número de casos testes de Wdribbler 

Wdribbler0 = 0;
WdribblerF = 10000;
WdribblerPasso = 500;
WdribblerCasos = (WdribblerF - Wdribbler0)/WdribblerPasso+1;

%Número de casos testes de thetaGeneva, São 2 casos por padrão 

thetaGenevaCasos = 2;

%Número de casos testes de thetaRot 

thetaRot0 = 0;
thetaRotF = 70*pi/180;
thetaRotPasso = 5*pi/180;
thetaRotCasos = (thetaRotF - thetaRot0)/thetaRotPasso+1;

%Por fim
N = VchuteCasos*WdribblerCasos*thetaGenevaCasos*thetaRotCasos

%Preparando a matriz

TreinaPosicGenevaAux = zeros(N,5);
tic
i = 1;
for Vchute = Vchute0:VchutePasso:VchuteF
    for Wdribbler = Wdribbler0:WdribblerPasso:WdribblerF
        for thetaGeneva = 10*pi/180:10*pi/180:20*pi/180
            for thetaRot = thetaRot0:thetaRotPasso:thetaRotF
                
                X = kickerAngSolver(Vchute,Wdribbler,thetaGeneva,thetaRot,[0;0],[3;0]);

                k = find(X(2,:) < 0);
                
                if isempty(k) == false && k(1,1) > 2
                    Xf = (X(1,k(1,1)-1)+X(1,k(1,1)))/2;
                    TreinaPosicGenevaAux(i,:) = [Vchute, Wdribbler, thetaGeneva*180/pi, thetaRot*180/pi, Xf];
                    i = i+1;
                end
                
            end
        end
    end
end

% Retira os casos não usados na matriz

CasosNulos = find(TreinaPosicGenevaAux(:,1) == 0);

LinhasEfetivas = CasosNulos(1,1);

TreinaPosicGeneva = zeros(LinhasEfetivas-1,5);

for i = 1:1:LinhasEfetivas-1
    TreinaPosicGeneva(i,:) = TreinaPosicGenevaAux(i,:);
end

toc

