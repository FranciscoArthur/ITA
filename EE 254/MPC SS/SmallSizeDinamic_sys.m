function dYdt = SmallSizeDinamic_sys(t,Y,tal1,tal2,tal3,m,r,l,ycm,xcm,Icm)
%SMALLSIZEDINAMIC_SYS
%    DYDT = SMALLSIZEDINAMIC_SYS(T,Y,TAL1,TAL2,TAL3,M,R,L,YCM,XCM,ICM)

%    This function was generated by the Symbolic Math Toolbox version 7.2.
%    07-May-2019 12:52:17

t2 = m.^2;
t3 = r.^2;
t4 = ycm.^2;
t5 = sqrt(2.0);
t6 = Icm.^2;
t7 = l.^2;
t8 = xcm.^2;
t9 = t8.^2;
t10 = t7.^2;
t11 = t4.^2;
t12 = 1.0./Icm;
t13 = m.*t8;
t14 = m.*t4;
t15 = l.*m.*t5.*ycm.*2.0;
t16 = Icm+t13+t14+t15;
t17 = 1.0./t16;
t18 = t6.^2;
t19 = t2.^2;
t20 = t11.^2;
t21 = 1.0./m;
dYdt = [Y(2);(t12.*t17.*(Icm.*t6.*tal1-Icm.*t6.*tal2+Icm.*t2.*t9.*tal1-Icm.*t2.*t9.*tal2+Icm.*t2.*t10.*tal1.*4.0+Icm.*t2.*t11.*tal1+Icm.*t2.*t10.*tal3.*4.0-Icm.*t2.*t11.*tal2+m.*t4.*t6.*tal1.*2.0-m.*t4.*t6.*tal2.*2.0+m.*t6.*t7.*tal1.*4.0-m.*t6.*t7.*tal2.*2.0+m.*t6.*t8.*tal1.*2.0+m.*t6.*t7.*tal3.*2.0-m.*t6.*t8.*tal2.*2.0+Icm.*t2.*t4.*t7.*tal1.*1.4e1-Icm.*t2.*t4.*t7.*tal2.*1.8e1+Icm.*t2.*t4.*t8.*tal1.*3.0+Icm.*t2.*t4.*t7.*tal3.*1.2e1-Icm.*t2.*t4.*t8.*tal2.*3.0+Icm.*t2.*t7.*t8.*tal1.*6.0-Icm.*t2.*t7.*t8.*tal2.*4.0+Icm.*t2.*t7.*t8.*tal3.*2.0+m.*t2.*t4.*t9.*tal1-m.*t2.*t4.*t9.*tal2+m.*t2.*t4.*t10.*tal1.*2.0e1-m.*t2.*t4.*t10.*tal2.*8.0+m.*t2.*t4.*t10.*tal3.*2.8e1+m.*t2.*t7.*t9.*tal1.*2.0-m.*t2.*t7.*t9.*tal2.*2.0+m.*t2.*t7.*t11.*tal1.*2.0+m.*t2.*t8.*t10.*tal1.*4.0-m.*t2.*t7.*t11.*tal2.*8.0+m.*t2.*t8.*t11.*tal1+m.*t2.*t7.*t11.*tal3.*1.0e1+m.*t2.*t8.*t10.*tal3.*4.0-m.*t2.*t8.*t11.*tal2+m.*t6.*tal2.*xcm.*ycm-m.*t6.*tal3.*xcm.*ycm-l.*m.*t5.*t6.*tal1.*xcm.*2.0+l.*m.*t5.*t6.*tal2.*xcm-l.*m.*t5.*t6.*tal3.*xcm+l.*m.*t5.*t6.*tal1.*ycm.*4.0-l.*m.*t5.*t6.*tal2.*ycm.*5.0+l.*m.*t5.*t6.*tal3.*ycm+m.*t2.*t4.*t7.*t8.*tal1.*1.2e1-m.*t2.*t4.*t7.*t8.*tal2.*1.4e1+m.*t2.*t4.*t7.*t8.*tal3.*6.0-m.*t2.*t10.*tal1.*xcm.*ycm.*1.6e1+m.*t2.*t10.*tal2.*xcm.*ycm.*8.0-m.*t2.*t10.*tal3.*xcm.*ycm.*8.0+m.*t2.*t11.*tal2.*xcm.*ycm-m.*t2.*t11.*tal3.*xcm.*ycm+Icm.*t2.*t4.*tal2.*xcm.*ycm.*2.0-Icm.*t2.*t4.*tal3.*xcm.*ycm.*2.0-Icm.*t2.*t7.*tal1.*xcm.*ycm.*1.6e1+Icm.*t2.*t7.*tal2.*xcm.*ycm.*1.0e1-Icm.*t2.*t7.*tal3.*xcm.*ycm.*1.0e1+Icm.*t2.*t8.*tal2.*xcm.*ycm-Icm.*t2.*t8.*tal3.*xcm.*ycm-Icm.*l.*t2.*t4.*t5.*tal1.*xcm.*4.0+Icm.*l.*t2.*t4.*t5.*tal2.*xcm.*6.0-Icm.*l.*t2.*t4.*t5.*tal3.*xcm.*6.0-Icm.*l.*t2.*t5.*t7.*tal1.*xcm.*4.0+Icm.*l.*t2.*t5.*t7.*tal2.*xcm.*2.0-Icm.*l.*t2.*t5.*t8.*tal1.*xcm.*2.0-Icm.*l.*t2.*t5.*t7.*tal3.*xcm.*2.0+Icm.*l.*t2.*t5.*t8.*tal2.*xcm-Icm.*l.*t2.*t5.*t8.*tal3.*xcm+Icm.*l.*t2.*t4.*t5.*tal1.*ycm.*4.0-Icm.*l.*t2.*t4.*t5.*tal2.*ycm.*6.0+Icm.*l.*t2.*t4.*t5.*tal3.*ycm.*2.0+Icm.*l.*t2.*t5.*t7.*tal1.*ycm.*1.2e1-Icm.*l.*t2.*t5.*t7.*tal2.*ycm.*6.0+Icm.*l.*t2.*t5.*t8.*tal1.*ycm.*6.0+Icm.*l.*t2.*t5.*t7.*tal3.*ycm.*1.0e1-Icm.*l.*t2.*t5.*t8.*tal2.*ycm.*7.0+Icm.*l.*t2.*t5.*t8.*tal3.*ycm-l.*m.*t2.*t5.*t11.*tal1.*xcm.*2.0+l.*m.*t2.*t5.*t11.*tal2.*xcm.*5.0-l.*m.*t2.*t5.*t11.*tal3.*xcm.*5.0+l.*m.*t2.*t5.*t9.*tal1.*ycm.*2.0-l.*m.*t2.*t5.*t9.*tal2.*ycm.*2.0+l.*m.*t2.*t5.*t10.*tal1.*ycm.*8.0+l.*m.*t2.*t5.*t10.*tal3.*ycm.*8.0-l.*m.*t2.*t5.*t11.*tal2.*ycm+l.*m.*t2.*t5.*t11.*tal3.*ycm-m.*t2.*t4.*t7.*tal1.*xcm.*ycm.*1.6e1+m.*t2.*t4.*t7.*tal2.*xcm.*ycm.*1.8e1-m.*t2.*t4.*t7.*tal3.*xcm.*ycm.*1.8e1+m.*t2.*t4.*t8.*tal2.*xcm.*ycm-m.*t2.*t4.*t8.*tal3.*xcm.*ycm-m.*t2.*t7.*t8.*tal1.*xcm.*ycm.*8.0+m.*t2.*t7.*t8.*tal2.*xcm.*ycm.*6.0-m.*t2.*t7.*t8.*tal3.*xcm.*ycm.*6.0-l.*m.*t2.*t4.*t5.*t7.*tal1.*xcm.*2.0e1+l.*m.*t2.*t4.*t5.*t7.*tal2.*xcm.*1.4e1-l.*m.*t2.*t4.*t5.*t8.*tal1.*xcm.*2.0-l.*m.*t2.*t4.*t5.*t7.*tal3.*xcm.*1.4e1+l.*m.*t2.*t4.*t5.*t8.*tal2.*xcm.*3.0-l.*m.*t2.*t4.*t5.*t8.*tal3.*xcm.*3.0-l.*m.*t2.*t5.*t7.*t8.*tal1.*xcm.*4.0+l.*m.*t2.*t5.*t7.*t8.*tal2.*xcm.*2.0-l.*m.*t2.*t5.*t7.*t8.*tal3.*xcm.*2.0+l.*m.*t2.*t4.*t5.*t7.*tal1.*ycm.*8.0-l.*m.*t2.*t4.*t5.*t7.*tal2.*ycm.*1.0e1+l.*m.*t2.*t4.*t5.*t8.*tal1.*ycm.*4.0+l.*m.*t2.*t4.*t5.*t7.*tal3.*ycm.*1.8e1-l.*m.*t2.*t4.*t5.*t8.*tal2.*ycm.*5.0+l.*m.*t2.*t4.*t5.*t8.*tal3.*ycm+l.*m.*t2.*t5.*t7.*t8.*tal1.*ycm.*8.0-l.*m.*t2.*t5.*t7.*t8.*tal2.*ycm.*6.0+l.*m.*t2.*t5.*t7.*t8.*tal3.*ycm.*6.0).*2.0)./(Icm.*m.*t3+t2.*t3.*t4+t2.*t3.*t7.*2.0+l.*t2.*t3.*t5.*ycm.*2.0);Y(4);(t12.*t17.*t21.*(-t18.*tal1+t18.*tal2.*2.0-t18.*tal3+t19.*t20.*tal2-t19.*t20.*tal3-t2.*t6.*t9.*tal1.*3.0+t2.*t6.*t9.*tal2.*4.0-t2.*t6.*t9.*tal3-t2.*t6.*t11.*tal1.*3.0+t2.*t6.*t11.*tal2.*9.0-t2.*t6.*t11.*tal3.*6.0-t9.*t11.*t19.*tal1.*2.0+t9.*t11.*t19.*tal2.*3.0-t10.*t11.*t19.*tal1.*4.8e1-t9.*t11.*t19.*tal3+t10.*t11.*t19.*tal2.*1.6e1-t10.*t11.*t19.*tal3.*6.4e1-Icm.*m.*t4.*t6.*tal1.*3.0+Icm.*m.*t4.*t6.*tal2.*7.0-Icm.*m.*t4.*t6.*tal3.*4.0-Icm.*m.*t6.*t7.*tal1.*2.0+Icm.*m.*t6.*t7.*tal2.*4.0-Icm.*m.*t6.*t8.*tal1.*3.0-Icm.*m.*t6.*t7.*tal3.*2.0+Icm.*m.*t6.*t8.*tal2.*5.0-Icm.*m.*t6.*t8.*tal3.*2.0-t2.*t4.*t6.*t7.*tal1.*4.0e1+t2.*t4.*t6.*t7.*tal2.*5.8e1-t2.*t4.*t6.*t8.*tal1.*7.0-t2.*t4.*t6.*t7.*tal3.*4.2e1+t2.*t4.*t6.*t8.*tal2.*1.3e1-t2.*t4.*t6.*t8.*tal3.*6.0-t2.*t6.*t7.*t8.*tal1.*6.0+t2.*t6.*t7.*t8.*tal2.*1.0e1-t2.*t6.*t7.*t8.*tal3.*4.0-t4.*t7.*t9.*t19.*tal1.*2.4e1+t4.*t7.*t9.*t19.*tal2.*2.2e1-t4.*t8.*t9.*t19.*tal1-t4.*t7.*t9.*t19.*tal3.*6.0-t4.*t7.*t11.*t19.*tal1.*1.2e1+t4.*t8.*t9.*t19.*tal2-t4.*t8.*t10.*t19.*tal1.*3.2e1+t4.*t7.*t11.*t19.*tal2.*2.6e1+t4.*t8.*t10.*t19.*tal2.*1.6e1-t4.*t8.*t11.*t19.*tal1-t4.*t7.*t11.*t19.*tal3.*3.8e1-t4.*t8.*t10.*t19.*tal3.*1.6e1+t4.*t8.*t11.*t19.*tal2.*3.0-t7.*t8.*t9.*t19.*tal1.*2.0-t4.*t8.*t11.*t19.*tal3.*2.0+t7.*t8.*t9.*t19.*tal2.*2.0-t7.*t8.*t11.*t19.*tal1.*4.2e1+t7.*t8.*t11.*t19.*tal2.*4.6e1-t7.*t8.*t11.*t19.*tal3.*3.6e1+t2.*t4.*t6.*tal1.*xcm.*ycm.*3.0-t2.*t4.*t6.*tal2.*xcm.*ycm.*6.0+t2.*t4.*t6.*tal3.*xcm.*ycm.*3.0+t2.*t6.*t7.*tal1.*xcm.*ycm.*1.4e1-t2.*t6.*t7.*tal2.*xcm.*ycm.*4.0+t2.*t6.*t8.*tal1.*xcm.*ycm.*2.0+t2.*t6.*t7.*tal3.*xcm.*ycm.*1.4e1-t2.*t6.*t8.*tal2.*xcm.*ycm.*4.0+t2.*t6.*t8.*tal3.*xcm.*ycm.*2.0+t4.*t9.*t19.*tal1.*xcm.*ycm-t4.*t9.*t19.*tal2.*xcm.*ycm.*2.0+t4.*t10.*t19.*tal1.*xcm.*ycm.*6.4e1+t4.*t9.*t19.*tal3.*xcm.*ycm-t4.*t10.*t19.*tal2.*xcm.*ycm.*3.2e1+t4.*t11.*t19.*tal1.*xcm.*ycm+t4.*t10.*t19.*tal3.*xcm.*ycm.*6.4e1-t4.*t11.*t19.*tal2.*xcm.*ycm.*2.0+t7.*t9.*t19.*tal1.*xcm.*ycm.*6.0+t4.*t11.*t19.*tal3.*xcm.*ycm-t7.*t9.*t19.*tal2.*xcm.*ycm.*4.0+t7.*t9.*t19.*tal3.*xcm.*ycm.*6.0+t7.*t11.*t19.*tal1.*xcm.*ycm.*3.8e1+t8.*t10.*t19.*tal1.*xcm.*ycm.*1.6e1-t7.*t11.*t19.*tal2.*xcm.*ycm.*5.2e1+t8.*t11.*t19.*tal1.*xcm.*ycm.*2.0+t7.*t11.*t19.*tal3.*xcm.*ycm.*3.8e1+t8.*t10.*t19.*tal3.*xcm.*ycm.*1.6e1-t8.*t11.*t19.*tal2.*xcm.*ycm.*4.0+t8.*t11.*t19.*tal3.*xcm.*ycm.*2.0-Icm.*m.*t2.*t4.*t9.*tal1.*5.0+Icm.*m.*t2.*t4.*t9.*tal2.*7.0-Icm.*m.*t2.*t4.*t10.*tal1.*3.2e1-Icm.*m.*t2.*t4.*t9.*tal3.*2.0+Icm.*m.*t2.*t4.*t10.*tal2.*3.2e1-Icm.*m.*t2.*t4.*t11.*tal1-Icm.*m.*t2.*t4.*t10.*tal3.*3.2e1+Icm.*m.*t2.*t4.*t11.*tal2.*5.0-Icm.*m.*t2.*t7.*t9.*tal1.*6.0-Icm.*m.*t2.*t4.*t11.*tal3.*4.0+Icm.*m.*t2.*t7.*t9.*tal2.*8.0-Icm.*m.*t2.*t8.*t9.*tal1-Icm.*m.*t2.*t7.*t9.*tal3.*2.0-Icm.*m.*t2.*t7.*t11.*tal1.*5.0e1+Icm.*m.*t2.*t8.*t9.*tal2+Icm.*m.*t2.*t7.*t11.*tal2.*8.0e1-Icm.*m.*t2.*t8.*t11.*tal1.*5.0-Icm.*m.*t2.*t7.*t11.*tal3.*7.8e1+Icm.*m.*t2.*t8.*t11.*tal2.*1.1e1-Icm.*m.*t2.*t8.*t11.*tal3.*6.0+Icm.*m.*t6.*tal1.*xcm.*ycm-Icm.*m.*t6.*tal2.*xcm.*ycm.*2.0+Icm.*m.*t6.*tal3.*xcm.*ycm+Icm.*l.*m.*t5.*t6.*tal1.*xcm+Icm.*l.*m.*t5.*t6.*tal3.*xcm-Icm.*l.*m.*t5.*t6.*tal1.*ycm.*7.0+Icm.*l.*m.*t5.*t6.*tal2.*ycm.*1.2e1-Icm.*l.*m.*t5.*t6.*tal3.*ycm.*7.0-Icm.*m.*t2.*t4.*t7.*t8.*tal1.*6.4e1+Icm.*m.*t2.*t4.*t7.*t8.*tal2.*7.2e1-Icm.*m.*t2.*t4.*t7.*t8.*tal3.*4.0e1+Icm.*m.*t2.*t9.*tal1.*xcm.*ycm-Icm.*m.*t2.*t9.*tal2.*xcm.*ycm.*2.0+Icm.*m.*t2.*t10.*tal1.*xcm.*ycm.*1.6e1+Icm.*m.*t2.*t9.*tal3.*xcm.*ycm+Icm.*m.*t2.*t11.*tal1.*xcm.*ycm.*3.0+Icm.*m.*t2.*t10.*tal3.*xcm.*ycm.*1.6e1-Icm.*m.*t2.*t11.*tal2.*xcm.*ycm.*6.0+Icm.*m.*t2.*t11.*tal3.*xcm.*ycm.*3.0+l.*t2.*t4.*t5.*t6.*tal1.*xcm.*9.0-l.*t2.*t4.*t5.*t6.*tal2.*xcm.*1.2e1+l.*t2.*t4.*t5.*t6.*tal3.*xcm.*9.0+l.*t2.*t5.*t6.*t7.*tal1.*xcm.*2.0+l.*t2.*t5.*t6.*t8.*tal1.*xcm.*2.0+l.*t2.*t5.*t6.*t7.*tal3.*xcm.*2.0+l.*t2.*t5.*t6.*t8.*tal3.*xcm.*2.0+l.*t4.*t5.*t9.*t19.*tal1.*xcm.*3.0-l.*t4.*t5.*t9.*t19.*tal2.*xcm.*4.0+l.*t4.*t5.*t10.*t19.*tal1.*xcm.*1.6e1+l.*t4.*t5.*t9.*t19.*tal3.*xcm.*3.0+l.*t4.*t5.*t11.*t19.*tal1.*xcm.*7.0+l.*t4.*t5.*t10.*t19.*tal3.*xcm.*1.6e1-l.*t4.*t5.*t11.*t19.*tal2.*xcm.*1.2e1+l.*t5.*t7.*t9.*t19.*tal1.*xcm.*2.0+l.*t4.*t5.*t11.*t19.*tal3.*xcm.*7.0+l.*t5.*t7.*t9.*t19.*tal3.*xcm.*2.0+l.*t5.*t7.*t11.*t19.*tal1.*xcm.*5.0e1-l.*t5.*t7.*t11.*t19.*tal2.*xcm.*4.8e1+l.*t5.*t8.*t11.*t19.*tal1.*xcm.*1.0e1+l.*t5.*t7.*t11.*t19.*tal3.*xcm.*5.0e1-l.*t5.*t8.*t11.*t19.*tal2.*xcm.*1.6e1+l.*t5.*t8.*t11.*t19.*tal3.*xcm.*1.0e1-l.*t2.*t4.*t5.*t6.*tal1.*ycm.*1.5e1+l.*t2.*t4.*t5.*t6.*tal2.*ycm.*3.0e1-l.*t2.*t4.*t5.*t6.*tal3.*ycm.*2.1e1-l.*t2.*t5.*t6.*t7.*tal1.*ycm.*1.0e1+l.*t2.*t5.*t6.*t7.*tal2.*ycm.*1.6e1-l.*t2.*t5.*t6.*t8.*tal1.*ycm.*1.6e1-l.*t2.*t5.*t6.*t7.*tal3.*ycm.*1.0e1+l.*t2.*t5.*t6.*t8.*tal2.*ycm.*2.2e1-l.*t2.*t5.*t6.*t8.*tal3.*ycm.*1.0e1-l.*t4.*t5.*t9.*t19.*tal1.*ycm.*9.0+l.*t4.*t5.*t9.*t19.*tal2.*ycm.*1.0e1-l.*t4.*t5.*t10.*t19.*tal1.*ycm.*1.6e1-l.*t4.*t5.*t9.*t19.*tal3.*ycm.*3.0-l.*t4.*t5.*t11.*t19.*tal1.*ycm-l.*t4.*t5.*t10.*t19.*tal3.*ycm.*1.6e1+l.*t4.*t5.*t11.*t19.*tal2.*ycm.*6.0-l.*t5.*t7.*t9.*t19.*tal1.*ycm.*1.0e1-l.*t4.*t5.*t11.*t19.*tal3.*ycm.*7.0+l.*t5.*t7.*t9.*t19.*tal2.*ycm.*8.0-l.*t5.*t8.*t9.*t19.*tal1.*ycm.*2.0-l.*t5.*t7.*t9.*t19.*tal3.*ycm.*2.0-l.*t5.*t7.*t11.*t19.*tal1.*ycm.*2.6e1+l.*t5.*t8.*t9.*t19.*tal2.*ycm.*2.0+l.*t5.*t7.*t11.*t19.*tal2.*ycm.*2.4e1-l.*t5.*t8.*t11.*t19.*tal1.*ycm.*8.0-l.*t5.*t7.*t11.*t19.*tal3.*ycm.*5.0e1+l.*t5.*t8.*t11.*t19.*tal2.*ycm.*1.4e1-l.*t5.*t8.*t11.*t19.*tal3.*ycm.*1.0e1+t4.*t7.*t8.*t19.*tal1.*xcm.*ycm.*3.6e1-t4.*t7.*t8.*t19.*tal2.*xcm.*ycm.*4.0e1+t4.*t7.*t8.*t19.*tal3.*xcm.*ycm.*3.6e1+Icm.*l.*m.*t2.*t5.*t9.*tal1.*xcm+Icm.*l.*m.*t2.*t5.*t9.*tal3.*xcm+Icm.*l.*m.*t2.*t5.*t11.*tal1.*xcm.*1.5e1-Icm.*l.*m.*t2.*t5.*t11.*tal2.*xcm.*2.4e1+Icm.*l.*m.*t2.*t5.*t11.*tal3.*xcm.*1.5e1-Icm.*l.*m.*t2.*t5.*t9.*tal1.*ycm.*1.1e1+Icm.*l.*m.*t2.*t5.*t9.*tal2.*ycm.*1.2e1-Icm.*l.*m.*t2.*t5.*t9.*tal3.*ycm.*3.0-Icm.*l.*m.*t2.*t5.*t11.*tal1.*ycm.*9.0+Icm.*l.*m.*t2.*t5.*t11.*tal2.*ycm.*2.4e1-Icm.*l.*m.*t2.*t5.*t11.*tal3.*ycm.*2.1e1+Icm.*m.*t2.*t4.*t7.*tal1.*xcm.*ycm.*5.2e1-Icm.*m.*t2.*t4.*t7.*tal2.*xcm.*ycm.*5.6e1+Icm.*m.*t2.*t4.*t8.*tal1.*xcm.*ycm.*4.0+Icm.*m.*t2.*t4.*t7.*tal3.*xcm.*ycm.*5.2e1-Icm.*m.*t2.*t4.*t8.*tal2.*xcm.*ycm.*8.0+Icm.*m.*t2.*t4.*t8.*tal3.*xcm.*ycm.*4.0+Icm.*m.*t2.*t7.*t8.*tal1.*xcm.*ycm.*2.0e1-Icm.*m.*t2.*t7.*t8.*tal2.*xcm.*ycm.*8.0+Icm.*m.*t2.*t7.*t8.*tal3.*xcm.*ycm.*2.0e1+l.*t4.*t5.*t7.*t8.*t19.*tal1.*xcm.*2.8e1-l.*t4.*t5.*t7.*t8.*t19.*tal2.*xcm.*1.6e1+l.*t4.*t5.*t7.*t8.*t19.*tal3.*xcm.*2.8e1-l.*t4.*t5.*t7.*t8.*t19.*tal1.*ycm.*4.4e1+l.*t4.*t5.*t7.*t8.*t19.*tal2.*ycm.*3.2e1-l.*t4.*t5.*t7.*t8.*t19.*tal3.*ycm.*2.8e1+Icm.*l.*m.*t2.*t4.*t5.*t7.*tal1.*xcm.*3.6e1-Icm.*l.*m.*t2.*t4.*t5.*t7.*tal2.*xcm.*1.6e1+Icm.*l.*m.*t2.*t4.*t5.*t8.*tal1.*xcm.*1.2e1+Icm.*l.*m.*t2.*t4.*t5.*t7.*tal3.*xcm.*3.6e1-Icm.*l.*m.*t2.*t4.*t5.*t8.*tal2.*xcm.*1.6e1+Icm.*l.*m.*t2.*t4.*t5.*t8.*tal3.*xcm.*1.2e1+Icm.*l.*m.*t2.*t5.*t7.*t8.*tal1.*xcm.*4.0+Icm.*l.*m.*t2.*t5.*t7.*t8.*tal3.*xcm.*4.0-Icm.*l.*m.*t2.*t4.*t5.*t7.*tal1.*ycm.*5.2e1+Icm.*l.*m.*t2.*t4.*t5.*t7.*tal2.*ycm.*5.6e1-Icm.*l.*m.*t2.*t4.*t5.*t8.*tal1.*ycm.*2.4e1-Icm.*l.*m.*t2.*t4.*t5.*t7.*tal3.*ycm.*6.0e1+Icm.*l.*m.*t2.*t4.*t5.*t8.*tal2.*ycm.*3.6e1-Icm.*l.*m.*t2.*t4.*t5.*t8.*tal3.*ycm.*2.0e1-Icm.*l.*m.*t2.*t5.*t7.*t8.*tal1.*ycm.*2.0e1+Icm.*l.*m.*t2.*t5.*t7.*t8.*tal2.*ycm.*2.4e1-Icm.*l.*m.*t2.*t5.*t7.*t8.*tal3.*ycm.*1.2e1).*2.0)./((Icm.*t3+m.*t3.*t4+m.*t3.*t8+l.*m.*t3.*t5.*ycm.*2.0).*(Icm+t14+t15+m.*t7.*2.0));Y(6);1.0./r.^2.*t12.*t17.*t21.*(-t6.*tal2+t6.*tal3-t2.*t11.*tal2+t2.*t11.*tal3+t2.*t4.*t7.*tal1.*6.0-t2.*t4.*t7.*tal2.*4.0+t2.*t4.*t7.*tal3.*1.0e1-t2.*t4.*t8.*tal2+t2.*t4.*t8.*tal3+t2.*t7.*t8.*tal1.*2.0+t2.*t7.*t8.*tal3.*2.0-Icm.*m.*t4.*tal2.*2.0+Icm.*m.*t4.*tal3.*2.0+Icm.*m.*t7.*tal1.*2.0+Icm.*m.*t7.*tal3.*2.0-Icm.*m.*t8.*tal2+Icm.*m.*t8.*tal3-Icm.*m.*tal1.*xcm.*ycm+Icm.*m.*tal2.*xcm.*ycm-t2.*t4.*tal1.*xcm.*ycm+t2.*t4.*tal2.*xcm.*ycm-t2.*t7.*tal1.*xcm.*ycm.*4.0+t2.*t7.*tal2.*xcm.*ycm.*4.0-t2.*t8.*tal1.*xcm.*ycm+t2.*t8.*tal2.*xcm.*ycm-l.*t2.*t4.*t5.*tal1.*xcm.*3.0+l.*t2.*t4.*t5.*tal2.*xcm.*3.0-l.*t2.*t5.*t8.*tal1.*xcm+l.*t2.*t5.*t8.*tal2.*xcm+l.*t2.*t4.*t5.*tal1.*ycm-l.*t2.*t4.*t5.*tal2.*ycm.*3.0+l.*t2.*t4.*t5.*tal3.*ycm.*4.0+l.*t2.*t5.*t7.*tal1.*ycm.*4.0+l.*t2.*t5.*t8.*tal1.*ycm+l.*t2.*t5.*t7.*tal3.*ycm.*4.0-l.*t2.*t5.*t8.*tal2.*ycm+l.*t2.*t5.*t8.*tal3.*ycm.*2.0-Icm.*l.*m.*t5.*tal1.*xcm+Icm.*l.*m.*t5.*tal2.*xcm+Icm.*l.*m.*t5.*tal1.*ycm-Icm.*l.*m.*t5.*tal2.*ycm.*3.0+Icm.*l.*m.*t5.*tal3.*ycm.*4.0).*2.0];
