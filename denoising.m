vol = niftiread('CAHI03M.nii');

[m, n, o] = size(vol);

vol = imgaussfilt3(vol, 1);
  
vol = reshape(vol, m, n, o);

niftiwrite(vol,'DENOISE03.nii');