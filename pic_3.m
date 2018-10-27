img_1 = imread('img/DanaHallWay/o/1.JPG');
img_2 = imread('img/DanaHallWay/o/2.JPG');
img_3 = imread('img/DanaHallWay/o/3.JPG');

new_img_1 = project(img_1,img_2);
new_img_2 = project(img_3,img_2);

new_img = project(uint8(new_img_1),uint8(new_img_2));