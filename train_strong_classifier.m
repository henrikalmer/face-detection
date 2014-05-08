% Load training data
Fdata = load('FaceData.mat');
NFdata = load('NonFaceData.mat');
FTdata = load('FeaturesToUse.mat');

% Load debug data
dinfo7 = load('DebugInfo/debuginfo7.mat');
T = dinfo7.T;

% Train strong classifier
Cparams = BoostingAlg(Fdata, NFdata, FTdata, T);

% Verify result
eps = 1e-6;
sum(abs(dinfo7.alphas - Cparams.alphas)>eps)
sum(abs(dinfo7.Thetas(:) - Cparams.Thetas(:))>eps)

% Save result
save('StrongClassifier.mat', 'Cparams');
