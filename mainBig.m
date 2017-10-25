clear;
clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% No usar en CV
load('Datos/indexes.mat'); %tiene un arreglo 'G' de 5 structs con los atributos 'G(g).x_train' y 'G(g)x_test' donde g de 1 a 4 son para el crossVal y g=5 es para holdOut, se calcula con la funcion 'getIndexes'
load('Datos/featuresNew.mat', 'd', 'featureIndexes');

preProcess = {'origNew','histeqNew','DOGNew','joeNew'};
sel_op.mode = 'PCA'; % puede ser 'SFS', 'PCA' o 'JAY'
sel_op.kPCA = 1000; % solo importa para JAY
sel_op.k = 600; % si es para JAY este k es el del sfs final
% ojo con los números acá, k tiene que ser harto menor que kPCA*5
%% Cada Feat por Separado
%{
p = zeros(4,7);
for proc = 1:4
    for i = 1:7
        op.features = zeros(1,7);
        op.features(i) = 1;
        printConsole = true;
        op.mode = 0; % 0: holdOut, 1:crossVal
        op.preprocessed = preProcess{proc}; %puede ser 'orig', 'histeq', 'DOG' o 'joe', 'origNew', 'histeqNew', 'DOGNew', 'joeNew'
        %op.features = [0 0 0 1 0 0 0]; % cada posicion es si se va a usar esa característica y es 1 o 0
        % Tabla numeración
        % Posición en op.features : Tipo de característica
        % 1: LBP 4x4
        % 2: LBP 5x5
        % 3: LBP 6x6
        % 4: LBP_ri
        % 5: Haralick
        % 6: Gabor
        % 7: HoG

        [op, Z] = optionProcessing(op, sel_op, printConsole);

        a = struct;
        if (op.mode == 1) % crossVal
            fprintf('\nCross Validation \n');
            for g = 1:4
                fprintf('\nProcesando con grupo %d como Test data \n', g);
                op.g = g;
                a(g).data = holdOut(Z, d, G(g).x_train, G(g).x_test, op, featureIndexes);
            end
            p(proc,i) = 100*[a(1).data.p a(2).data.p a(3).data.p a(4).data.p]';
            fprintf('\nDesempeños: %5.4f, %5.4f, %5.4f, %5.4f \n', p(1), p(2), p(3), p(4));
            fprintf('Desempeño medio: %5.4f porciento \n', mean(p));
            fprintf('Desviacion estandar: %5.4f porciento \n\n', std(p));
        else % holdOut
            fprintf('\n\nHold Out \n\n');
            a.data = holdOut(Z, d, G(5).x_train, G(5).x_test, op, featureIndexes);
            p(proc,i) = 100*a.data.p;
            fprintf('Desempeño: %5.4f porciento \n', p(proc,i));

        end
        clear a op Z
    end
end
save('pByFeatures.mat','p');
%}
%% LBP_5x5_HoG
%{
p = zeros(4,7);
for proc = 1:4
    for i = 4:6
        op.features = zeros(1,7);
        op.features(2) = 1;
        op.features(7) = 1;
        op.features(i) = 1;
        printConsole = true;
        op.mode = 0; % 0: holdOut, 1:crossVal
        op.preprocessed = preProcess{proc}; %puede ser 'orig', 'histeq', 'DOG' o 'joe', 'origNew', 'histeqNew', 'DOGNew', 'joeNew'
        %op.features = [0 0 0 1 0 0 0]; % cada posicion es si se va a usar esa característica y es 1 o 0
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


        [op, Z] = optionProcessing(op, sel_op, printConsole);

        a = struct;
        if (op.mode == 1) % crossVal
            fprintf('\nCross Validation \n');
            for g = 1:4
                fprintf('\nProcesando con grupo %d como Test data \n', g);
                op.g = g;
                a(g).data = holdOut(Z, d, G(g).x_train, G(g).x_test, op, featureIndexes);
            end
            p(proc,i) = 100*[a(1).data.p a(2).data.p a(3).data.p a(4).data.p]';
            fprintf('\nDesempeños: %5.4f, %5.4f, %5.4f, %5.4f \n', p(1), p(2), p(3), p(4));
            fprintf('Desempeño medio: %5.4f porciento \n', mean(p));
            fprintf('Desviacion estandar: %5.4f porciento \n\n', std(p));
        else % holdOut
            fprintf('\n\nHold Out \n\n');
            a.data = holdOut(Z, d, G(5).x_train, G(5).x_test, op, featureIndexes);
            p(proc,i) = 100*a.data.p;
            fprintf('Desempeño: %5.4f porciento \n', p(proc,i));

        end
        clear a op Z
    end
end
save('p_LBP5x5_HoG_Extra.mat','p')
%}
%% LBP_6x6_HoG
%{
p = zeros(4,7);
for proc = 1:4
    for i = 4:6
        op.features = zeros(1,7);
        op.features(3) = 1;
        op.features(7) = 1;
        op.features(i) = 1;
        printConsole = true;
        op.mode = 0; % 0: holdOut, 1:crossVal
        op.preprocessed = preProcess{proc}; %puede ser 'orig', 'histeq', 'DOG' o 'joe', 'origNew', 'histeqNew', 'DOGNew', 'joeNew'
        %op.features = [0 0 0 1 0 0 0]; % cada posicion es si se va a usar esa característica y es 1 o 0
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


        [op, Z] = optionProcessing(op, sel_op, printConsole);

        a = struct;
        if (op.mode == 1) % crossVal
            fprintf('\nCross Validation \n');
            for g = 1:4
                fprintf('\nProcesando con grupo %d como Test data \n', g);
                op.g = g;
                a(g).data = holdOut(Z, d, G(g).x_train, G(g).x_test, op, featureIndexes);
            end
            p(proc,i) = 100*[a(1).data.p a(2).data.p a(3).data.p a(4).data.p]';
            fprintf('\nDesempeños: %5.4f, %5.4f, %5.4f, %5.4f \n', p(1), p(2), p(3), p(4));
            fprintf('Desempeño medio: %5.4f porciento \n', mean(p));
            fprintf('Desviacion estandar: %5.4f porciento \n\n', std(p));
        else % holdOut
            fprintf('\n\nHold Out \n\n');
            a.data = holdOut(Z, d, G(5).x_train, G(5).x_test, op, featureIndexes);
            p(proc,i) = 100*a.data.p;
            fprintf('Desempeño: %5.4f porciento \n', p);

        end
        clear a op Z
    end
end
save('p_LBP6x6_HoG_Extra.mat','p')
%}
%% LBP_5x5_6x6_HoG
%{}
p = zeros(4,7);
proc = 4; % solo joe
for i = 4:6
    op.features = zeros(1,7);
    op.features(2) = 1;
    op.features(3) = 1;
    op.features(7) = 1;
    op.features(i) = 1;
    printConsole = true;
    op.mode = 0; % 0: holdOut, 1:crossVal
    op.preprocessed = preProcess{proc}; %puede ser 'orig', 'histeq', 'DOG' o 'joe', 'origNew', 'histeqNew', 'DOGNew', 'joeNew'
    %op.features = [0 0 0 1 0 0 0]; % cada posicion es si se va a usar esa característica y es 1 o 0
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


    [op, Z] = optionProcessing(op, sel_op, printConsole);

    a = struct;
    if (op.mode == 1) % crossVal
        fprintf('\nCross Validation \n');
        for g = 1:4
            fprintf('\nProcesando con grupo %d como Test data \n', g);
            op.g = g;
            a(g).data = holdOut(Z, d, G(g).x_train, G(g).x_test, op, featureIndexes);
        end
        p(proc,i) = 100*[a(1).data.p a(2).data.p a(3).data.p a(4).data.p]';
        fprintf('\nDesempeños: %5.4f, %5.4f, %5.4f, %5.4f \n', p(1), p(2), p(3), p(4));
        fprintf('Desempeño medio: %5.4f porciento \n', mean(p));
        fprintf('Desviacion estandar: %5.4f porciento \n\n', std(p));
    else % holdOut
        fprintf('\n\nHold Out \n\n');
        a.data = holdOut(Z, d, G(5).x_train, G(5).x_test, op, featureIndexes);
        p(proc,i) = 100*a.data.p;
        fprintf('Desempeño: %5.4f porciento \n', p);

    end
    clear a p op Z
end

save('p_LBP56x56_HoG_Extra.mat','p')
%}