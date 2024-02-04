clear; clc;          % Clear command window

iterations  = 5;     % Pocet iteracii
population  = 50;    % Velkost populacie
generations = 3000;  % Počet generácii 

mutRate = 0.1;                   % Miera mutacie 
MAX     = 5.12;                  % Hodnota ohranicenia
Graf    = zeros(1, generations); % Premenna pre vykreslenie grafu
Space   = [ones(1, 10) * (-MAX); % Rozsah prvkov v matici
           ones(1, 10) * MAX]; 

for i = 1:iterations
    pop = genrpop(population, Space);  % Vytvorenie počiatočnej populácie

for j = 1:generations

    fitFun  = testfn2(pop); % Zavolanie Rastriginovej funkcie
    Graf(j) = min(fitFun);  % Uloženie minima fitness funkcie do grafu

    % Skupina A - výber
    NewPop1 = selbest(pop, fitFun, 1);   % Vyber najlepšieho jedinca
    NewPop2 = selrand(pop, fitFun, 9);   % Jedinci zo starej populacie

    % Skupina B - kríženie
    NewPop3 = seltourn(pop, fitFun, 20); % Turnajový výber
    NewPop3 = crossov(NewPop3, 1, 0);    % Viacbodové kríženie dvoch rodičov
     
    % Skupina C - mutácie
    NewPop4 = selrand(pop, fitFun, 20);         % Náhodný výber 
    NewPop4 = mutx(NewPop4, mutRate, Space);    % Obyčajná mutácia
 
    pop = [NewPop1; NewPop2; NewPop3; NewPop4]; % Uloženie novej populácie
end
    plot(Graf(:));    % Vykreslenie grafu
    hold on;
end 

Optimal = selbest(pop, fitFun, 1); % Vyber optimalneho jedinca
fitBest = testfn2(Optimal);        % Fitness hodnota optimalneho jedinca

% Graf
title("Graf evolúcie fitness, Rastriginova f. 10 premenných"); % Názov grafu
xlabel('Generacie'); % Označenie osi x
ylabel('F(x)');      % Označenie osi y
hold off;

% Záverečný výpis | Riešenie
display("Fitness = " + fitBest);
display(Optimal);