function b_vec = VecBoxSum(x, y, w, h, W, H)
%VECBOXSUM Returns a column vector such that ii_im*b_vec equals the result
% of calling 'ComputeBoxSum' with the same arguments

b = zeros(H, W);

b(y+h-1, x+w-1) = 1;
if x>1
    b(y+h-1, x-1) = -1;
end
if y>1
    b(y-1, x+w-1) = -1;
end
if x>1 && y>1
    b(y-1, x-1) = 1;
end

b_vec = b(:);

end

