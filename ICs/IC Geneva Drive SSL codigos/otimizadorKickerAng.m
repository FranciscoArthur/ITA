function parametros = otimizadorKickerAng(VchuteMAX,thetaMAX, Xorig, Xfinal, erro)
param.theta = 10^6;
param.Vchute = 0;
param.Ymax = 10^6;
cont = 0;
paramAux = struct('theta',0,'Vchute',0,'Ymax',0);
%% Definição de parâmetros para iteração

tic
for Vchute = 1:(VchuteMAX/300):VchuteMAX
    
    for theta = 5*pi/180:(thetaMAX*pi/180)/300:thetaMAX*pi/180
        
        
        X = kickerAngSolver(Vchute,theta,Xorig,Xfinal);
        
        
        %% fitting polinomial da curva
        
        s = polyfit(X(1,:),X(2,:),4); %interpolação do resultado
        
%        pos = @(x) s(1)*x.^4+s(2)*x.^3 + s(3)*x.^2 + s(4)*x + s(5);
        
        
        %% Coleta de parâmetros da curva
        %penalizar altura
        if abs(abs(polyval(s,Xfinal(1,1)) - abs(Xfinal(2,1))) <= erro
         paramAux.theta = theta
         paramAux.Vchute = Vchute
         paramAux.Ymax = max(pos(X(1,:)))

            if (paramAux.theta*180/pi >= 45 && paramAux.theta <= param.theta && paramAux.Vchute >= param.Vchute&& paramAux.Ymax <= param.Ymax && paramAux.Ymax > 0.5)
 
                
                param.theta = paramAux.theta;
                param.Vchute = paramAux.Vchute;
                param.Ymax = paramAux.Ymax;
                cont = 1;
            end
            
        end
        
        
        
    end
end


%% seleção dos melhores valores
if cont == 1
    
    parametros = [ param.theta*180/pi; param.Vchute];

else
    
    disp('sem solução possível')

end
toc
end