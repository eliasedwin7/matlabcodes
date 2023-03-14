input_img=imread("robocup_image1.jpeg");
figure(1)
subplot(2,3,1)
imshow(input_img)


myImg_grey=rgb2gray(input_img);
input_img_edge=edge(myImg_grey,'Canny');
subplot(2,3,2)
imshow(input_img_edge)

[H, T, R] = hough(input_img_edge,'RhoResolution', 0.5, 'Theta', -90:0.5:89);

% Display the Hough matrix (rho and theta value pairs)
subplot(2,3,3);
imshow(imadjust(mat2gray(H)), ...
'XData',T,'YData',R,'InitialMagnification','fit');
title('Hough Transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);



P = houghpeaks(H, 10);
plot(T(P(:,2)), R(P(:,1)), 's', 'color', 'green');



lines = houghlines(input_img_edge, T, R, P,'FillGap', 5, 'MinLength',7);
subplot(2, 3, 4);
imshow(input_img), hold on;
max_len = 0;
for k = 1:length(lines)
xy = [lines(k).point1; lines(k).point2];
plot(xy(:,1),xy(:,2), 'LineWidth', 2, 'Color', 'green');
% Plot beginnings and ends of lines
plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, ...
'Color', 'yellow');
plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, ...
'Color', 'red');
% Determine the endpoints of the longest line segment
len = norm(lines(k).point1 - lines(k).point2);if ( len > max_len)
max_len = len;
xy_long = xy;
end
end
hold off;
title('Visualisation of Line Segments');

[centers, radii] = imfindcircles(myImg_grey, [10 50], 'ObjectPolarity','dark');
subplot(2,3,5)
imshow(input_img),hold on;
viscircles(centers, radii) , title('CIrcles'),hold off;

[centre, radius] = findBall(centers, radii);
subplot(2,3,6)
imshow(input_img),hold on;
viscircles(centre, radius) , title('CIrcles'),hold off;

function [centre, radius] = findBall(hue, centres, radii)
% Get the number of candidate circles to check
numCandidates = length(centres);

% Loop over all candidates, check the hue value - from checking the hue
% values beforehand, we have determined that a hue value < 0.095 is
% consistent with the 'redish' colour of the ball
for iI = 1:numCandidates(1)
    currentHue = hue(uint16(centres(iI,2)), uint16(centres(iI,1)));
    if (currentHue < 0.095)     % Found one!
        centre = uint16(centres(iI, :) + 0.5); % Return as nearest integer
        radius = uint16(radii(iI)); % Return as nearest integer
        return              % This simple code assumes the first one
    end                     % found is correct, so stops the for-loop
end

% If we didn't find one, let's return 0 values
centre = 0;
radius = 0;
end







