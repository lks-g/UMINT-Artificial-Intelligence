clear; clc;

% Načítanie dát z Data Body
load("databody");

% Nastavenie mierky pre osi x, y, z na 3D grafe
axis([0 1 0 1 0 1]);

% Vykreslenie 3D grafu
plot3(data1(:,1), data1(:,2), data1(:,3), "s", data2(:,1), data2(:,2), data2(:,3), "o", ...
      data3(:,1), data3(:,2), data3(:,3), "*", data4(:,1), data4(:,2), data4(:,3), "+", ...
      data5(:,1), data5(:,2), data5(:,3), "x");

% Informacie o grafe
title("Data body");
xlabel("x");
ylabel("y");
zlabel("z");
hold on

% Vstupne data
data = [data1; data2; data3; data4; data5]';

% Vystupne data
out = [ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
       zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50);
       zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50), zeros(1, 50);
       zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50), zeros(1, 50);
       zeros(1, 50), zeros(1, 50), zeros(1, 50), zeros(1, 50), ones(1, 50)];

% Klasifikacia
net = patternnet(10);

% Trenovanie
net.divideFcn = 'dividerand';     % Náhodne rozdelenie dat

net.divideParam.trainRatio = 0.8; % 80% dat na trenovanie
net.divideParam.valRatio   = 0;   % 0% dat na validaciu
net.divideParam.testRatio  = 0.2; % 20% dat na testovanie

net.trainParam.goal   = 1e-7;    % Ukoncovacia podmienka
net.trainParam.epochs = 100;     % Maximálny počet cyklov trénovania
net.trainParam.min_grad = 1e-10; % Ukoncovacia podmienka na min. gradient

net = train(net, data, out);     % Trenovanie siete

% Testovanie - trenovaných bodov
y = net(data);               % Simulacia vystupu NS
perf = perform(net, out, y); % Vypočítanie celkovej dosahovanej chyby siete
group = vec2ind(y);          % Priradenie vstupov do skupín

% Testovanie - vlastných bodov
testData = [0.2 0.4 0.7 0.6 0.5; 0.6 0.7 0.2 0.8 0.5; 0.1 0.7 0.5 0.6 0.8];
y2 = net(testData);
group2 = vec2ind(y2); 

% Zobrazenie vlastných bodov na grafe
plot3(testData(:,1), testData(:,2), testData(:,3), "rs", "LineWidth", 2);

% Výpis riešenia
fprintf('Vzorky test skupiny: ');
disp(group2);
disp(y2);

fprintf('Vypocet chyby siete: ');
disp(perf);