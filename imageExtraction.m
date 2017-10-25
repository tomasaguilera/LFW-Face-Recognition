clt;
clc;
warning off;
%% Import images from the specified folder
folder = 'faces_lfwa_3'; %Without ../
folder = '..\..\Tarea 2\faces_lfwa_3'; %Without ../

faces_lfwa = dir(folder);
% The useful files (images) start from the position 4 onwards;
% Images are in uint8 and are greyscale - not RGB.
[numberImages garbage] = size(faces_lfwa);
numberImages = numberImages-3; % = 4190
totalFaces = 143;
initFileIndex = 4;
classFaceAllFaces = zeros(numberImages,1);
faces.labels = zeros(4174,1); % class of images
faces.images = uint8(zeros(160,110,4174)); % size x images

%%
bar = Bio_statusbar('Extracting images...');
indexImage= 1;
for i = initFileIndex:numberImages+3
    bar = Bio_statusbar(i/(numberImages+3),bar);
    nameImage = faces_lfwa(i).name;
    nameSplit = strsplit(nameImage,'_'); % Splitting the string for useful counting
    checkForCopy = strsplit(strjoin(nameSplit(3)),' '); % Checking for (n) in the name
    faceID = str2double(nameSplit(2));
    if (length(checkForCopy) > 1)
        % Do nothing, it's a copy of a former image
    else
        % Image is not copy
        faces.labels(indexImage,1) = faceID;
        testImage = imread([folder '\' nameImage]);
        faces.images(:,:,indexImage) = testImage;
        indexImage = indexImage+1;
    end
end
delete(bar);
display('Images extracted')
save('images.mat','faces');
%}

