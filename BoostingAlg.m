function Cparams = BoostingAlg(Fdata, NFdata, FTdata, T)
%BOOSTINGALG Computes a strong classifier using 'T' weak classifiers

% Extract training data
pf_ii_ims = Fdata.ii_ims;
nf_ii_ims = NFdata.ii_ims;
fmat = FTdata.fmat;

% Compute features
pfs = pf_ii_ims*fmat;
nfs = nf_ii_ims*fmat;
n = length(pf_ii_ims);
m = length(nf_ii_ims);

% Initialize weights
pws = repmat(1/(2*n), n, 1);    % Init with 2*n and not 2*(n-m) (important)
nws = repmat(1/(2*m), m, 1);

% Put together input data
fs = [pfs; nfs];                    % Feature responses
ys = [ones(n, 1); zeros(m, 1)];     % Image classifications
ws = [pws; nws];                    % Weights

% Choose 'T' weak classifiers to use in the final strong classifier
Thetas = zeros(T,3);
alphas = zeros(T,1);
for i=1:T
    % Normalize weights
    ws = ws/sum(ws);
    
    % Train a weak classifier for each feature
    fn = length(fmat);
    theta = zeros(fn,1); p = zeros(fn,1); err = zeros(fn,1);
    for j=1:fn
        [theta(j), p(j), err(j)] = LearnWeakClassifier(ws, fs(:,j), ys);
    end
    
    % Choose weak classifier with minimum error
    [e, ei] = min(err);
    
    % Set i:th theta, p and feature type
    Thetas(i,:) = [ei, theta(ei), p(ei)];
    
    % Update weights
    beta = e/(1-e);
    h = p(ei)*fs(:,ei) < p(ei)*theta(ei);
    ws = ws.*(beta.^(1-abs(h-ys)));
    
    % Set i:th alpha
    alphas(i) = log(1/beta);
end

% Construct output
Cparams.all_ftypes = FTdata.all_ftypes;
Cparams.Thetas = Thetas;
Cparams.alphas = alphas;

end

