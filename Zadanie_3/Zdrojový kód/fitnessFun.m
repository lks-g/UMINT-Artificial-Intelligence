function fitFun = fitnessFun(pop, table, maxMoney)
    fitFun = (zeros(size(pop, 1), 1)); % Space pre fitness funkciu
    
    for i = 1:size(pop, 1)
        penalty = 0;         % Pokuta
        index   = pop(i, :); % Prvok (x) v populacii
    
        for j = 1:size(pop, 2)
            penalty = penalty + pop(i, j) * (1 + table(j));
        end

        % Mrtva pokuta
        p1 = sum(index); % Ohraničenie p1
        if p1 >= maxMoney
            fitFun(i) = 10^5;
            continue;
        end
        
        % Stupňová pokuta
        p2 = sum(index(1:2)); % Ohraničenie p2
        if p2 >= maxMoney / 4 
             penalty = penalty - (2 * (p2 * maxMoney / 4)^4);
        end
  
        % Ohraničenie p3
        p3 = (-index(4)) + index(5); 
        if p3 >= 0
            penalty = penalty - p3;
        end

        % Pokuta podľa miery porušenia obmedzení
        p4 = (-0.5) * index(1) - 0.5 * index(2) + 0.5 * index(3) + 0.5 * index(4) - 0.5 * index(5);
        if p4 >= 0 % Ohraničenie p4
            penalty = 0;
        end
        fitFun(i) = (-1) * (penalty - sum(index));
    end
end