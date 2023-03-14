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


[height,width,channels]=size(input_img);

N = 1000; % Update the display every N iterations
for y_i=1:1:height
    for x_i=1:1:width
        %new_img = input_img;
        %new_img(y_i:y_i+size(temp_img,1)-1, x_i:x_i+size(temp_img,2)-1, :) = temp_img;
        %if mod(y_i*width+x_i, N) == 0 % Update the display every N iterations
            %subplot(2,3,3)
            %imshow(new_img)
            %drawnow
        temp_img=input_img(y_i:y_i+temp_he:452,94:141,:);
        
        end
    end
end