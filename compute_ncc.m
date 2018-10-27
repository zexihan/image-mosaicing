function ncc = compute_ncc(patches_1, patches_2)
m = size(patches_1, 1);
n = size(patches_2, 1);
ncc = zeros(m, n);

for i = 1:m
    for j = 1:n
        ncc(i, j) = sum(patches_1(i,:).*patches_2(j,:));
    end
end

end