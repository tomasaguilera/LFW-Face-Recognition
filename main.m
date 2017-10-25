clear; clc; close all;

%% Opciones de ejecucion
% opciones generales
printConsole = true;
op.mode = 0; % 0: holdOut, 1:crossVal
op.preprocessed = 'joeNew'; %puede ser 'orig', 'histeq', 'DOG' o 'joe', 'origNew', 'histeqNew', 'DOGNew', 'joeNew'
op.features = [1 1 1 1 1 1 1]; % cada posicion es si se va a usar esa característica y es 1 o 0
% Tabla numeración
% Posición en op.features : Tipo de característica
% 1: LBP 4x4
% 2: LBP 5x5
% 3: LBP 6x6
% 4: LBP_ri
% 5: Haralick
% 6: Gabor
% 7: HoG
% opciones de seleccion
sel_op.mode = 'JACK'; % puede ser 'SFS', 'PCA' o 'JAY'
sel_op.kPCA = 1000; % solo importa para JAY
sel_op.k = 500; % si es para JAY este k es el del sfs final
% ojo con los números acá, k tiene que ser harto menor que kPCA*5

[op, Z] = optionProcessing(op, sel_op, printConsole);

%% Ejecucion
load('Datos/indexes.mat'); %tiene un arreglo 'G' de 5 structs con los atributos 'G(g).x_train' y 'G(g)x_test' donde g de 1 a 4 son para el crossVal y g=5 es para holdOut, se calcula con la funcion 'getIndexes'
load('Datos/featuresNew.mat', 'd', 'featureIndexes');
a = struct;
if (op.mode == 1) % crossVal
    fprintf('\nCross Validation \n');
    for g = 1:4
        fprintf('\nProcesando con grupo %d como Test data \n', g);
        op.g = g;
        a(g).data = holdOut(Z, d, G(g).x_train, G(g).x_test, op, featureIndexes);
    end
    p = 100*[a(1).data.p a(2).data.p a(3).data.p a(4).data.p]';
    fprintf('\nDesempeños: %5.4f, %5.4f, %5.4f, %5.4f \n', p(1), p(2), p(3), p(4));
    fprintf('Desempeño medio: %5.4f porciento \n', mean(p));
    fprintf('Desviacion estandar: %5.4f porciento \n\n', std(p));
else % holdOut
    fprintf('\n\nHold Out \n\n');
    a.data = holdOut(Z, d, G(5).x_train, G(5).x_test, op, featureIndexes);
    for i = 1:length(a.data)
        p = 100*a.data(i).p;
        a.data(i).string
        fprintf('Desempeño: %5.4f porciento \n', p);
    end
    
end




