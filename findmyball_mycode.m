clear variables;
close all;
clc;

input_img=imread("robocup_image1.jpeg");

figure(1)
subplot(2,3,1)
imshow(input_img)

temp_img=input_img(403:452,94:141,:);
subplot(2,3,2)
imshow(temp_img)

% Perform normalized cross-correlation between the input image and the template
corr_map = normxcorr2(temp_img(:,:,1), input_img(:,:,1));

% Find the peak correlation coefficient and its location in the correlation map
[~, max_idx] = max(corr_map(:));
[max_y, max_x] = ind2sub(size(corr_map), max_idx);

% Convert the location in the correlation map to the location in the input image
offset_y = size(temp_img,1) - 1;
offset_x = size(temp_img,2) - 1;
ball_y = max_y - offset_y;
ball_x = max_x - offset_x;

% Display the result
subplot(2,3,4)
imshow(input_img)
hold on
rectangle('Position',[ball_x,ball_y,size(temp_img,2),size(temp_img,1)], 'EdgeColor', 'r', 'LineWidth', 2);
hold off
