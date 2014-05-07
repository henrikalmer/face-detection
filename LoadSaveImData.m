function LoadSaveImData(dirname, ni, im_sfn)
%LOADSAVEIMDATA Loads 'ni' randomly chosen images from 'dirname' and saves
% the data in the file 'im_sfn'.

im_fnames = dir(dirname);
aa = 3:length(im_fnames);
a = randperm(length(aa));
fnums = aa(a(1:ni)); % 'ni' random indexes in face_fnames

ii_ims = [];
for i=1:length(fnums)
    [im, ii_im] = LoadImage(im_fnames(fnums(i)).name);
    ii_ims = [ii_ims; ii_im(:)'];
end

save(im_sfn, 'dirname', 'fnums', 'ii_ims');

end

