% Load data
Fdata = load('FaceData.mat');
NFdata = load('NonFaceData.mat');
FTdata = load('FeaturesToUse.mat');

% Read data
pf_ii_ims = Fdata.ii_ims;
nf_ii_ims = NFdata.ii_ims;
fmat = FTdata.fmat;
ftype_vec = fmat(:, col);
pfs = pf_ii_ims*ftype_vec;
nfs = nf_ii_ims*ftype_vec;
n = length(pfs);
m = length(nfs);

% Initialize weights
pws = repmat(1/(2*(n-m)), m, 1);
nws = repmat(1/(2*m), n, 1);

% Put together input data
fs = [pfs; nfs];                    % All feature responses
ys = [ones(n, 1); zeros(m, 1)];     % Image classifications
ws = [pws; nws] / sum([pws; nws]);  % Normalized weights

% Call function
[a_theta, a_p, ~] = LearnWeakClassifier(ws, fs, ys);

% Calculate histograms
[np, outp] = hist(pfs);
[nn, outn] = hist(nfs);

% Plot
figure(1)
hold on
plot(outp, np, 'r')
plot(outn, nn, 'b')
x=[a_theta,a_theta];
y = [0,1600];
plot(x,y,'k')
