clear; clc; close all;

% Nacitanie fuzzy systemu
f = readfis('Zadanie_7a.fis');
fuzzy(f);   % Zobrazenie fuzzy systemu

f1 = readfis('Zadanie_7b.fis');
fuzzy(f1);