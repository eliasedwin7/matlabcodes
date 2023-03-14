% Colour Analysis function converting RGB to HSV in preparation
% of further analysis.
%
% Author: Roland Goecke
% Date created: 09/03/2021
% Date last changed: 05/03/2023
function [Hue, Saturation, Value] = colourAnalysis(rgbImg)
hsvImg = rgb2hsv(rgbImg);

Hue = hsvImg(:, :, 1);
Saturation = hsvImg(:, :, 2);
Value = hsvImg(:, :, 3);
