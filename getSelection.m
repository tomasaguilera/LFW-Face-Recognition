function [ sel_data ] = getSelection( Z, d, options, featureIndexes )
    tic;
    
    ruta = options.sel_op.data_file;
    if options.mode
        ruta = [ruta(1:length(ruta)-6) 'G' num2str(options.g) '.mat'];
    end
    preProcessed = options.preprocessed;
    features = options.features;
    options = options.sel_op;
    
    options.preprocessed = preProcessed;
    options.features = features;
    if (options.calcular)
        if (strcmp(options.mode,'SFS'))
            
            Z = featuresUsed(Z,options,featureIndexes); % Features used - No poner afuera de los if
            feats = size(Z,2);
            if feats <= options.k
                op.m = feats;% features selected
            else
                op.m = options.k;% features selected
            end
            op.show = 0;                            % display results
            op.b.name = 'fisher';                   % SFS with Fisher
            sel_data.x = Bfs_sfs(Z,d,op);           % index of selected features
            
            save(ruta, 'sel_data');                 % guardar en archivo de datos
        elseif (strcmp(options.mode,'PCA'))
            Z = featuresUsed(Z,options,featureIndexes); % Features used - no poner afuera de los if
            feats = size(Z,2);
            if feats <= options.k
                m = feats;% features selected
            else
                m = 30;% features selected
            end
            [~,~,sel_data.A,~] = Bft_pca(Z,m);     % 30 principal components
            save(ruta, 'sel_data', '-v7.3');                 % guardar en archivo de datos
        elseif (strcmp(options.mode,'JAY'))
            % PCA by feature type
            stepsPCA = struct;
            Y = [];
            if (strcmp(preprocessed,'joe')) || (strcmp(preprocessed,'joeNew'))
                fixStartPoint = featureIndexes(1,end);
                for i = 0:2
                    stepsJoe = struct;
                    [YJoe,stepsJoe] = featureTypePCA(Z,stepsJoe,options,features,featureIndexes,i*fixStartPoint);
                    stepsPCA(i+1).joePCA = stepsJoe; 
                    Y = [Y YJoe];
                end
            else
                [Y,stepsPCA] = featureTypePCA(Z,stepsPCA,options,features,featureIndexes,0);
            end
            sel_data.PCA = stepsPCA;
            fprintf('Tiempo de PCA por partes: %5.4f segundos\n',toc);
            % SFS
            op.m = options.k;                       % features selected
            op.show = 0;                            % display results
            op.b.name = 'fisher';                   % SFS with Fisher
            sel_data.x = Bfs_sfs(Y,d,op);           % index of selected features 
            
            save(ruta, 'sel_data');                 % guardar en archivo de datos
        elseif (strcmp(options.mode,'JACK'))
            error('Error: seleccion "JACK" solo disponible con los archivos ya calculados (ej: 1111111)\n');
        else
            error('Error: selection_mode invalido!\n');
            fprintf('selection_mode invalido');     % modo de seleccion invalido
            sel_data = 'error';                     % modo de seleccion invalido
        end
    else
        load(ruta);         % importar de archivo de datos
    end
    fprintf('Tiempo de seleccion: %5.4f segundos\n', toc);
end

