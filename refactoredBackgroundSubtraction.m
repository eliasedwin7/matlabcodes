% Refactored background subtraction example on thermal images
% Author: Roland Goecke
% Date created: 2 Mar 2021
% Date last updated: 24/02/2023

clear variables;
close all;
clc;

% Find all JPG image file names in a folder, here Images\Dingo\
% Rename to whatever folder your images are stored
dirName = 'images/';
fileNames = dir([dirName '*.jpeg']);
iNumImgFiles = size(fileNames);
figure(1);
for iF = 1:iNumImgFiles(1)
    disp(fileNames(iF).name);
    
    % Load image 
    inputImg = imread([dirName fileNames(iF).name]);
    if (iF == 1)
        backgroundImg = inputImg; % Note, this assumes that the first
        subplot(2, 2, 1);         % image in the folder is the background
        imshow(inputImg);
        title('Background Image');
    else                          % Other images
        subplot(2, 2, 2);
        imshow(inputImg);
        title('Current Image');
    
        % Now we can do the further processing in a separate function
        [binaryMaskImg, foregroundObjectImg] = ...
            computeBackgroundSubtractedImg(inputImg, backgroundImg);
        subplot(2, 2, 3);
        imshow(binaryMaskImg);
        title('Mask Image');
        subplot(2, 2, 4);
        imshow(foregroundObjectImg);
        title('Foreground Object');
    end
    pause;   % Wait for user to press a key before loading the next image
end