% Matlab script for analysing Robocup Soccer images. This is the main
% script file, from which several functions are called.
% TODO: This is not the most efficient code as there is code duplication.
%
% Author: Roland Goecke
% Date created: 08/03/2022
% Date last changed: 05/03/2023

% Clear workspace, close all figure windows, clear command window
clear variables;
close all;
clc;

% Load images *** Change file path to your current settings! ***
imgRobocup1 = imread('robocup_image1.jpeg');
figure(1);  % Best viewed in full-screen mode
subplot(2, 6, 1);
imshow(imgRobocup1);
title('Original Image #1');

imgRobocup2 = imread('robocup_image2.jpg');
subplot(2, 6, 7);
imshow(imgRobocup2);
title('Original Image #2');

% Convert images to grayscale
imgRobocup1Gray = rgb2gray(imgRobocup1);
subplot(2, 6, 2);
imshow(imgRobocup1Gray);
title('Grayscale Image #1');

imgRobocup2Gray = rgb2gray(imgRobocup2);
subplot(2, 6, 8);
imshow(imgRobocup2Gray);
title('Grayscale Image #2');

% Canny Edge Detection
imgRobocup1EdgesCanny = edge(imgRobocup1Gray, 'Canny');
subplot(2, 6, 3);
imshow(imgRobocup1EdgesCanny);
title('Canny Edge Detector Image #1');

imgRobocup2EdgesCanny = edge(imgRobocup2Gray, 'Canny');
subplot(2, 6, 9);
imshow(imgRobocup2EdgesCanny);
title('Canny Edge Detector Image #2');

% Hough transform - find occurences of straight line segments (image #1)
[H1, T1, R1] = hough(imgRobocup1EdgesCanny, 'RhoResolution', 0.5, ...
    'Theta', -90:0.5:89);
subplot(2, 6, 4);
imshow(imadjust(rescale(H1)), 'XData', T1, 'YData', R1, ...
      'InitialMagnification', 'fit');   % Display Hough matrix
title('Hough transform Image #1');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca, hot);     % Use a false temperature map to show which 
                        % (theta, rho) pairs received the most votes

% Now find the top 5 'peaks', i.e. the pairs of rho and theta with the
% highest number of votes (image #1)
P1  = houghpeaks(H1, 5);
plot(T1(P1(:,2)), R1(P1(:,1)), 's', 'color', 'green');

% Let's visualise these lines on the original image #1
lines1 = houghlines(imgRobocup1EdgesCanny, T1, R1, P1, 'FillGap', 20, ...
    'MinLength',7);
subplot(2, 6, 5);
imshow(imgRobocup1), hold on;
title('Line Overlay Image #1')
max_len = 0;
for k = 1:length(lines1)
   xy = [lines1(k).point1; lines1(k).point2];
   plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');

   % Plot beginnings and ends of lines
   plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
   plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');

   % Determine the endpoints of the longest line segment
   len = norm(lines1(k).point1 - lines1(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
hold off;

% Hough transform - find occurences of straight line segments (image #1)
[H2, T2, R2] = hough(imgRobocup2EdgesCanny, 'RhoResolution', 0.5, ...
    'Theta', -90:0.5:89);
subplot(2, 6, 10);
imshow(imadjust(rescale(H2)), 'XData', T2, 'YData', R2, ...
      'InitialMagnification', 'fit');   % Display Hough matrix
title('Hough transform Image #2');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca, hot);     % Use a false temperature map to show which 
                        % (theta, rho) pairs received the most votes

% Now find the top 5 'peaks', i.e. the pairs of rho and theta with the
% highest number of votes (image #2)
P2  = houghpeaks(H2, 6);
plot(T2(P2(:,2)), R2(P2(:,1)), 's', 'color', 'green');

% Let's visualise these lines on the original image #2
lines2 = houghlines(imgRobocup2EdgesCanny, T2, R2, P2, 'FillGap', 20, ...
    'MinLength',7);
subplot(2, 6, 11);
imshow(imgRobocup2), hold on;
title('Line Overlay Image #2')
max_len = 0;
for k = 1:length(lines2)
   xy = [lines2(k).point1; lines2(k).point2];
   plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');

   % Plot beginnings and ends of lines
   plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
   plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');

   % Determine the endpoints of the longest line segment
   len = norm(lines2(k).point1 - lines2(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
hold off;

% The Hough Transform can be applied to any shape as long as there is a
% parametric function describing it. Let us now look at the circular Hough
% Transform to find circles (specifically, we want to find the ball).
% Note: The following code may find more than one circle, so we will need
% something else to decide which candidate circle is most likely the ball, 
% but for now this is good enough.
% We can control what size of circles are searched for by two parameters:
% Rmin and Rmax
Rmin = 10;  % Minimum permissible radius in pixels
Rmax = 40;  % Maximum permissible radius in pixels

% Find circle candidate locations in image #1
[centres1, radii1] = imfindcircles(imgRobocup1EdgesCanny, [Rmin Rmax], ...
    'ObjectPolarity','bright');

% Display found candidate circle(s) for image #1
subplot(2, 6, 6);
imshow(imgRobocup1); hold on;
viscircles(centres1, radii1, 'Color', 'b');
title('Ball Candidate Locations Image #1');

% Call the colourAnalysis function to get hue, saturation, value 'images'
[hue1, sat1, val1] = colourAnalysis(imgRobocup1);

% Let focus on the hue colour channel for finding the ball in image #1
[centre1, radius1] = findBall(hue1, centres1, radii1);
if (centre1 > 0)    % Have we found one? If yes, display in green
    viscircles(centre1, radius1, 'Color', 'g');
end
hold off;

% Find circle candidate locations in image #2
[centres2, radii2] = imfindcircles(imgRobocup2EdgesCanny, [Rmin Rmax], ...
    'ObjectPolarity','bright');

% Display found circle(s) for image #2
subplot(2, 6, 12);
imshow(imgRobocup2); hold on;
viscircles(centres2, radii2, 'Color', 'b');
title('Ball Candidate Locations Image #2');

% Call the colourAnalysis function to get hue, saturation, value 'images'
[hue2, sat2, val2] = colourAnalysis(imgRobocup2);

% Let focus on the hue colour channel for finding the ball in image #2
[centre2, radius2] = findBall(hue2, centres2, radii2);
if (centre2 > 0)    % Have we found one? If yes, display in green
    viscircles(centre2, radius2, 'Color', 'g');
end
hold off;
