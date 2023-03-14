
input_img=imread("robocup_image1.jpeg");
x=[200,100];
y=[500,200];

%draw_boool=draw_annotated_image(1,'ROBO  SPORT',input_img,x,y);


%clear all
%close all
clc

input_img=imread("barcode.jpg");
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