function [img_new,x2,y2] = warp(img,h_unwrap,w_unwarp,trans)
[height,width,~] = size(img);
[x, y] = meshgrid(1:width,1:height);
AA = trans * [y(:)';x(:)';ones(1,width*height)];
new_left = fix(min([1,min(AA(2,:)./AA(3,:))]));
new_right = fix(max([w_unwarp,max(AA(2,:)./AA(3,:))]));
new_top = fix(min([1,min(AA(1,:)./AA(3,:))]));
new_bottom = fix(max([h_unwrap,max(AA(1,:)./AA(3,:))]));

newH = new_bottom - new_top + 1;
newW = new_right - new_left + 1;
x1 = new_left;
y1 = new_top;
x2 = 2 - new_left;
y2 = 2 - new_top;

img_new = zeros(newH,newW,3);
[w_new,h_new] = meshgrid(x1:x1+newW-1,y1:y1+newH-1);

for i = 1:3
    im = double(img(:,:,i));
    h = inv(trans);
    r = (h(1,1)*h_new + h(1,2)*w_new + h(1,3))./(h(3,1)*h_new + h(3,2)*w_new + h(3,3));
    c = (h(2,1)*h_new + h(2,2)*w_new + h(2,3))./(h(3,1)*h_new + h(3,2)*w_new + h(3,3));
    img_new(:,:,i) = interp2(x,y,im,c,r);
end
img_new = uint8(img_new);


