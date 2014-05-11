% Run face detector 100 on all images in the test images dir

Cdata = load('StrongClassifier100.mat');
Cparams = Cdata.Cparams;
Cparams.thresh = 26;
Fdata = load('FaceData.mat');
NFdata = load('NonFaceData.mat');
FTdata = load('FeaturesToUse.mat');

addpath('Pics/TestImages');
im_fnames = dir('Pics/TestImages/*.jpg');

for i=1:length(im_fnames)
    f = im_fnames(i);
    im = imread(f.name);
    dets = ScanImageOverScaleOpt(Cparams, im, 0.2, 1.2, 0.1);
    dets = PruneDetections(dets);
    DisplayDetections(im, dets);
end