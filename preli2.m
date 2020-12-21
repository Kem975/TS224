clear; close all; clc

%% Parametres

p = 4;
N = 5000;
X = ones(1,N);
%X = sqrt(1)*randn(1,N) + 0;
Y = zeros(3, length(X));
a_i = rand(1,p);
Nfft = 512;
TF = zeros(3, Nfft);
DSP= zeros(3,Nfft);
Ps=(1 /N)*X*X';
a_i = a_i./(sum(abs(a_i)));
a=[1 a_i];
b=[1];
f = -1/2:1/Nfft:1/2-1/Nfft;
Eb=[-5,0,10];
h=freqz(b,a,2*pi*f);

%% Buitage d'un processus AR

for k= 1:3
    %% Bruit
    m=0;
    Pb = Ps*10^(-Eb(k)/10);
    ran=randn(1,N);
    Pb1=(1/N)*ran*ran';
    sigma2=Pb/Pb1;
    noise = sqrt(sigma2)*randn(1,N) + m;

    X_bruite = X+noise;

    %% Processus AR
    Y(k,:) = filter(b,a,X_bruite );
  

    %% Fr?quentiel

    TF(k,:) = fftshift(abs(fft(Y(k,:),Nfft) )).^2/Nfft;
    DSP(k,:)= abs(h).^2*sigma2;
 
end

%% Affichage
figure,
subplot(321)
plot(Y(1,:)), title('-5dB');ylim([-50,50]);

subplot(322)
plot(f,TF(1,:)),
hold on 
plot(f,DSP(1,:),'r','LineWidth',2), 
title('-5dB Transformee de Fourrier(bleu) & DSP(rouge)');

subplot(323)
plot(Y(2,:)), title('0dB');ylim([-50,50]);

subplot(324)
plot(f,TF(2,:)), 
hold on 
plot(f,DSP(2,:),'r','LineWidth',2),
title('0dB Transformee de Fourrier(bleu) & DSP(rouge)');

subplot(325)
plot(Y(3,:)), title('10dB');ylim([-50,50]);

subplot(326)
plot(f,TF(3,:));
hold on
plot(f,DSP(3,:),'r','LineWidth',2), 
title('10dB Transformee de Fourrier(bleu) & DSP(rouge)');

