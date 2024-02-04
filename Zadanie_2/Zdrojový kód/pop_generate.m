function pop = pop_generate(population, genes)
    for i = 1:population
        pop(i,:) = randperm(genes);
    end
    pop(:) = pop + 1;
end