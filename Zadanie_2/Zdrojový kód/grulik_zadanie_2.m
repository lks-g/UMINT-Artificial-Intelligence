clear; clc;          % Clear command window

% Suradnice
B = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
     2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 
     7,60; 100,100];

A = B;               % Matica optimalnej skupiny 
genes       = 18;    % Pocet genov
iterations  = 10;    % Pocet iteracii
population  = 20;    % Velkost populacie
mutRate     = 0.1;   % Miera mutacie 
generations = 1000;  % Počet generácii 
Graph = zeros(1, generations); % Premenna pre vykreslenie grafu

for i = 1:iterations
    pop = pop_generate(population, genes);  % Vytvorenie počiatočnej populácie

for j = 1:generations

    fitFun = fitnessFun(B,pop);       % Zavolanie fitness funckie
    [Graph(i,j), bg] = min(fitFun);   % Uloženie minima fitness funkcie do grafu
    Best_Group = pop(bg,:);           % Ulozenie najlepsieho poradia

    % Skupina A - výber
    NewPop1 = selbest (pop, fitFun, 1);  % Vyber najlepšieho jedinca
    NewPop2 = selsus  (pop, fitFun, 5);  % Výber pomocou váhovaného ruletového kolesa
    NewPop3 = seltourn(pop, fitFun, 7);  % Turnajovy výber
    NewPop4 = selrand (pop, fitFun, 7);  % Náhodný výber 

    % Skupina B - kríženie
    NewPop2 = crosord(NewPop2, 1);   % 2-bodove permutacne krizenie

    % Skupina C - mutácie
    NewPop3 = swapgen(NewPop3, mutRate); % Mutácia poradia génov v reťazci
    NewPop4 = invord (NewPop4, mutRate); % Inverzia subreťazcov
 
    pop = [NewPop1; NewPop2; NewPop3; NewPop4]; % Uloženie novej populácie
end
    figure(1);
    plot(Graph(i,:));    % Vykreslenie grafu
    hold on;
end 

Optimal_group   = Best_Group;   % Optimalna skupina
Optimal_Fitness = Graph(i,end); % Optimalne riesenie

% Naplnenie matice A optimalnou skupinou
for k = 1:genes  
    A(k+1,:) = B(Optimal_group(k),:);
end

% Graf
title("Graf evolúcie fitness"); % Názov grafu
xlabel('Generacie'); % Označenie osi x
ylabel('F(x)');      % Označenie osi y
hold off;

% Graf s optimalnou cestou
figure(2);
plot(A(:,1), A(:, 2),'.-', 'LineWidth', 1, 'MarkerSize', 30);
title("Graf optimalnej skupiny"); % Názov grafu
xlabel('x'); % Označenie osi x
ylabel('y');      % Označenie osi y

% Výpis riešenia
fprintf("Optimalne riesenie je: ");
disp(Optimal_Fitness);

fprintf("Poradie: ");
disp(Optimal_group);