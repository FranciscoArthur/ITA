%   Análise de Frequencia de Vibrações 
%
%   Dados de entrada :
%     x: vetor de resposta 
%	  t: vetor tempo
%
%   Airton Nabarrete, iniciado em 2005, atualizado em 2017
%   Version 1.10
% **************************************************************************

% signal=u;
% signlabel='Displacement [m]';
% signal=udot;
% signlabel='Velocity [m/s]';
signal=uddot;
signlabel='Acceleration [m/s^2]';
time=t;
numptsinal=length(signal);
numpttime=length(time);
n = 2^nextpow2(numpttime);
%
Fs=round(1/dt);
vector=fft(signal,n);
freq=Fs*(0:(n/2))/n;
numptvector=length(vector);
numptfreq=length(freq);
% vector2=vector(1:length(vector)/2+1);
% freq2=freq(1:length(freq)/2+1);
% freq2esc=freq2*(numpontos/tempomax)/(2*pi);
%
%% Gerador de gráficos em frequencia
figure('Name','Frequency Response','NumberTitle','off'); 
max_axis=max(abs(vector(1:n/2+1)))*1.2;
min_axis=min(abs(vector(1:n/2+1)))*1.2;
max_freq=200;
hold on;
plot(freq,abs(vector(1:n/2+1)),'b-')
%plot (time,x,'b-');
hold off;
axis ([0 max_freq 0 max_axis]);
grid on;
box on;
title (' ');
xlabel ('Frequency [Hz]');
ylabel (signlabel);

figure('Name','Frequency Response (Log)','NumberTitle','off'); 
max_axis=max(abs(vector(1:n/2+1)))*2;
max_freq=200;
semilogy(freq,abs(vector(1:n/2+1)),'r-')
%plot (time,x,'b-');
axis ([0 max_freq min_axis max_axis]);
grid on;
box on;
title (' ');
xlabel ('Frequency [Hz]');
ylabel (signlabel);
