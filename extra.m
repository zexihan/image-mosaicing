img_1 = imread('1.png');
img_2 = imread('DanaHallWay2/DSC_0286.JPG');
figure, imshow(img_2);
[x,y] = ginput(4);
[h1,w1,~] = size(img_1);
[h2,w2,~] = size(img_2);

% Calculate the homography
A = [1 1 1 0 0 0 -x(3) -x(3) -x(3);
    0 0 0 1 1 1 -y(3) -y(3) -y(3);
    w1 1 1 0 0 0 -w1*x(1) -x(1) -x(1);
    0 0 0 w1 1 1 -w1*y(1) -x(1) -y(1);
    w1 h1 1 0 0 0 -w1*x(2) -h1*x(2) -x(2);
    0 0 0 w1 h1 1 -w1*y(2) -h1*y(2) -y(2);
    1 h1 1 0 0 0 -x(4) -h1*x(4) -x(4);
    0 0 0 1 h1 1 -y(4) -h1*y(4) -y(4)];
[V,D] = eig(A'* A);
[~,ind] = sort(diag(D));
h = V(:,ind(1));
h = [h(1) h(2) h(3);
    h(4) h(5) h(6);
    h(7) h(8) h(9)];

% Warp
img_new = zeros(h2,w2,3);
[x_new, y_new] = meshgrid(1:w2,1:h2);
h_inv = inv(h);
for i = 1:3
    im = double(img_1(:,:,i));
    xx = (h_inv(1,1)*x_new + h_inv(1,2)*y_new + h_inv(1,3))./(h_inv(3,1)*x_new + h_inv(3,2)*y_new + h_inv(3,3));
    yy = (h_inv(2,1)*x_new + h_inv(2,2)*y_new + h_inv(2,3))./(h_inv(3,1)*x_new + h_inv(3,2)*y_new + h_inv(3,3));
    img_new(:,:,i) = interp2(im,xx,yy);
end

% Blend
im_2 = double(img_2);
img_new(isnan(img_new))=0;
maskA = (img_new(:,:,1)>0 | img_new(:,:,2)>0 | img_new(:,:,3)>0);
mask = ones(h2,w2);
mask = mask - maskA;
img_new(:,:,1) = im_2(:,:,1) .* mask + img_new(:,:,1)*0.8;
img_new(:,:,2) = im_2(:,:,2) .* mask + img_new(:,:,2)*0.8;
img_new(:,:,3) = im_2(:,:,3) .* mask + img_new(:,:,3)*0.8;
figure,
imshow(uint8(img_new));


