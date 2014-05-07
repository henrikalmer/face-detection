function A = ComputeBoxSum(ii_im, x, y, w, h)
%COMPUTEBOXSUM Computes the sum of pixel values in a rectangular area
%   Uses the integral image 'ii_im' to compute the sum of pixel values in
%   the original image 'im' in the rectangular area given by c, y, w and h.

% Pad with zeros to avoid index errors when x or y is 1
ii_im = padarray(ii_im, [1 1]);
x = x+1;
y = y+1;

% Calculate sum
a1 = ii_im(y+h-1, x+w-1);
a2 = ii_im(y+h-1, x-1);
a3 = ii_im(y-1, x+w-1);
a4 = ii_im(y-1, x-1);

A = a1 - a2 - a3 + a4;

end

