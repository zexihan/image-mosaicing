function [h, p, inliners] = ransac(corres, k, thresh)
N = size(corres, 1);
n = 4; % the smallest number of points required
all_h = zeros(3,3,k);
error_rate = zeros(1,k);
all_points = zeros(4,4,k);
all_inliners = zeros(4,4,k);

for i = 1:k
    error = 0;
    rand_p = randi(N,1,n);
    points = corres(rand_p,1:4);
    all_points(:,:,i) = points;
    A = [points(1,1:2) 1 0 0 0 -points(1,1:2)*points(1,3) -points(1,3);
        0 0 0  points(1,1:2) 1 -points(1,1:2)*points(1,4) -points(1,4);
        points(2,1:2) 1 0 0 0 -points(2,1:2)*points(2,3) -points(2,3);
        0 0 0  points(2,1:2) 1 -points(2,1:2)*points(2,4) -points(2,4);
        points(3,1:2) 1 0 0 0 -points(3,1:2)*points(3,3) -points(3,3);
        0 0 0  points(3,1:2) 1 -points(3,1:2)*points(3,4) -points(3,4);
        points(4,1:2) 1 0 0 0 -points(4,1:2)*points(4,3) -points(4,3);
        0 0 0  points(4,1:2) 1 -points(4,1:2)*points(4,4) -points(4,4)];
    [V,D] = eig(A'*A);
    [~,ind] = sort(diag(D));
    temp_h = V(:,ind(1));
    
    % b = [points(1,3:4)';points(2,3:4)';points(3,3:4)';points(4,3:4)'];
    % temp_h = [A\b;1];
    
    all_h(:,:,i) = [temp_h(1) temp_h(2) temp_h(3);
        temp_h(4) temp_h(5) temp_h(6);
        temp_h(7) temp_h(8) temp_h(9)];
    
    for k = 1:N
        cand_corres = all_h(:,:,i) * [corres(k,1:2)';1];
        cand_corres = cand_corres./cand_corres(3,:);
        if dist(cand_corres', [corres(k,3:4)';1]) > thresh
            error = error + 1;
        else
            all_inliners(k,:,i) = corres(k,1:4);
        end
    end
    error_rate(i) = error/N;
end

[~,I] = min(error_rate);
h = all_h(:,:,I);
p = all_points(:,:,I);
inliners = all_inliners(:,:,I);

end
    
