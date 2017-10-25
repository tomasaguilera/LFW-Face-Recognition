clc; close all;
load('features.mat', 'd'); % Se necesita el vector 'd'

d_max = max(d);
n = size(d, 1);
%% Hacer los 4 grupos para crossVal

n_clases = zeros(d_max , 1);    % n_clases(i) es la cantidad de muestras de clase i
n_G = zeros(d_max, 4);          % n_G(i, g) es la cantidad de muestras de clase i en el grupo g

for i = 1:d_max
    n_clase_i = sum(d == i);
    n_clases(i) = n_clase_i;
    n_G(i, 1:3) =  round(n_clase_i / 4);
    n_G(i,4) = n_clase_i - 3 * n_G(i, 1);
end

suma_n_G = sum(n_G, 1);         %suma_n_G(i) es la cantidad de muestras en el grupo i


%% Determinar los vectores de indices para cada grupo como conjunto de testing
G = struct;
for g = 1:4
    G(g).x_test = zeros(1, suma_n_G(g));
    G(g).x_train = zeros(1, n - suma_n_G(g));
end

for g = 1:4
    x = 0; y = 0;
    for dx = 1:d_max
        y = y + sum(n_G(dx,1:g-1));
        G(g).x_test(x+1:x+n_G(dx,g)) = y + (1:1:n_G(dx,g));
        x = x + n_G(dx,g);
        y = y + sum(n_G(dx, g:4));
    end
    
    x = 0;
    for i = 1:n
        if (sum(G(g).x_test == i) == 0)
            G(g).x_train(x+1) = i;
            x = x + 1;
        end
    end
end

%% G(5) sera para el holdout

G(5).x_train = zeros(1, d_max*10);
G(5).x_test = zeros(1, n - d_max*10);

x = 0; y = 0;
for dx = 1:d_max
    G(5).x_train(x+1:x+10) = y + (1:1:10);
    x = x + 10;
    y = y + n_clases(dx);
end
x = 0;
for i = 1:n
    if (sum(G(5).x_train == i) == 0)
        G(5).x_test(x+1) = i;
        x = x + 1;
    end
end

%%

save('indexes.mat', 'G');