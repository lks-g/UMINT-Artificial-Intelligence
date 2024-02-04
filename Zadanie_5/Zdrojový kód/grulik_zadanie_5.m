clear; clc; close all;

% Načítanie dát z datafun
load("datafun");

n = length(y);
n2 = fix(n/2);

% Vytvorenie štruktúry neurónovej siete
net = fitnet([15 15]); % 2 skryte vrstvy

% Indexové rozdelenie
net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:2:n;  % Pouzi kazdu druhu vzorku na trenovanie
net.divideParam.valInd   = 2:2:n2; % V prvej polovici pouzi kazdu druhu vzorku na validaciu
net.divideParam.testInd  = n2:2:n; % Od polovice pouzi kazdu druhu vzorku na testovanie

% Nastavenie parametrov trénovania
net.trainParam.goal = 1e-4;  % Ukoncovacia podmienka na chybu SSE
net.trainParam.show = 5;     % Frekvencia zobrazovania priebehu chyby trénovania
net.trainParam.epochs = 100; % Maximálny počet cyklov trénovania

% Trénovanie neurónovej siete
net = train(net, x, y);

% Simulácia výstupu neurónovej siete
outnetsim = sim(net, x);

% Vykreslenie priebehov
plot(x, y, 'b', x, outnetsim, '-or');

%Informacie o grafe
legend('funkcia', 'sieť');
title('Aproximácia nelineárnej funkcie');
xlabel('x');
ylabel('y');
hold on;

fprintf("+ ----------------------- + \n");

% Suma kvadrátov odchýliek medzi meraným výstupom a výstupom siete
SSE1 = sse(net, net(x(indx_train)), y(indx_train)); 
fprintf("| SSE 1 - Train: %f |\n", SSE1);

SSE2 = sse(net, net(x(indx_test)), y(indx_test));
fprintf("| SSE 2 - Test : %f |\n", SSE2);

fprintf("+ ----------------------- + \n");

% Priemer z SSE1
MSE1 = mse(net, net(x(indx_train)), y(indx_train));
fprintf("| MSE 1 - Train: %f |\n", MSE1);

% Priemer z SSE2
MSE2 = mse(net, net(x(indx_test)), y(indx_test));
fprintf("| MSE 2 - Test : %f |\n", MSE2);

fprintf("+ ----------------------- + \n");

% Maximálna absolútna odchýlka medzi meraným výstupom a výstupom siete
MAE1 = mae(net, net(x(indx_train)), y(indx_train));
fprintf("| MAE 1 - Train: %f |\n", MAE1);

MAE2 = mae(net, net(x(indx_test)), y(indx_test));
fprintf("| MAE 2 - Test : %f |\n", MAE2);

fprintf("+ ----------------------- + \n");