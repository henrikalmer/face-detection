function dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s)
%SCANIMAGEOVERSCALE Scans an image for faces. Scales the input image to a
% number of different sizes starting from the scale 'min_s' to scale
% 'max_s' with a step size of 'step_s'.

dets = [];
for s=min_s:step_s:max_s
    s_im = imresize(im, s);
    s_dets = ScanImageFixedSize(Cparams, s_im);
    s_dets = s_dets/s;
    dets = [dets; s_dets];
end

end

