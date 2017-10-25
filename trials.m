clear; clc; close all;

%load('Datos/features.mat'); % Matriz de caracteristicas 'Z' y vector de labels 'd'
load('Datos/featuresNew.mat');
load('Datos/indexes.mat'); %tiene un arreglo 'G' de 5 structs con los atributos 'G(g).x_train' y 'G(g)x_test' donde g de 1 a 4 son para el crossVal y g=5 es para holdOut, se calcula con la funcion 'getIndexes'

%% Opciones de ejecucion
% opciones generales
op.mode = 0; % 0: holdOut, 1:crossVal
op.features = 'orig'; %puede ser 'orig', 'histeq', 'DOG' o 'joe'

% opciones de seleccion
sel_op.mode = 'PCA'; % puede ser 'SFS' p 'PCA' o 'JAY'
sel_op.kPCA = 100; % para JAY
sel_op.k = 50; % si es para JAY este k es el del sfs final

[op, Z] = optionProcessing(op, sel_op, Z);
options = sel_op;

%featureIndexes(1,2) = 0;

% PCA by feature type
stepsPCA = struct;
Y = [];
if (strcmp(op.features,'joe'))
    fixStartPoint = featureIndexes(1,end);
    for i = 0:2
        stepsJoe = struct;
        [YJoe,stepsJoe] = featureTypePCA(Z,stepsJoe,options,featureIndexes,i*fixStartPoint);
        stepsPCA(i+1).joePCA = stepsJoe; 
        Y = [Y YJoe];
    end
else
    [Y,stepsPCA] = featureTypePCA(Z,stepsPCA,options,featureIndexes,0);
end
sel_data.PCA = stepsPCA;
sel_data.PCA = stepsPCA;