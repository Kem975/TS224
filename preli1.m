clear; close all; clc

%% Param?tres

p = 4;
N = 5000;
a_i = rand(1,p);
Nfft = 512;
m=0;
sigma2 = 1;
%X = sqrt(sigma2)*randn(N,1) + m;
X = ones(1,N);

f = -1/2:1/Nfft:1/2-1/Nfft;
a_i = a_i./(sum(abs(a_i)));

a=[1 a_i];
b=[1];



%% Processus AR

Y = filter(b,a,X);
h=freqz(b,a,2*pi*f);


%% Fr?quentiel

TF = fftshift(abs(fft(Y,Nfft))).^2/Nfft;
DSP = abs(h).^2*sigma2;

%% Estimation des Paramètres AR

R = xcorr( Y );
r = R(N : N+p-1);
c = R(N : -1 : N-p+1);

Toep = toeplitz( c,r );

estimation_a_i = R(N+1 : N+p) * inv(-Toep);
norme = norm(estimation_a_i-a_i);

%% Affichage

figure,
plot(Y), title('Plot du processus auto-regressif');
%subplot(212)
%plot(f,TF),
%hold on
%plot(f,DSP,'r','LineWidth',2),
%title('Transformee de Fourrier(bleu) & DSP(rouge)');


