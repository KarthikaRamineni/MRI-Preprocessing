clc;
clear all;

im = niftiread('CAHI01M.nii');
A = imrotate(squeeze(uint8(im(100,:,:))), 90);
imshow(A);
[m, n] = size(A);

maxi = max(max(A));
maxi = maxi - 1;
max_arr(1:m, 1:n) = maxi;
A_comp = max_arr - A;

se = strel('disk', 5);
A_closure = imclose(A_comp, se);

maxi = max(max(A_closure));
maxi = maxi - 1;
max_arr(1:m, 1:n) = maxi;
A_closure_comp = max_arr - A_closure;

A_diff = A - A_closure_comp;
A_enhanced = A + A_diff;

level = graythresh(A_enhanced);
A_bin = imbinarize(A, level);
A_connected = bwareafilt(A_bin, 1);

se2 = strel('square', 3);
A_new = imdilate(A_connected, se2);
A_old = A_connected;
A_enhanced_comp = imcomplement(A_bin);

while(~isequal(A_old, A_new))
    A_old = A_new;
    A_new = bitand(imdilate(A_connected, se2), A_bin);
end

se = strel('disk', 5);
A_new = imdilate(A_new, se);
A_res = uint8(zeros(m, n));
%figure;imshow(A_new);

for i = 1:m
    for j = 1:n
        if(A_new(i, j) == 1)
            A_res(i, j) = A(i, j);
        end
    end
end
figure;imshow(A_res);