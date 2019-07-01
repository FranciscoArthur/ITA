% ZP2TA calcula a temperatura a uma certa altitude pressao segundo a lei
%       da atmosfera padrao.
%
%       ex:  t=zp2ta(zp,disa)
%                            calcula ta(k) a uma altitude zp(pes) com desvio
%                            de disa (K) da atm padrao
%
function ta=zp2ta(zp,disa)
if (nargin==1),
    disa=0.;
end
z=.3048 .*zp;
a1=z<=11000;
ta=216.65+disa+a1.*(71.5-0.0065 .*z);


