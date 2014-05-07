function f = FeatureTypeIII(ii_im, x, y, w, h)
%FEATURETYPEIII Calculates Haar-like features of type III

f = ComputeBoxSum(ii_im, x+w, y, w, h) ...
    - ComputeBoxSum(ii_im, x, y, w, h) ...
    - ComputeBoxSum(ii_im, x+2*w, y, w, h);

end

