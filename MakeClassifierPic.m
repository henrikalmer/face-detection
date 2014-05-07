function cpic = MakeClassifierPic(all_ftypes, chosen_f, alphas, ps, W, H)
%MAKECLASSIFIERPIC Creates an image describing a strong classifier
% consisting of several weighted weak classifiers.

cpic = zeros(H, W);

% Generate feature pics for each feature
fpics = zeros(length(chosen_f), W*H);
for i=1:length(chosen_f)
    fpic = MakeFeaturePic(all_ftypes(chosen_f(i), :), W, H);
    fpics(i,:) = fpic(:)';
end

% Calculate weighted average
ws = alphas.*ps;
ws_mat = repmat(ws', 1, W*H);
average = sum(fpics.*ws_mat);

% Reshape to image
cpic = reshape(average, H, W);

end

