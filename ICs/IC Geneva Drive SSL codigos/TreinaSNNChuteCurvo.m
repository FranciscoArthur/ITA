function [net] = TreinaSNNChuteCurvo()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                  %
% C�digo para gerar matrix que treina a rede                                       %   
% Gera uma matrix Nx4, com N o n�mero de casos                                     %        
% Colunas da matrix: caso i: Vchute, Wdribbler, thetaRot,  Xobjetivo            %
% Em seguida treina a rede usando processamento em paralelo                        %
%                                                                                  %
% Autor: Arthur Azevedo                                                            %
% Data: 22/12/2018                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Prepara a matriz

%N�mero de casos testes de Vchute 

Vchute0 = 0.5;
VchuteF = 8;
VchutePasso = 0.1;
VchuteCasos = round((VchuteF - Vchute0)/VchutePasso)+1;

%N�mero de casos testes de Wdribbler 

Wdribbler0 = 0;
WdribblerF = 12000*2*pi/60;
WdribblerPasso = 500*2*pi/60;
WdribblerCasos = round((WdribblerF - Wdribbler0)/WdribblerPasso)+1;

%N�mero de casos testes de thetaRot 

thetaRot0 = 0;
thetaRotF = 90*pi/180;
thetaRotPasso = 1*pi/180;
thetaRotCasos = round((thetaRotF - thetaRot0)/thetaRotPasso)+1;

%N�mero de casos testes de thetaGeneva, S�o 2 casos por padr�o 
 
% thetaGenevaCasos = 1; % Retirado do projeto

%Por fim
N = VchuteCasos*WdribblerCasos*thetaRotCasos;

%Preparando a matriz

TreinaPosicGenevaAux = zeros(N,4);
tic
i = 1;
for Vchute = Vchute0:VchutePasso:VchuteF
    for Wdribbler = Wdribbler0:WdribblerPasso:WdribblerF
        %for thetaGeneva = 10*pi/180:10*pi/180:20*pi/180
            for thetaRot = thetaRot0:thetaRotPasso:thetaRotF
                
                X = kickerAngSolver(Vchute,Wdribbler,deg2rad(15),thetaRot,[0;0],[5;0]);

                k = find(X(2,:) < 0);
                
                if isempty(k) == false && k(1,1) > 2
                    Xf = (X(1,k(1,1)-1)+X(1,k(1,1)))/2;
                    TreinaPosicGenevaAux(i,:) = [Vchute, Wdribbler, thetaRot, Xf]; % Importante! ordem dos elementos no vetor
                    i = i+1;
                end
                
            end
       % end
    end
end

% Retira os casos n�o usados na matriz

CasosNulos = find(abs(TreinaPosicGenevaAux(:,1)) < 10^-5);
if isempty(CasosNulos) ~=1
    LinhasEfetivas = CasosNulos(1,1);
    
    TreinaPosicGeneva = zeros(LinhasEfetivas-1,4);
    
    for i = 1:1:LinhasEfetivas-1
        TreinaPosicGeneva(i,:) = TreinaPosicGenevaAux(i,:);
    end
end

toc

% Matriz de treino da rede

InputTrainSNN = (TreinaPosicGeneva(:,end))';
TargetTrainSNN = (TreinaPosicGeneva(:,1:1:end-1))';

% Define a SNN

net = feedforwardnet(30);
net = configure(net,InputTrainSNN,TargetTrainSNN);

% Treina a SNN
gcp;

net = train(net,InputTrainSNN,TargetTrainSNN,'useParallel','yes');

