function [ data ] = holdOut( Z, d, x_train, x_test, op, featureIndexes )
    %% Feature Selection
    sel_data = getSelection(Z(x_train,:), d(x_train), op, featureIndexes);
    
    %% Classification
    class_data = classify(Z, d, x_train, x_test, sel_data, op, featureIndexes);
    
    data = class_data;
end

