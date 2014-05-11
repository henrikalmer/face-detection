function sc = ApplyDetector(Cparams, ii_im, mean, std)
%APPLYDETECTOR Applies a strong classifier defined by 'Cparams' to detect
% faces in the 19x19 integral image 'ii_im'

if nargin < 4
    mean = 0;
    std = 1;
end

fn = length(Cparams.Thetas);
fmat = zeros(19*19, fn);
theta = Cparams.Thetas(:,2);
p = Cparams.Thetas(:,3);

for i=1:fn
    fi = Cparams.Thetas(i,1);
    fmat(:,i) = VecFeature(Cparams.all_ftypes(fi,:), 19, 19);
end
fmat = sparse(fmat);

j = Cparams.Thetas(:,1);
is_III = Cparams.all_ftypes(j, 1) == 3;
w = Cparams.all_ftypes(j, 4);
h = Cparams.all_ftypes(j, 5);

fs = ii_im(:)'*fmat;
fs = (fs' + is_III.*w.*h.*mean)/std;

H = (p.*fs) < (p.*theta);
sc = sum(Cparams.alphas.*H);

end

