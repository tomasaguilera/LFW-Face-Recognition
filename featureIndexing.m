function [ indexes] = featureIndexing( image, options )
%FEATUREINDEXING Gives the indexes for each set of features
% According to the features extracted (LBP_4x4, LBP_ri, etc)
% gives the column index in the feature matrix for those type of features.
% Example:
% LBP_4x4 are 59*4*4 features and are the first to be extracted
% Therefore the LBP_4x4 are from 1 to 944
J = image;
lastIndex = 1;
indexes = zeros(1,7);
if options.LBP_4x4
    [X, ~] = Bfx_lbp(J,[],options.op_lbp_4x4);                              % LBP features
    lastIndex = size(X,2);
    indexes(1,1) = lastIndex;
else
    X = [];
end

if options.LBP_5x5
    [X, ~] = Bfx_lbp(J,[],options.op_lbp_5x5);
    lastIndex = size(X,2)+lastIndex;
    indexes(1,2) = lastIndex;
else
    X = [];
end

if options.LBP_6x6
    [X, ~] = Bfx_lbp(J,[],options.op_lbp_5x5);
    lastIndex = size(X,2)+lastIndex;
    indexes(1,3) = lastIndex;                              % LBP features
else
    X = [];
end

if options.LBP_ri
    [X, ~] = Bfx_lbp(J,[],options.op_lbp_ri);                        % LBP features
    lastIndex = size(X,2)+lastIndex;
    indexes(1,4) = lastIndex;
else
    X = [];
end

if options.Haralick
    [X, ~] = Bfx_haralick(J,options.op_hara);                        % Haralick features
    lastIndex = size(X,2)+lastIndex;
    indexes(1,5) = lastIndex;
else
    X = [];
end

if options.Gabor
    [X,~] = Bfx_gabor(J, options.op_gabor);
    lastIndex = size(X,2)+lastIndex;
    indexes(1,6) = lastIndex;
else
    X = [];
end

if options.HoG
    [X, ~] = Bfx_hog(J, options.op_hog);
    lastIndex = size(X,2)+lastIndex;
    indexes(1,7) = lastIndex;
else
    X = [];
end

end

