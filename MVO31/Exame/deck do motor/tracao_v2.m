function [net_thrust, Mach, J, Cp, eta_net, CT_net_final] = tracao_v2(V,H,PRPM,SHP,ta)

% Instru��es:
% Entradas:
%   V=100;                                  % velocidade verdadeira (knots)
%   H=10000;                                % altitude voo (ft)
%   PRPM=1300;                              % RPM da helice (propeller)
%   SHP=1800;                               % Potencia de eixo em HP
%   ta=288.15;                              % temperatura ambiente em K
% Sa�das:
% net_thrust  --> tra��o l�quida de um motor (lbf)
% Mach (adimensional)
% J --> raz�o de avan�o da h�lice (adimensional)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% COMENTE ESTE TRECHO AO UTILIZAR O M-FILE COMO FUN��O %%%%%%%%%%%%%%
% clc
% clear all
% close all
% 
% SHP=1300;                                % Potencia de eixo em HP
% PRPM=1300;                               % RPM da helice (propeller)
% V=290;                                   % velocidade verdadeira (knots)
% H=15000;                                 % altitude voo (ft)
% ta=258.4;                                % temperatura ambiente em K
% Para estas condi��es, o empuxo gerado pelo motor dever� ser de 1302 lb,
% de acordo com o exemplo de c�lculo do fabricante (Table III, p�g. 20 do
% documento, i.e., p�g. 55 do arquivo pdf). Esta condi��o serve de check
% point para a rotina.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


flag_plot=0; % flag para visualizar plots das diversas interp's feitas

d_prop=10.5;                             % Diametro da h�lice (ft) 
J=V*0.51444/(PRPM*(1/60)*d_prop*0.3048); % raz�o de avan�o da helice  

Disa = ta - zp2ta(H); % �C ou K
ro=zp2ro(0); % kg/m^3                       % densidade nivel do mar (ISA)
pa=zp2pa(H); % mbar
roi = pa/(2.8705*ta); % kg/m^3
Vsom = (1.4*287.05*ta)^0.5; % m/s
Mach = V*0.51444/Vsom; % convertendo V de kt -> m/s 

Cp=SHP*(ro/roi)/((2000*(PRPM/1000)^3 ... % Power coefficient
                       *(d_prop/10)^5));

% Lista de Machs dispon�veis para interpola��o
lista_mach=[0 0.030 0.060 0.1 0.15 0.20 0.30 0.4 0.45 0.5];

% Busca do �ndice "n" do Mach mais pr�ximo ao de voo
[xxxx,n] = min(abs(lista_mach - Mach)); % "n" � o index do elemento mais pr�ximo

if n==1
    M_(1)=lista_mach(1);
    M_(2)=lista_mach(2);
    M_(3)=lista_mach(3);
elseif n==10
    M_(1)=lista_mach(8);
    M_(2)=lista_mach(9);
    M_(3)=lista_mach(10);
else
    M_(1)=lista_mach(n-1);
    M_(2)=lista_mach(n);
    M_(3)=lista_mach(n+1);
end

% Interpolando entre os CTnet�s, com dados condensados no m-file "carrega_cp_ct.m"
for j=1:3
    % Obter os valores de J equivalentes aos Machs dispon�veis para interpola��o
    J_(j)=J*(M_(j)/Mach);
    
    % Obter os valores mais pr�ximos de J_ dispon�veis para interpola��o em cada Mach
    [Jmin,Jmax]=busca_J(M_(j),J_(j));
    
    % Carregar as look-up tables associadas a cada Mach e J dispon�vel para interpola��o
    [cp1_tab,ct1_tab] = carrega_cp_ct(M_(j),Jmin); % carrega cp e ct para Mach e J definidos
    [cp2_tab,ct2_tab] = carrega_cp_ct(M_(j),Jmax);
    
    % Interpola��o para obter os Ct's associados a Cp calculado e J's (Jmin e Jmax)
    ct1=interp1(cp1_tab,ct1_tab,Cp,'spline'); 
    ct2=interp1(cp2_tab,ct2_tab,Cp,'spline'); 
    
    % Interpola��o para obter o Ct final associado a cada J_ equivalente
    CT_net(j)=interp1([Jmin Jmax],[ct1 ct2],J_(j)); 
    
    if flag_plot==1
        figure(1);
        plot(cp1_tab,ct1_tab,'.-b'); grid on; hold on
        plot(Cp,ct1,'*k'); xlabel('Cp'); ylabel('Ct'); title('Jmin');
        figure(2);
        plot(cp2_tab,ct2_tab,'.-b'); grid on; hold on
        plot(Cp,ct2,'*k'); xlabel('Cp'); ylabel('Ct'); title('Jmax');
        figure(3);
        plot([Jmin Jmax],[ct1 ct2],'.-b'); grid on; hold on
        plot(J_(j),CT_net(j),'*k'); xlabel('J'); ylabel('Ct');
    end
end

% Interpola��o final para obter o Ct associado ao Mach de teste
CT_net_final=interp1(M_,CT_net,Mach);  % CT_net final

if flag_plot==1
    figure(4);
    plot(M_,CT_net,'.-b'); grid on; hold on
    plot(Mach,CT_net_final,'*k'); xlabel('Mach'); ylabel('Ct');
end

eta_net=CT_net_final*J/Cp;                      % Eficiencia liquida

% net_thrust=6610*(d_prop/10)^4*(PRPM/1000)^2 ...  % empuxo liquido (lbs)
%                         *CT_net_final/(ro/roi); % serve qualquer uma 
net_thrust=326*SHP*eta_net/V;                   % das express�es  


% net_thrust
% eta_net
% Mach
% J




