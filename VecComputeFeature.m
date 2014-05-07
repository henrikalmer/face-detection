function fs = VecComputeFeature(ii_ims, ftype_vec)
%VECCOMPUTEFEATURE Computes a feature described by 'ftype_vec' for all
% images in 'ii_ims'. In this function 'ii_ims' is a matrix with one
% integral image per row.

fs = ii_ims*ftype_vec;

end

