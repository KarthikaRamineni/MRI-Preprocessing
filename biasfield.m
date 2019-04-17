clc;
clear all;

im = niftiread('../CONT01M.nii');
in = imrotate(squeeze(uint8(im(100,:,:))), 90);
figure;imshow(in);
[m, n] = size(in);
mi = round(m/3);
ni = round(n/3);
datapoints = 100;

sigma_x = 2 * mi;
sigma_y = 2 * ni;
G = fspecial('gaussian', [sigma_x sigma_y], 1);
out = imfilter(in, G, 'same');

count = 0;
fid = fopen('points.txt','wt');
while(count < datapoints)
    x = randi([1 m]);
    y = randi([1 n]);
    if(in(x, y) > 10)
        fprintf(fid,'%g  %g  %g\n', x, y, out(x,y));
        count = count + 1;
    end
end
fclose(fid);

command = 'python3 ./estimate.py';
system(command);

fID = fopen('temp.txt');
temp = textscan(fID,'%f %f %f %f %f %f %f');
fclose(fID);
temp = cell2mat(temp);
a = temp(1);
b = temp(2);
c = temp(3);
d = temp(4);
e = temp(5);
f = temp(6);
g = temp(7);

for i = 1:m
    for j = 1:n
        out(i, j) = a + b * (i^3) + c * (j^3) + d * (i^2) + e * (j^2) + f * i + g * j;
    end
end
figure();imshow(out);

output = log(double(in)) - log(double(out)); % 1+a, a -> parameters
output = exp(output);
output =  output;% ./ 4;
%output = in + out;
figure();imshow(output);
