function Cparams = BoostingAlgOpt(Fdata, NFdata, FTdata, T)
%BOOSTINGALGOPT Version of BoostingAlg optimized for speed of computation

% Extract training data
pf_ii_ims = Fdata.ii_ims;
nf_ii_ims = NFdata.ii_ims;
fmat = sparse(FTdata.fmat);

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
lys = repmat(ys, 1, 2);
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
        % Inline learning fo weak classifier
        lfs = fs(:,j);
        % Compute weighted means of the positive and negative examples
        mu_p = ((ws.*ys)'*lfs) / (ws'*ys);
        mu_n = ((ws.*(1-ys))'*lfs) / (ws'*(1-ys));
        % Set the threshold
        lt = (1/2)*(mu_p+mu_n);
        % Compute error associated with the two possible values of the parity
        lh = [(-1*lfs) < (-1*lt), lfs < lt];
        le = ws'*abs(lys-lh);
        [err(j), lei] = min(le);
        % Write result
        ps = [-1, 1];
        theta(j) = lt;
        p(j) = ps(lei);
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

