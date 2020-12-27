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

for k=2
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

%% Estimation des paramètres AR

R = xcorr( X(2,:) );
figure, plot( (-4999:4999), R );

r = R(5000 : 5000+p-1);
c = R(5000 : -1 : 5000-p+1);

Toep = toeplitz( c,r );
Toep_inv = inv( -Toep );

a_i
estimation_a_i = R(5001:5000+p) * inv(-Toep)





