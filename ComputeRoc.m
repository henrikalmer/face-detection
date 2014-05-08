function ComputeROC(Cparams, Fdata, NFdata)
%COMPUTEROC Computes a ROC (Receiver Operator Charecteristic) curve for a
% strong classifier and training data.

% List all available images
pf_fnames = dir(strcat(Fdata.dirname,'/*.bmp'));
nf_fnames = dir(strcat(NFdata.dirname,'/*.bmp'));
pf_n = min(length(pf_fnames), size(Fdata.ii_ims, 1));
nf_n = min(length(nf_fnames), size(NFdata.ii_ims, 1));

% Choose the ones that were not used for training
test_pf_is = setdiff(1:pf_n, Fdata.fnums);
test_nf_is = setdiff(1:nf_n, NFdata.fnums);
test_pf = Fdata.ii_ims(test_pf_is, :);
test_nf = NFdata.ii_ims(test_nf_is, :);

% Apply the strong classifier to each image
pf_scores = zeros(length(test_pf), 1);
for i=1:length(test_pf)
    pf_scores(i) = ApplyDetector(Cparams, test_pf(i,:));
end
nf_scores = zeros(length(test_nf), 1);
for i=1:length(test_nf)
    nf_scores(i) = ApplyDetector(Cparams, test_nf(i,:));
end

% Compute true and false positive rates by varying threshold
min_t = min([pf_scores; nf_scores]);
max_t = max([pf_scores; nf_scores]);
ts = min_t:0.05:max_t;
tpr = zeros(length(ts), 1);
fpr = zeros(length(ts), 1);
for i=1:length(ts)
    pf_predictions = pf_scores > ts(i);
    nf_predictions = nf_scores < ts(i);
    tpr(i) = sum(pf_predictions) / (sum(pf_predictions) + sum(~pf_predictions));
    fpr(i) = sum(~nf_predictions) / (sum(~nf_predictions) + sum(nf_predictions));
end

% Plot ROC curve
figure(1);
plot(fpr, tpr);
axis equal;

% [ts' tpr fpr] % DEBUG point

end

