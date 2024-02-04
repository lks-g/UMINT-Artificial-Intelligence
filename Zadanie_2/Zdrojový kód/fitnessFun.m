function pathFun = fitnessFun(B, pop)
   [r,c] = size(pop);
   for i = 1:r
        dist = 0;
        for j = 2:c
            a = B(pop(i, j-1), 1) - B(pop(i, j), 1); 
            b = B(pop(i, j-1), 2) - B(pop(i, j), 2);
            dist = dist + sqrt(a^2 + b^2);
        end
        dist = dist + sqrt(B(pop(i,1),1)^2 + B(pop(i,1),2)^2) + sqrt((100 - B(pop(i, end), 1))^2 + (100 - B(pop(i, end), 2))^2);
        pathFun(i) = dist;
    end
end
