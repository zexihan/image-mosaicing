function new_img = project(img_1,img_2)
% Project 2 Image Mosaicing
% Quanwei Hao, Zexi Han

% Import images and convert to grayscale
gs_1 = rgb2gray(img_1);
gs_2 = rgb2gray(img_2);

[h1,w1] = size(gs_2);

% Apply Harris Corner Detector
sigma = 1.5;
k = 0.04;
thresh = 1000;
radius = 2;
[~, corners_1] = compute_harris(gs_1, sigma, k, thresh, radius);
[~, corners_2] = compute_harris(gs_2, sigma, k, thresh, radius);

sigma = 1.5;
patch_w = 5;
[patches_1, corners_1] = get_corner_patches(gs_1, corners_1, patch_w, sigma);
[patches_2, corners_2] = get_corner_patches(gs_2, corners_2, patch_w, sigma);

% Compute normalized cross correlation (NCC)
ncc = compute_ncc(patches_1, patches_2);

% Find correspondences
% Set a threshold to keep only matches that have a large NCC score
N = 100;
corres = find_corres(ncc, corners_1, corners_2, N);

% Plot all the the correspondences
% corres_img = cat(2, img_1, img_2);
% figure, imagesc(corres_img), axis image, colormap(gray), hold on
% plot(corres(:,2),corres(:,1),'ys'),
% plot(corres(:,4)+w1,corres(:,3),'ys'),
% for i = 1:size(corres,1)
%     line([corres(i,2) corres(i,4)+w1], [corres(i,1) corres(i,3)]),
% end

% Estimate homography 
thresh = 5;
k = 100; % the number of iteration required
[homography,~,~] = ransac(corres, k, thresh);

% Plot the inliers
% figure, imagesc(corres_img), axis image, colormap(gray), hold on
% plot(inliners(:,2),inliners(:,1),'ys'),
% plot(inliners(:,4)+w1,inliners(:,3),'ys'),
% for i = 1:size(inliners,1)
%     line([inliners(i,2) inliners(i,4)+w1], [inliners(i,1) inliners(i,3)]),
% end

% Warp images
[img1_new,x2,y2] = warp(img_1,h1,w1,homography);
new_img = blend(img1_new,img_2,x2,y2);
figure, imshow(uint8(new_img));






