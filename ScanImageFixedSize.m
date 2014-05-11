function dets = ScanImageFixedSize(Cparams, im)
%SCANIMAGEFIXEDSIZE Scans an image for faces

% Convert to grayscale if necessary
if size(im,3) > 1
    im = rgb2gray(im);
end
im = double(im);

% Allocate return matrix
dets = zeros(100000, 5);

% Compute the integral image and squared integral image
ii_im = cumsum(cumsum(im, 1), 2);
ii_im_sq = cumsum(cumsum(im.*im, 1), 2);
% Zero padded versions that avoid index errors
ii_im_pad = padarray(ii_im, [1 1]);
ii_im_sq_pad = padarray(ii_im_sq, [1 1]);


% Iterate all possible 19x19 rectangles and see if it contains a face
L = 19;
faces = 1;
for i=1:(size(ii_im, 2) - L + 1)
    for j=1:(size(ii_im, 1) - L + 1)
        x = i+1; y = j+1;
        % Computations of mean and standard deviation
        mean = ii_im_pad(y+L-1, x+L-1) ...
                - ii_im_pad(y+L-1, x-1) ...
                - ii_im_pad(y-1, x+L-1) ...
                + ii_im_pad(y-1, x-1);
        mean = mean/L^2;
        std = ii_im_sq_pad(y+L-1, x+L-1) ...
                - ii_im_sq_pad(y+L-1, x-1) ...
                - ii_im_sq_pad(y-1, x+L-1) ...
                + ii_im_sq_pad(y-1, x-1);
        std = sqrt((std-L^2 * mean^2) / (L^2 - 1));
        % Extract rectangle and do detection
        rect = ii_im_pad(y:y+L-1, x:x+L-1);
        score = ApplyDetector(Cparams, rect, mean, std);
        if score > Cparams.thresh
            dets(faces,:) = [x-1, y-1, L, L, score];
            faces = faces+1;
        end
    end
end

dets = dets(1:faces-1,:);

end

