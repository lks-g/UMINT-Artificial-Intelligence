clear; clc; close all;

% Načítanie dát z dataarytmiasrdca
load("dataarytmiasrdca");

% Vstupné parametre ochorenia
inputs  = NDATA';

% Vystupne data pre NS
target = zeros(2, size(typ_ochorenia, 1));

% Vytvorenie matice žiadaných hodnôt
for i = 1:size(typ_ochorenia, 1)
    if typ_ochorenia(i) == 1
        target(typ_ochorenia(i), i) = 1;
    else
        target(2, i) = 1;
    end
end
targets = target;

iterations = 10; % Max. počet iterácií
for i = 1:iterations

    % Neurónová sieť určená na klasifikáciu dát
    net = patternnet(25);
    
    net.divideFcn = 'dividerand';  % Náhodné rozdelenie dát

    % Nastavenie pomerov rozdelenia
    net.divideParam.trainRatio = 0.6; % 60% dat na trenovanie
    net.divideParam.valRatio   = 0;   % 0% dat na validaciu
    net.divideParam.testRatio  = 0.4; % 40% dat na testovanie

    % Nastavenie parametrov
    net.trainParam.goal     = 0.1;   % Ukoncovacia podmienka na chybu SSE
    net.trainParam.show     = 5;     % Frekvencia zobrazovania priebehu chyby trénovania
    net.trainParam.epochs   = 150;   % Maximálny počet cyklov trénovania
    net.trainParam.min_grad = 1e-4;  % Ukoncovacia podmienka na min. gradient
    
    % Trénovanie neurónovej siete
    [net, tr] = train(net, inputs, targets);
    
    % Testovanie NS
    outputs      = net(inputs);
    outputsTrain = net(inputs(:, tr.trainInd)); % Testovanie trénovacích dát
    outputsTest  = net(inputs(:, tr.testInd));  % Testovanie testovacích dát

    trainTargets = targets(:, tr.trainInd); % Trénovacie dáta
    testTargets  = targets(:, tr.testInd);  % Testovacie dáta

    performance  = perform(net, targets, outputs); % Výpočet výkonu neurónovej siete
    
    [cTrain, cmTrain] = confusion(trainTargets, outputsTrain); % Klasifikačná matica trenovania 
    [cTest, cmTest]   = confusion(testTargets, outputsTest);   % Klasifikačná matica testovania
    [c, cm]           = confusion(targets, outputs);           % Klasifikačná matica celkových dát

    fprintf("%d.\t Úspešnosť klasifikácie\n", i);
    fprintf("\t +------------+\n");
    fprintf("\t | TRAIN: %.0f%% |\n\t | TEST:  %.0f%% |\n\t | ALL:   %.0f%% |\n", 100 * (1 - cTrain), 100 * (1 - cTest), 100 * (1 - c));
    fprintf("\t +------------+\n\n");

    fprintf("\t Senzitivita | Špecifickosť\n");
    fprintf("\t +-------------------+--------+\n");
    fprintf("\t | TRAIN: %f | %f |\n", cmTrain(2,2) / (cmTrain(2,2) + cmTrain(2,1)), cmTrain(1,1) / (cmTrain(1,1) + cmTrain(1,2)));
    fprintf("\t | TEST:  %f | %f |\n", cmTest(2,2) / (cmTest(2,2) + cmTest(2,1)), cmTest(1,1) / (cmTest(1,1) + cmTest(1,2)));
    fprintf("\t | ALL:   %f | %f |\n", cm(2,2) / (cm(2,2) + cm(2,1)), cm(1,1) / (cm(1,1) + cm(1,2)));
    fprintf("\t +-------------------+--------+\n\n");
    fprintf("____________________________________\n\n");

    % Uloženie úspešnosti klasifikácie
    M(i, 1) = 100 * (1 - cTrain);
    M(i, 2) = 100 * (1 - cTest);
    M(i, 3) = 100 * (1 - c);
end

MIN  = min(M);  % Minimálna úspešnosť
MAX  = max(M);  % Maximálna úspešnosť
MEAN = mean(M); % Priemerná úspešnosť

% Výpis riešenia
fprintf("Úspešnosť trénovacej klasifikácie\n");
fprintf("\t+--------------+\n");
fprintf("\t| MINIMUM: %.0f%% |\n\t| MAXIMUM: %.0f%% |\n\t| AVERAGE: %.0f%% |\n", MIN(1), MAX(1), MEAN(1));
fprintf("\t+--------------+\n");

fprintf("\nÚspešnosť testovacej klasifikácie\n");
fprintf("\t+--------------+\n");
fprintf("\t| MINIMUM: %.0f%% |\n\t| MAXIMUM: %.0f%% |\n\t| AVERAGE: %.0f%% |\n", MIN(2), MAX(2), MEAN(2));
fprintf("\t+--------------+\n");

fprintf("\nÚspešnosť celkovej klasifikácie\n");
fprintf("\t+--------------+\n");
fprintf("\t| MINIMUM: %.0f%% |\n\t| MAXIMUM: %.0f%% |\n\t| AVERAGE: %.0f%% |\n", MIN(3), MAX(3), MEAN(3));
fprintf("\t+--------------+\n");

fprintf("\nVýkon neurónovej siete: %f\n", performance);