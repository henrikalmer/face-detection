function f = FeatureTypeI(ii_im, x, y, w, h)
%FEATURETYPEI Calculates Haar-like features of type I

f = ComputeBoxSum(ii_im, x, y, w, h) ...
    - ComputeBoxSum(ii_im, x, y+h, w, h);

end

