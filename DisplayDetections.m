function DisplayDetections(im, dets)
%DISPLAYDETECTIONS Display a set of rectangles on an image

figure();
imshow(im);
for i=1:size(dets,1)
    rectangle('Position', dets(i,1:4), 'EdgeColor', 'r');
end

end

