% A Matlab script to explore edge detection and the Hough transform
% Author: Roland Goecke
% Date created: 2 Mar 2021
% Date last changed: 24/02/2023

clear variables;
close all;
clc;

% Load image *** Change file path to your current settings! ***
myImgBarcode = imread('barcode.jpg');
figure(1);
subplot(2, 3, 1);
imshow(myImgBarcode);
title('Original Image');

% Convert images to grayscale
myImgBarcodeGray = rgb2gray(myImgBarcode);
subplot(2, 3, 2);
imshow(myImgBarcodeGray);
title('Grayscale Image');

% Canny Edge Detection
myImgBarcodeEdgesCanny = edge(myImgBarcodeGray, 'Canny');
subplot(2, 3, 3);
imshow(myImgBarcodeEdgesCanny);
title('Canny Edge Detector');

% Hough transform - find occurences of straight line segments in the image
[H, T, R] = hough(myImgBarcodeEdgesCanny, 'RhoResolution', 0.5, ...
    'Theta', -90:0.5:89);
subplot(2, 3, 4);
imshow(imadjust(rescale(H)), 'XData', T, 'YData', R, ...
      'InitialMagnification', 'fit');
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

% Now find the top 10 'peaks', i.e. the pairs of rho and theta with the
% highest number of votes
P  = houghpeaks(H, 10);
plot(T(P(:,2)), R(P(:,1)), 's', 'color', 'green');

% Let's visualise the line segments corresponding to these top 10 peaks on 
% the original image
lines = houghlines(myImgBarcodeEdgesCanny, T, R, P, 'FillGap', 35, ...
    'MinLength',20);
subplot(2, 3, 5);
imshow(myImgBarcode), hold on;
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');

   % Plot beginnings and ends of lines
   plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
   plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
hold off;
title('Visualisation of Line Segments');
