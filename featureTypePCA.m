function [Y,stepsPCA] = featureTypePCA(Z,stepsPCA,options,features,featureIndexes,fixStartPoint)
%FEATURETYPEPCA Summary of this function goes here
%   Detailed explanation goes here
Y = [];
lastIndex = 0;
for i = 1:length(featureIndexes)

    if features(i) ~= 0
       startIndex = lastIndex+1;
       endIndex = featureIndexes(1,i);
       lastIndex = endIndex;

       ZPart = Z(:,(fixStartPoint+startIndex):(fixStartPoint+endIndex));
       % If I request more than there are, use them all
       if options.kPCA <= size(ZPart,2)
           [YPCA,~,stepsPCA(i).A,~] = Bft_pca(ZPart,options.kPCA);
       else
           [YPCA,~,stepsPCA(i).A,~] = Bft_pca(ZPart,size(ZPart,2));
       end
    else
       YPCA = [];
       stepsPCA(i).A = [];
    end
    Y = [Y YPCA];

end

