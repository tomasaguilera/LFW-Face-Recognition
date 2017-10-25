function [ X ] = featuresUsed( Z,options,featureIndexes)
%FEATURESUSED Summary of this function goes here
%   Detailed explanation goes here
    if (strcmp(options.preprocessed,'joe')) || (strcmp(options.preprocessed,'joeNew'))
        preProcessedIndex = 2;
    else
        preProcessedIndex = 0;
    end
    X = [];
    fixStartPoint = featureIndexes(1,end);
    for i = 0:preProcessedIndex
        lastIndex = 0;
        for ii = 1:length(options.features)
            startIndex = lastIndex+1;
            endIndex = featureIndexes(1,ii);
            lastIndex = endIndex;
            if options.features(ii) == 1
                X = [X Z(:,(fixStartPoint*i+startIndex):(fixStartPoint*i+endIndex))];
            end
        end
    end
end

