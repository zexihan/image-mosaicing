function [R, corners] = compute_harris(img, sigma, k, thresh, radius)
[h, w] = size(img);

% Apply Sobel masks
ix = conv2(img, [-1 -2 -1; 0 0 0; 1 2 1], 'same');
iy = conv2(img, [-1 0 1; -2 0 2; -1 0 1], 'same');

% 2D Gaussian averaging
ix2 = imgaussfilt(ix.^2, sigma);
iy2 = imgaussfilt(iy.^2, sigma);
ixy = imgaussfilt(ix.*iy, sigma);

% Compute R
% Below is equivalent to R = (ix2.*iy2-ixy.^2)-k*(ix2+iy2).^2;
R = zeros(h,w);
for i = 1:h
    for j = 1:w
        M = [ix2(i,j) ixy(i,j); ixy(i,j) iy2(i,j)];
        R(i,j) = det(M) - k*(trace(M)^2);
    end
end

% Perform nonmaximal suppression and threshold
sze = 2*radius+1;
mx = ordfilt2(R, sze^2, ones(sze)); 
R = (R == mx) & (R > thresh);

% Get corner indices
[r,c] = find(R);
corners = [r,c];

% Plot
% figure, imagesc(img), axis image, colormap(gray), hold on
% plot(c,r,'ys');

end