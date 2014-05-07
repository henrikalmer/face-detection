function fs = ComputeFeature(ii_ims, ftype)
%COMPUTEFEATURE Extracts the feature defined by 'ftype' from each integral
% image defined in 'ii_ims'.

fs = zeros(1, size(ii_ims, 1));

type = ftype(1);
x = ftype(2);
y = ftype(3);
w = ftype(4);
h = ftype(5);

for i=1:size(ii_ims, 1)
    if type==1
        f = FeatureTypeI(ii_ims{i}, x, y, w, h);
    elseif type==2
        f = FeatureTypeII(ii_ims{i}, x, y, w, h);
    elseif type==3
        f = FeatureTypeIII(ii_ims{i}, x, y, w, h);
    elseif type==4
        f = FeatureTypeIV(ii_ims{i}, x, y, w, h);
    end
    
    fs(i) = f;
end

end

