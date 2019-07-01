% ZP2PA
% Calcula a pressao atmosferica pa(mbar)
% numa dada altitude pressao zp(pes)
%
%       Ex:   pa = zp2pa(zp)
%
function pa = zp2pa(zp);

z  = .3048*zp;
a1 = z<=11000;
a2 = z>11000;
pa = (1013.25*(1-6.87559e-6*zp).^(5.25611)).*(a1)+(226.306*exp(157.696e-6 .*(11000-z))).*(a2);
     
