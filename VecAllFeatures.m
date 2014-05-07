function fmat = VecAllFeatures(all_ftypes, W, H)
%VECALLFEATURES Generates column vectors for each feature in 'all_ftypes'

fmat = zeros(W*H, size(all_ftypes, 1));

for i=1:size(all_ftypes, 1)
    fmat(:,i) = VecFeature(all_ftypes(i,:), W, H);
end

end

