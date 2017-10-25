function [ op, Z ] = optionProcessing( op, sel_op, printConsole )

    tablaFeatures = {'LBP 4x4','LBP 5x5', 'LBP 6x6', 'LBP_ri','Haralick','Gabor','HoG'};
    % New o Old
    len = length(op.preprocessed);
    if strcmp(op.preprocessed(len-2:len),'New')
        load('Datos/featuresNew.mat', 'Z');
        if printConsole
           fprintf('Usando New\n') 
        end
    else
        load('Datos/features.mat', 'Z'); % Matriz de caracteristicas 'Z' y vector de labels 'd'
        if printConsole
           fprintf('Usando antiguas\n') 
        end
    end
    % Tipo de preprocesamiento usado
	switch op.preprocessed(1:3)
        case 'ori'
            Z = Z.orig;
            if printConsole
                fprintf('Usando imágenes originales\n') 
            end
        case 'his'
            Z = Z.histeq;
            if printConsole
                fprintf('Usando histogramas equalizados\n') 
            end
        case 'DOG'
            Z = Z.DOG;
            if printConsole
                fprintf('Usando DoG\n') 
            end
        case 'joe'
            Z = [Z.orig Z.histeq Z.DOG];
            if printConsole
                fprintf('Usando joe\n') 
            end
        otherwise
            error('Error: op.preprocessed invalido!\n');
	end
    %sel_op.data_file = 'HO_SFS_150_joe.mat';
    %sel_op.calcular = 0; % 0 : importar 'sel_data' desde 'sel_op.data_file', 1 : calcular 'sel_data' y guardar en 'sel_op.data_file'
    
    ruta = '';
    % Tipo de caracteristicas
    if printConsole
        fprintf('Usando características:\n') 
    end
    
    for i = 1:length(op.features)
        if op.features(i) == 1
            ruta = [ruta '1'];
            if printConsole
                fprintf('\t%s\n',tablaFeatures{i}); 
            end
        else
            ruta = [ruta '0'];
        end
    end
    
    ruta = [ruta '_'];
    % Tipo de seleccion
    if printConsole
        fprintf('Seleccionando con %s ',sel_op.mode)
        fprintf('y con %d caracteristicas\n',sel_op.k)
    end
    
    if (strcmp(sel_op.mode, 'PCA'))
        ruta = [ruta sel_op.mode '_' op.preprocessed];
    elseif (strcmp(sel_op.mode, 'JACK'))
        ruta = [ruta sel_op.mode];
    else
        ruta = [ruta sel_op.mode '_' num2str(sel_op.k) '_' op.preprocessed];
    end

    if (strcmp(sel_op.mode,'JAY'))
        ruta = [ruta '_' num2str(sel_op.kPCA)];
    end
    
    
    % Final y tipo de evaluacion
    if op.mode
        ruta = ['Datos/CV_' ruta '_G4.mat']; %para crossVal
    else
        ruta = ['Datos/HO_' ruta '.mat'];   %para holdOut
    end
    sel_op.data_file = ruta;
    
    
    if (exist(ruta) == 2)
        sel_op.calcular = 0;
        fprintf('Archivo(s) de datos SI existe(n), NO se calcularan datos de seleccion\n');
    else
        sel_op.calcular = 1;
        fprintf('Archivo(s) de datos NO existe(n), SI se calcularan datos de seleccion\n');
    end
    op.sel_op = sel_op;
end

