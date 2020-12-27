clear; close all; clc

%% Parametres

p = 4;
N = 5000;
Nfft = 512;
m=0;

X = ones(3, N);
a_i = rand(1,p);
TF = zeros(3, Nfft);
DSP= zeros(3,Nfft);

Ps=(1 /N)*X(1,:)*X(1,:)';
a_i = a_i./(sum(abs(a_i)));
a=[1 a_i];
b=[1];

f = -1/2:1/Nfft:1/2-1/Nfft;
Eb=[-5,0,10];
h=freqz(b,a,2*pi*f);


%% Buitage d'un processus AR

for k= 1:3
    %% Bruit
    Pb = Ps*10^(-Eb(k)/10);
    ran=randn(1,N);
    Pb1=(1/N)*ran*ran';
    sigma2=Pb/Pb1;
    
    noise = sqrt(sigma2)*randn(1,N) + m;

    %% Processus AR
    X(k,:) = filter(b,a,noise );


    %% Fréquentiel

    TF(k,:) = fftshift(abs(fft(X(k,:),Nfft) )).^2/Nfft;
    DSP(k,:)= abs(h).^2*sigma2;
 
end

%% Affichage
figure,
subplot(321)
plot(X(1,:)), title('-5dB');ylim([-30,30]);

subplot(322)
plot(f,TF(1,:)),
hold on 
plot(f,DSP(1,:),'r','LineWidth',2), 
title('-5dB Transformee de Fourrier(bleu) & DSP(rouge)');

subplot(323)
plot(X(2,:)), title('0dB');ylim([-30,30]);

subplot(324)
plot(f,TF(2,:)), 
hold on 
plot(f,DSP(2,:),'r','LineWidth',2),
title('0dB Transformee de Fourrier(bleu) & DSP(rouge)');

subplot(325)
plot(X(3,:)), title('10dB');ylim([-30,30]);

subplot(326)
plot(f,TF(3,:));
hold on
plot(f,DSP(3,:),'r','LineWidth',2), 
title('10dB Transformee de Fourrier(bleu) & DSP(rouge)');

