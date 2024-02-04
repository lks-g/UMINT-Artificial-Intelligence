% Zadanie 0 - horolezecký algoritmus na hľadanie globál. minima funkcie 1D

clc;           % Clear command window

xp = 5;       % Počiatočný bod
xkrok = 0.5;   % Krok hľadania
vzorky = 1000; % Počet vzoriek

% Susedné body
xs1 = xp - xkrok; 
xs2 = xp + xkrok;

% Hodnota funkcie
ys1 = funkcia1D(xs1);
ys2 = funkcia1D(xs2);
yp  = funkcia1D(xp);

x_g = -6:0.1:6;         % Rozsah grafu
y_g = funkcia1D(x_g);

for i = 1:vzorky
    plot(x_g, y_g, 'b') % Vytvorenie grafu
    xlabel('x');        % Označenie osi x
    ylabel('y');        % Označenie osi y
    title('Horolezecký algoritmus'); % Názov grafu
    plot(xp, yp, '+g','LineWidth',1) % Pridanie zelených bodov '+'
    hold on;            

    if (ys1 < yp)
        xp = xs1;
    
    elseif (ys2 < yp)
        xp = xs2;
    end

    % Susedné body
    xs1 = xp - xkrok; 
    xs2 = xp + xkrok;
    % Hodnota funkcie
    ys1 = funkcia1D(xs1);
    ys2 = funkcia1D(xs2);
    yp  = funkcia1D(xp);
end

plot(xp, yp, '*r', 'LineWidth', 1)  % Minimum v grafe;
fprintf(' Minimum funkcie \n Súradnica xp: %f \n Súradnica yp: %f\n', xp, yp); % Vypísanie súradníc



