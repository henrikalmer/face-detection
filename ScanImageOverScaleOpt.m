function dets = ScanImageOverScaleOpt(Cparams, im, min_s, max_s, step_s)
%SCANIMAGEOVERSCALE Scans an image for faces. Scales the input image to a
% number of different sizes starting from the scale 'min_s' to scale
% 'max_s' with a step size of 'step_s'.

% Convert image to grayscale if necessary
if size(im,3) > 1
    im = rgb2gray(im);
end
im = double(im);

% Compute fmat.
fn = length(Cparams.Thetas);
fmat = zeros(19*19, fn);
for i=1:fn
    fi = Cparams.Thetas(i,1);
    fmat(:,i) = VecFeature(Cparams.all_ftypes(fi,:), 19, 19);
end
fmat = sparse(fmat);

% Extract theta and p from classifier.
theta = Cparams.Thetas(:,2);
p = Cparams.Thetas(:,3);

% Allocate return matrix
dets = zeros(100000, 5);
faces = 1;

% Iterate scales and do detection
for s=min_s:step_s:max_s
    s_im = imresize(im, s);
    
    % Inline scan of image
    % Compute the integral image and squared integral image
    ii_im = cumsum(cumsum(s_im, 1), 2);
    ii_im_sq = cumsum(cumsum(s_im.*s_im, 1), 2);
    % Zero pad to avoid index errors
    ii_im_pad = padarray(ii_im, [1 1]);
    ii_im_sq_pad = padarray(ii_im_sq, [1 1]);
    
    % Iterate all possible 19x19 rectangles and see if it contains a face
    L = 19;
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
            
            % Inline apply detector
            k = Cparams.Thetas(:,1);
            is_III = Cparams.all_ftypes(k, 1) == 3;
            w = Cparams.all_ftypes(k, 4);
            h = Cparams.all_ftypes(k, 5);

            fs = rect(:)'*fmat;
            fs = (fs' + is_III.*w.*h.*mean)/std;

            H = (p.*fs) < (p.*theta);
            score = sum(Cparams.alphas.*H);
            
            if score > Cparams.thresh
                dets(faces,:) = [(x-1)/s, (y-1)/s, L/s, L/s, score];
                faces = faces+1;
            end
        end
    end
end

dets = dets(1:faces-1,:);

end

