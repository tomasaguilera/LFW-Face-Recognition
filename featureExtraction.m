clt;
clc;
warning off;
%% Input and Function Handling
% Heavy file
load('preprocessedImages.mat');

% Set features
options.LBP_4x4 = true;
options.LBP_5x5 = true; % It does the same as 6x6 because of dimensions
options.LBP_6x6 = true;
options.LBP_ri = true;
options.Haralick = true;
options.Gabor = true;
options.HoG = true;
%% FeatureExtraction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opciones de los metodos de extraccion

options.op_lbp_4x4 = struct('vdiv', 4, 'hdiv', 4, 'semantic', 0, 'samples', 8, 'mappingtype', 'u2');
options.op_lbp_6x6 = struct('vdiv', 6, 'hdiv', 6, 'semantic', 0, 'samples', 8, 'mappingtype', 'u2');
options.op_lbp_5x5 = struct('vdiv', 5, 'hdiv', 5, 'semantic', 0, 'samples', 8, 'mappingtype', 'u2');
options.op_lbp_ri = struct('vdiv', 1, 'hdiv', 1, 'semantic', 0, 'samples', 8, 'mappingtype', 'ri');
% Hara
options.op_hara = struct('dharalick', 3);

% Gabor
options.op_gabor.Lgabor  = 8;                 % number of rotations
options.op_gabor.Sgabor  = 8;                 % number of dilations (scale)
options.op_gabor.fhgabor = 2;                 % highest frequency of interest
options.op_gabor.flgabor = 0.1;               % lowest frequency of interest
options.op_gabor.Mgabor  = 21;                % mask size
options.op_gabor.show    = 0;                 % display results

% HoG
options.op_hog.nj = 20;
options.op_hog.ni = 10;
options.op_hog.B = 9;
options.op_hog.show = 0;
%%
disp('Extrayendo caracteristicas de imagenes originales'); tic;
Z.orig = getFeatureMatrix(faces.images, options, 'Orig features...');
fprintf('Tiempo de computo: %5.4f segundos\n\n', toc);
%{}
if faces.processingSteps.histeq
    disp('Extrayendo caracteristicas de "histeq"'); tic;
    Z.histeq = getFeatureMatrix(faces.histeqImages, options, 'Histeq features...');
    fprintf('Tiempo de computo: %5.4f segundos\n\n', toc);
end

if faces.processingSteps.DOG
    disp('Extrayendo caracteristicas de "DOG"'); tic;
    Z.DOG = getFeatureMatrix(faces.DOGImages, options, 'DOG features...');
    fprintf('Tiempo de computo: %5.4f segundos\n\n', toc);
end

if faces.processingSteps.gamma
    disp('Extrayendo caracteristicas de "gamma"'); tic;
    Z.gamma = getFeatureMatrix(faces.gammaImages, options, 'Gamma features...');
    fprintf('Tiempo de computo: %5.4f segundos\n\n', toc);
end

if faces.processingSteps.FFT
    disp('Extrayendo caracteristicas de "FFT"'); tic;
    Z.FFT = getFeatureMatrix(faces.FFTImages, options, 'FFT features...');
    fprintf('Tiempo de computo: %5.4f segundos\n\n', toc);
end

Z.processingSteps = faces.processingSteps;
d = faces.labels;
%% Feautre Indexing 
featureIndexes = featureIndexing(faces.DOGImages(:,:,1),options);
save('featuresNew.mat', 'Z', 'd','featureIndexes');
%}

