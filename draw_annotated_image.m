function didDraw=draw_annotated_image(figure_id,figure_title,input_img,x,y)
figure(figure_id)

imshow(input_img)
title(figure_title)

hold on
plot(x,y,'LineWidth',20,'Color','yellow');
hold off
didDraw=1;

end