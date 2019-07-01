% ZP2RO   calcula a densidade do ar a uma altitude pressao zp(pes) e
%         desvio de disa (K) da atmosfera padrao
%
%         ex:  ro=zp2ro(zp,disa)            ro em kg/m3
%
function ro=zp2ro(zp,disa);
if (nargin==1),
   disa=0.;
end
ta=zp2ta(zp,disa);
pa=zp2pa(zp);
ro=pa./(2.87*ta);
%