function f = FeatureTypeII(ii_im, x, y, w, h)
%FEATURETYPEII Calculates Haar-like features of type II

f = ComputeBoxSum(ii_im, x+w, y, w, h) ...
    - ComputeBoxSum(ii_im, x, y, w, h);

end

