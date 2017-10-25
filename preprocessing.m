clt;
clc;
%% Input and Function Handling
load('images.mat');

numImages = length(faces.labels);
% Clear options for default case (just lfwa faces)
options.histeq = false;
options.DOG = false;
options.gamma = false;
options.FFT = false;

% Different Preprocessing options 
% Comment when necessary
options.histeq = true;
options.DOG = true;
%options.gamma = true;
%options.FFT = true;

faces.processingSteps = options;

%% Examples of PreProcessing
% They include tic-toc for estimate of time of computation
%{
tic;
J = histeq(faces.images(:,:,1));
toc;
figure
imshow(faces.images(:,:,1))
figure
imshow(J)
%}

%{
tic;
JBig = imgaussfilt(faces.images(:,:,1),5);
JSmall = imgaussfilt(faces.images(:,:,1),0.5);
DOGExample = JSmall-JBig;
toc;
figure
imshow(JBig)
figure
imshow(JSmall);
figure
imshow(DOGExample)
%}

%% PreProcessing
if options.histeq
    % Histogram equalizaton
    faces.histeqImages = uint8(zeros(160,110,numImages));
    for i = 1:numImages
        J = histeq(faces.images(:,:,i));
        faces.histeqImages(:,:,i) = J;
    end
end
if options.DOG
    % Difference of Gaussian (edge highlighting)
    faces.DOGImages = uint8(zeros(160,110,numImages));
    k = 10;
    sigma1 = 0.5;
    sigma2 = sigma1*k;
    for i = 1:numImages
        JBig = imgaussfilt(faces.images(:,:,i),sigma2);
        JSmall = imgaussfilt(faces.images(:,:,i),sigma1);
        faces.DOGImages(:,:,i) = JSmall-JBig;
    end
end
if options.gamma
    % Gamma Correction
    faces.gammaImages = uint8(zeros(160,110,numImages)); 
end
if options.FFT
    % FFT
    faces.FFTImages = uint8(zeros(160,110,numImages));
end
% Saving preprocessed
save('preprocessedImages.mat','faces');