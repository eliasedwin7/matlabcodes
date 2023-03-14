% Function that takes an input image and a background image as input,
% then performs background subtraction.
% Returns: binary mask image of foreground object and foreground object
%          highlighted with the rest of the image being black
% Author: Roland Goecke
%
% Date created: 02/03/2021
% Date last changed: 24/02/2023
function [binMaskImg, cutOutImg] = ...
    computeBackgroundSubtractedImg(inputImg, backgroundImg)
% Compute difference image
diffImg = inputImg - backgroundImg;

% Find the minimum pixel value. Divide by 255 as we will need this value
% to be in the range of 0 to 1.
minPixelValue = double(min(min(diffImg)))/255.0;
disp(minPixelValue);

% Find the maximum pixel value. Divide by 255 as we will need this value
% to be in the range of 0 to 1.
maxPixelValue = double(max(max(diffImg)))/255.0;
disp(maxPixelValue);

% rescale the pixel range to 0-255 in red, green and blue separately
rescaledDiffImg = imadjust(diffImg, ...
                    [minPixelValue(1) minPixelValue(2) minPixelValue(3); ...
                     maxPixelValue(1) maxPixelValue(2) maxPixelValue(3)], ...
                 []);

             % Convert into greyscale image
greyDiffImg = rgb2gray(rescaledDiffImg);

% Threshold image
thresholdedImg = imbinarize(greyDiffImg, 0.1);

% Morphological operations 
% First, dilate the binary image
se = strel('disk', 4, 4);
dilatedImg = imdilate(thresholdedImg, se);

% Secondly, erode the dilated image
binMaskImg = imerode(dilatedImg, se);

% Now apply mask to original image
% Option 1 - Comment out one of the two options
% imgSize = size(binMaskImg);
% cutOutImg = inputImg;
% for iRow = 1:imgSize(1)
%     for iCol = 1: imgSize(2)
%         if (binMaskImg(iRow, iCol) == 0)
%             cutOutImg(iRow, iCol, :) = 0;
%         end
%     end
% end

% Option 2 (faster!) - Comment out one of the two options -
% Use a comparison and a bitwise AND.
cutOutImg = inputImg .* cast(binMaskImg, "uint8");
