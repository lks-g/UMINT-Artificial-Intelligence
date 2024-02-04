clear; clc;

finFit = 0;          % Premenna pre optimalne riesenie
table = [0.04, 0.07, 0.11, 0.06, 0.05]; % Tabulka hodnot

genes = 5;           % Pocet genov
iterations  = 10;    % Pocet iteracii
population  = 50;    % Velkost populacie
generations = 2000;  % Pocet generacii 
maxMoney = 10000000; % Rozpocet

mutRate = 0.1;                    % Miera mutacie
Amp   = 100 * ones(1, genes);     % Amplituda mutacie
Graph = zeros(1, generations);    % Premenna pre vykreslenie grafu
Space = [zeros(1, 5) * maxMoney;  % Rozsah prvkov v matici
         ones(1, 5)  * maxMoney]; 

for i = 1:iterations
    %pop = genrpop(population, Space); % Vytvorenie počiatočnej populácie
    pop = randfixedsum(genes, population, maxMoney, 0, maxMoney)'; % Alternativny sposob tvorby populacie

for j = 1:generations
    fitFun = fitnessFun(pop, table, maxMoney);  % Zavolanie fitness funckie
    Graph(i, j) = min(fitFun) * (-1);           % Uloženie minima fitness funkcie do grafu
    
    % Skupina A - výber
    newPop1 = selbest(pop, fitFun,  2);  % Výber najlepších reťazcov
    newPop2 = selbest(pop, fitFun, 10);
    newPop3 = selrand(pop, fitFun, 10);  % Náhodný výber reťazcov
    newPop4 = selsus (pop, fitFun, 10);  % Výber pomocou váhovaného ruletového kolesa
    newPop5 = seltourn(pop,fitFun, 18);  % Turnajový výber
    
    % Skupina B - kríženie
    newPop4(:) = crossov(newPop4, 2, 0); % Viacbodové kríženie dvoch rodičov
    
    % Skupina C - mutácie
    newPop5(:) = mutx(newPop5, mutRate, Space);                       % Obyčajná mutácia
    newPop2(2:end, :) = muta(newPop2(2:end, :), mutRate, Amp, Space); % Aditívna mutácia
    newPop1(2:end, :) = mutn(newPop1(2:end, :), mutRate, Amp, Space); % Multiplikatívna mutácia
    
    pop(:) = [newPop1; newPop2; newPop3; newPop4; newPop5]; % Uloženie novej populácie
end
    if finFit < Graph(end)
        finFit = Graph(end); % Uloženie optimálneho riešenie
    end
    plot(Graph(i, :));       % Vykreslenie grafu
    hold on;
end

optimalGroup   = selbest(pop, fitFun, 1);  % Optimalna skupina
optimalFitness = finFit;                   % Optimalne riesenie
    
% Graf
title("Graf evolúcie fitness"); % Názov grafu
xlabel('Generacie');            % Označenie osi x
ylabel('F(x)');                 % Označenie osi y
hold off;

% Výpis riešenia
fprintf("Optimalne riesenie je: %.f\n", optimalFitness);
fprintf("\nOptimalna skupina s poradím: ");
disp(optimalGroup);

fprintf("\nSumácia optimalnej skupiny: ");
sumOptimal = sum(optimalGroup);
disp(sumOptimal);