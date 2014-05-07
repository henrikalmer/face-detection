function [im, ii_im] = LoadImage(im_fname)
%LOADIMAGES Takes a filename of an image as input and returns two arrays.
%   The first array corresponds to a normalized version of the pixel data
%   of the image and the second to its integral image.

im = double(imread(im_fname));

% Normalize pixel data to introduce invariance in illumination effects
mu = mean(im(:));
sigma = std(im(:)) + 1e-10; % Add small value to avoid zero division
im = (im(:) - mu) / sigma;

% Compute the integral image
ii_im = cumsum(im);

end

