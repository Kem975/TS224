clear; close all; clc

%% Paramètres

p = 10;
N = 5000;
a_i = rand(1,p);
Nfft = 512;
m=0;
sigma2 = 1;
X = ones(1,N);

f = -1/2:1/Nfft:1/2-1/Nfft;

%% Polynome A

a_i = a_i./(sum(abs(a_i)));

a=[1 a_i];
b=[1];

%% Definition de P et Q et leurs racines

P = [a(1), a(2:end)+a(end:-1:2), a(1)];
Q = [a(1), a(2:end)-a(end:-1:2), a(1)];

rP = roots(P);
rQ = roots(Q);

%% Affichage

theta = linspace(0,2*pi);
x = cos(theta);
y = sin(theta);

figure,
plot(rP, 'o');
hold on
plot(rQ, '+');
plot(x,y);
hold off
xlim([-1.5, 1.5]);
ylim([-1.5, 1.5]);
legend('Racines de P(z)', 'Racines de Q(z)');

figure,
zplane(P,1);
hold on
zplane(Q,1);
hold off
xlim([-1.5, 1.5]);
ylim([-1.5, 1.5]);

