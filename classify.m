function [ class_data ] = classify( Z, d, x_train, x_test, sel_data, options, featureIndexes )
    tic;
    
    if strcmp(options.sel_op.mode, 'SFS')
        Z = featuresUsed(Z,options,featureIndexes); % No poner afuera de los if
        feats = size(Z,2);
        if feats <= options.sel_op.k
            %Z = Z;
        else
            Z = Z(:, sel_data.x);
        end
    elseif strcmp(options.sel_op.mode, 'PCA')
        Z = featuresUsed(Z,options,featureIndexes); % No poner afuera de los if
        Z = Z * sel_data.A;
        feats = size(Z,2);
        if feats <= options.sel_op.k
            %Z = Z;
        else
            Z = Z(:, 1:options.sel_op.k);
        end
    elseif strcmp(options.sel_op.mode,'JAY')
        Y = [];
        if (strcmp(options.features,'joe')) || (strcmp(options.features,'joeNew'))
            fixStartPoint = featureIndexes(1,end);
            % PCA Selection
            for i = 0:2
                lastIndex = 0;
                for ii = 1:length(featureIndexes)
                    if featureIndexes(ii) ~= 0
                       startIndex = lastIndex+1;
                       endIndex = featureIndexes(1,ii);
                       lastIndex = endIndex;

                       ZPart = Z(:,(fixStartPoint*i+startIndex):(fixStartPoint*i+endIndex));
                       YJoe = ZPart * sel_data.PCA(i+1).joePCA(ii).A;
                       if options.kPCA <= size(ZPart,2)
                           YJoe = YJoe(:,1:options.sel_op.kPCA);
                       else
                           YJoe = YJoe;
                       end
                    else
                       YJoe = [];
                    end
                    Y = [Y YJoe];
                end
            end
        else
            %i = 0;
            lastIndex = 0;
            for ii = 1:length(featureIndexes)
                if featureIndexes(ii) ~= 0
                   startIndex = lastIndex+1;
                   endIndex = featureIndexes(1,ii);
                   lastIndex = endIndex;

                   ZPart = Z(:,(startIndex):(endIndex));
                   YJoe = ZPart * sel_data.PCA(ii).A;
                   if options.sel_op.kPCA <= size(ZPart,2)
                       YJoe = YJoe(:,1:options.sel_op.kPCA);
                   else
                       YJoe = YJoe;
                   end
                else
                   YJoe = [];
                end
                Y = [Y YJoe];
            end
        end
        % SFS Selection
        Z = Y(:,sel_data.x);
    end
    
    if strcmp(options.sel_op.mode,'JACK')
        k = options.sel_op.k;
        Z0 = sel_data.Z0;
        Z_train = Z0.concat(x_train, :);
        Z_test = Z0.concat(x_test, :);
        [~,~,A,~] = Bft_pca(Z_train, k);     % 30 principal components
        Z_train = Z_train * A;
        Z_train = Z_train(:, 1:k);
        Z_test = Z_test * A;
        Z_test = Z_test(:, 1:k);
    else
        Z_train = Z(x_train, :);
        Z_test = Z(x_test, :);
    end
    d_train = d(x_train);
    d_test = d(x_test);
    
    %normalizar
    [E,a,b] = Bft_norm(Z_train,1);
    n_test = size(Z_test,1);
    T = (ones( n_test, 1) * a).*Z_test + ones( n_test, 1)*b;
    
    i = 1;
    %{
    % KNN classifier
    for k = [1 3 5 7 10 15];
        op.k = k;
        class_data(i).d = Bcl_knn(E,d_train,T,op);
        class_data(i).string = ['KNN con k = ' num2str(op.k)];
        i = i + 1;
    end
    %}
    
    %LDA
    op.p=[];
    class_data(i).d = Bcl_lda(E,d_train,T,op);
    class_data(i).string = 'LDA';
    
    if options.mode == 0
        %SVM - ECOC
        i=i+1;

        Mdl = fitcecoc(E,d_train);
        class_data(i).d = predict(Mdl,T);
        class_data(i).string = 'SVM - ECOC';


        %FitEnsemble Bag
        i=i+1;

        Mdl = fitensemble(E,d_train,'Bag',5//0,'Discriminant','Type','classification');
        class_data(i).d = predict(Mdl,T);
        class_data(i).string = 'FitEnsemble Bag - Discriminant';


        %Neural Net SoftMax
        i=i+1;
        options.method = 3;
        options.iter = 1;
        class_data(i).d = Bcl_nnglm(E,d_train,T,options);
        class_data(i).string = 'Neural Network SoftMax';

        %Neural Net 2
        i=i+1;
        options.method = 1;
        options.iter = 10;
        class_data(i).d = Bcl_nnglm(E,d_train,T,options);
        class_data(i).string = 'Neural Network Linear';

        %Mayoria voto
        G=[class_data(1).d class_data(3).d class_data(4).d];

        i=i+1;
        for j = 1:length(class_data(1).d)
            f = G(j,:);
            [M, F, C] = mode(f);
            if length(C)>1
                class_data(i).d(j) = class_data(1).d(j);
            else class_data(i).d(j)=M;
            end
        end
        class_data(i).d=class_data(i).d';
        class_data(i).string = 'Mayoria voto';
    end
    %Performance
    for i = 1:length(class_data)
        class_data(i).p = Bev_performance(d_test,class_data(i).d);
    end
    

    %QDA
    %dsQDA = Bcl_qda(E,d_train,T,op);
    %pQDA = Bev_performance(d_test,dsQDA)

    %Neural Net
    %{
    options.method = 3;
    options.iter = 1;
    dsNN = Bcl_nnglm(E,d_train,T,options);
    pNN = Bev_performance(d_test,dsNN)


    dsSVM = Bcl_pnn(E,d_train,T,[]);
    pSVM = Bev_performance(d_test,dsSVM)
    %}

    %{
    %SVM lineal
    options.kernel=1;
    dsSVML = Bcl_svmplus(E,d_train,T,options);
    pSVML = Bev_performance(d_test,dsSVML)

    %SVM quadratic
    options.kernel=2;
    dsSVMQ = Bcl_svmplus(E,d_train,T,options);
    pSVMQ = Bev_performance(d_test,dsSVMQ)


    %SVM polynomial
    options.kernel=3;
    dsSVMP = Bcl_svmplus(E,d_train,T,options);
    pSVMP = Bev_performance(d_test,dsSVMP)

    %SVM rbf
    options.kernel=4;
    dsSVMrbf = Bcl_svmplus(E,d_train,T,options);
    pSVMrbf = Bev_performance(d_test,dsSVMrbf)

    %SVM mlp
    options.kernel=5;
    dsSVMmlp = Bcl_svmplus(E,d_train,T,options);
    pSVMmlp = Bev_performance(d_test,dsSVMmlp)
    %}

    fprintf('Tiempo de clasificacion: %5.4f segundos\n', toc);
end

