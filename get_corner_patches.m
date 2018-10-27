function [patches, corners] = get_corner_patches(gs, corners, patch_w, sigma)
gs = imgaussfilt(gs, sigma);
[h, w] = size(gs);
num = size(corners, 1);
patches = zeros(num, patch_w^2);

for i = 1:num
    if corners(i,1) > (patch_w-1)/2 && corners(i,1) < h-(patch_w-1)/2-1 && corners(i,2) > (patch_w-1)/2 && corners(i,2) < w-(patch_w-1)/2-1
        
        xmin = corners(i,2) - (patch_w-1)/2;
        ymin = corners(i,1) - (patch_w-1)/2;
        % Crop 5x5 image patch
        patch = imcrop(gs, [xmin ymin patch_w-1 patch_w-1]);
        patches(i,:) = patch(:);
        % Normalize
        patches(i,:) = patches(i,:) / sqrt(sum(patches(i,:).^2));
        % Take away the mean and scale with the std. dev
        patches(i,:) = (patches(i,:) - mean2(patches(i,:))) ./ std2(patches(i,:));
    else
        corners(i,:) = 0;
    end
end

patches = patches(any(patches,2),:);
corners = corners(any(corners,2),:);

end