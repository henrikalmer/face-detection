function fpic = MakeFeaturePic(ftype, W, H)
%MAKEFEATUREPIC Generates an image describing a feature

fpic = zeros(H, W);

type = ftype(1);
x = ftype(2);
y = ftype(3);
w = ftype(4);
h = ftype(5);

switch type
    case 1
        fpic(y:y+h-1, x:x+w-1) = -1;        % top black
        fpic(y+h:y+2*h-1, x:x+w-1) = 1;     % bottom white
    case 2
        fpic(y:y+h-1, x:x+w-1) = 1;         % top white
        fpic(y:y+h-1, x+w:x+2*w-1) = -1;    % bottom black
    case 3
        fpic(y:y+h-1, x:x+w-1) = 1;         % left white
        fpic(y:y+h-1, x+w:x+2*w-1) = -1;	% middle black
        fpic(y:y+h-1, x+2*w:x+3*w-1) = 1;	% right white
    case 4
        fpic(y:y+h-1, x:x+w-1) = 1;         % top left white
        fpic(y:y+h-1, x+w:x+2*w-1) = -1;    % top right black
        fpic(y+h:y+2*h-1, x:x+w-1) = -1;    % bottom left black
        fpic(y+h:y+2*h-1, x+w:x+2*w-1) = 1; % bottom left white
end

end

