function all_ftypes = EnumAllFeatures(W, H)
%ENUMALLFEATURES Enumerates all possible features that can be extracted
%from an image of width 'W' and height 'H'.

nf = 1;
all_ftypes = zeros([W*W*H*H*4, 5]);

% Type I
for w = 1:W-2
    for h = 1:floor(H/2)-2
        for x = 2:W-w
            for y = 2:H-2*h
                all_ftypes(nf, :) = [1, x, y, w, h];
                nf = nf + 1;
            end
        end
    end
end

% Type II
for w = 1:floor(W/2)-2
    for h = 1:H-2
        for x = 2:W-2*w
            for y = 2:H-h
                all_ftypes(nf, :) = [2, x, y, w, h];
                nf = nf + 1;
            end
        end
    end
end

% Type III
for w = 1:floor(W/3)-2
    for h = 1:H-2
        for x = 2:W-3*w
            for y = 2:H-h
                all_ftypes(nf, :) = [3, x, y, w, h];
                nf = nf + 1;
            end
        end
    end
end

% Type IV
for w = 1:floor(W/2)-2
    for h = 1:floor(H/2)-2
        for x = 2:W-2*w
            for y = 2:H-2*h
                all_ftypes(nf, :) = [4, x, y, w, h];
                nf = nf + 1;
            end
        end
    end
end

all_ftypes=all_ftypes(1:nf-1, :);

end

