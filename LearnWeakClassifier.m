function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)
%LEARNWEAKCLASSIFIER Computes threshold and parity of a weak classifier

% Compute weighted means of the positive and negative examples
mu_p = ((ws.*ys)'*fs) / (ws'*ys);
mu_n = ((ws.*(1-ys))'*fs) / (ws'*(1-ys));

% Set the threshold
theta = (1/2)*(mu_p+mu_n);

% Compute error associated with the two possible values of the parity
h = [(-1*fs) < (-1*theta), fs < theta];
e = [ws'*abs(ys-h(:,1)); ws'*abs(ys-h(:,2))];
[err, i] = min(e);

ps = [-1, 1];
p = ps(i);

end

