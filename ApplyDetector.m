function sc = ApplyDetector(Cparams, ii_im)
%APPLYDETECTOR Applies a strong classifier defined by 'Cparams' to detect
% faces in the 19x19 integral image 'ii_im'

fn = length(Cparams.Thetas);
fmat = zeros(19*19, fn);
theta = Cparams.Thetas(:,2);
p = Cparams.Thetas(:,3);

for i=1:fn
    fi = Cparams.Thetas(i,1);
    fmat(:,i) = VecFeature(Cparams.all_ftypes(fi,:), 19, 19);
end

fs = sum(ii_im(:)'*fmat, 1)';
H = (p.*fs) < (p.*theta);
sc = sum(Cparams.alphas.*H);

end

