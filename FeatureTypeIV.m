function f = FeatureTypeIV(ii_im, x, y, w, h)
%FEATURETYPEIV Calculates Haar-like features of type IV

f = ComputeBoxSum(ii_im, x+w, y, w, h) ...
    + ComputeBoxSum(ii_im, x, y+h, w, h) ...
    - ComputeBoxSum(ii_im, x, y, w, h) ...
    - ComputeBoxSum(ii_im, x+w, y+h, w, h);

end

