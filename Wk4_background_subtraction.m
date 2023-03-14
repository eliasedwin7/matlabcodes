% Background subtraction example on thermal images of a dingo. The example
% images come from a video sequence, but only a select few are shown here.
% Author: Roland Goecke
%
% Date created: 02/03/2018
% Date last updated: 24/02/2023

clear variables;
close all;
clc;

% Load images *** Change file path to your current settings! ***
backgroundImg = imread('DINGO3_Background.jpeg');
dingoImg = imread('DINGO3_Frame0.jpeg');

% Display images
figure(1);
subplot(2, 4, 1);
imshow(backgroundImg);
title('Background only');

subplot(2, 4, 2);
imshow(dingoImg);
title('Dingo (Frame 0)');

% Compute difference image
% (Literally, subtract the background image from the current image.)
diffImg = dingoImg - backgroundImg;

% Find the minimum pixel value. Divide by 255 as we will need this value
% to be in the range of 0 to 1.
minPixelValue = double(min(min(diffImg)))/255.0;
disp('Min Pixel Value for Red, Green, Blue channels:');
disp(minPixelValue);

% Find the maximum pixel value. Divide by 255 as we will need this value
% to be in the range of 0 to 1.
maxPixelValue = double(max(max(diffImg)))/255.0;
disp('Max Pixel Value for Red, Green, Blue channels:');
disp(maxPixelValue);

% Display difference image without rescaling
subplot(2, 4, 3);
imshow(diffImg);
title('Difference Image');

% Rescale pixel values to [0, 255] using imadjust, then display the
% difference image after rescaling
rescaledDiffImg = imadjust(diffImg, ...
                    [minPixelValue(1) minPixelValue(2) minPixelValue(3); ...
                     maxPixelValue(1) maxPixelValue(2) maxPixelValue(3)], ...
                 []);
subplot(2, 4, 4);
imshow(rescaledDiffImg);
title('Difference Image Rescaled');

% Convert into greyscale image
greyDiffImg = rgb2gray(rescaledDiffImg);
subplot(2, 4, 5);
imshow(greyDiffImg);
title('Greyscale Image Rescaled');

% Threshold image
thresholdedImg = imbinarize(greyDiffImg, 0.1);
subplot(2, 4, 6);
imshow(thresholdedImg);
title('Thresholded Image');

% Morphological operations 
% First, dilate the binary image
se = strel('disk', 4, 4);
dilatedImg = imdilate(thresholdedImg, se);
subplot(2, 4, 7);
imshow(dilatedImg);
title('Image Dilation');

% Secondly, erode the dilated image
erodedImg = imerode(dilatedImg, se);
subplot(2, 4, 8);
imshow(erodedImg);
title('Image Erosion');

% Now apply mask to original image
imgSize = size(erodedImg);

% Option 1 - Comment out one of the two options
% maskedOrigImg = dingoImg;
% for iRow = 1:imgSize(1)
%     for iCol = 1: imgSize(2)
%         if (erodedImg(iRow, iCol) == 0)
%             maskedOrigImg(iRow, iCol, :) = 0;
%         end
%     end
% end

% Option 2 (faster!) - Comment out one of the two options -
% Use a comparison and a bitwise AND.
maskedOrigImg = dingoImg .* cast(erodedImg, "uint8");

figure(2);
imshow(maskedOrigImg);
title('Final Output');
