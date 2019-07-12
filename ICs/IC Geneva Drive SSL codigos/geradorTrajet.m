function Traj = geradorTrajet(X0,Xf,Vmin,thetaMin,Vmax,thetaMax,erro,randomRange,cont)
cont = cont+1;
N = 12; %amostras
desvio = 100*ones(N,1);

Traj = [ 0 0 cont];

RandCond = [Vmin + (Vmax-Vmin).*rand(N,1), thetaMin + (thetaMax-thetaMin).*rand(N,1), desvio]; %condições criadas randomicamente

for i = 1:1:N
    
    X = kickerAngSolver(RandCond(i,1),RandCond(i,2)*pi/180,X0,Xf);
    
    k = find(abs(X(1,:)-3) < 0.1);
    
    if isempty(k) == false
        
        RandCond(i,3) = abs(X(2,k(1,1)) - Xf(2,1));
        
    else
        RandCond(i,3) = 90;
    end
end

for i = 1:1:N
    
    if RandCond(i,3) < desvio
        aux = i;
        desvio = RandCond(i,3);
    end
    
end

if cont < 15
    if RandCond(aux,3) <= abs(erro) && RandCond(aux,1) > Vmin && RandCond(aux,1) < Vmax && RandCond(aux,2) > thetaMin && RandCond(aux,2) < thetaMax
        Traj = [RandCond(aux,1) RandCond(aux,2) cont];
    else
        
        VminRec = (1-randomRange)*RandCond(aux,1);
        VmaxRec = (1+randomRange)*RandCond(aux,1);
        thetaMinRec = (1-randomRange)*RandCond(aux,2);
        thetaMaxRec = (1+randomRange)*RandCond(aux,2);
        
        % %     if (1-randomRange)*RandCond(aux,1) < Vmin
        % %         VminRec = (1.05 + (1.2-1.02).*rand(1,1))*Vmin;
        % %     end
        % %
        %     if (1+randomRange)*RandCond(aux,1) > Vmax
        %         VmaxRec = (1.05 + (1.2-1.02).*rand(1,1))^-1*Vmax;
        %     end
        %
        % %     if (1-randomRange)*RandCond(aux,2) < thetaMin
        % %         thetaMinRec = (1.05 + (1.2-1.02).*rand(1,1))*thetaMin;
        % %     end
        %
        %     if (1+randomRange)*RandCond(aux,2) > thetaMax
        %         thetaMaxRec = (1.05 + (1.2-1.02).*rand(1,1))^-1*thetaMax;
        %     end
        
        Traj = geradorTrajet(X0,Xf,VminRec,VmaxRec,thetaMinRec,thetaMaxRec,erro,randomRange,cont);
        
    end
end

end