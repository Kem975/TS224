clear; close all; clc

%% Parametres

p = 4;
N = [5, 50, 500, 5000];
Nfft = 512;
m=0;
estimation_a_i = zeros(4,p);
norme = zeros(1,4);

a_i = rand(1,p);
TF = zeros(4, Nfft);
DSP= zeros(4,Nfft);

a_i = a_i./(sum(abs(a_i)));
a=[1 a_i];
b=[1];

f = -1/2:1/Nfft:1/2-1/Nfft;
Eb=0;
h=freqz(b,a,2*pi*f);


%% Buitage d'un processus AR

for k=1:4
    
    X = ones(4, N(k));
    
    %% Bruit
    Ps=(1 /N(k))*X(1,:)*X(1,:)';
    Pb = Ps*10^(-Eb/10);
    ran=randn(1,N(k));
    Pb1=(1/N(k))*ran*ran';
    sigma2=Pb/Pb1;
    
    noise = sqrt(sigma2)*randn(1,N(k)) + m;

    %% Processus AR
    X(k,:) = filter( b,a, noise );
    
    %% Fréquentiel

    TF(k,:) = fftshift( abs(fft(X(k,:),Nfft)) ).^2/Nfft;
    DSP(k,:)= abs(h).^2*sigma2;
    
    %% Estimation des paramètres AR

    R = xcorr( X(k,:) );
    r = R(N(k) : N(k)+p-1);
    c = R(N(k) : -1 : N(k)-p+1);

    Toep = toeplitz( c,r );

    estimation_a_i(k,:) = R(N(k)+1 : N(k)+p) * inv(-Toep);
    
    norme(k) = norm(estimation_a_i(k,:)-a_i);
    
end

norme






