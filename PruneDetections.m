function fdets = PruneDetections(dets)
%PRUNEDETECTIONS Reduce overlapping detections into one detection

nd = length(dets);

% Determine if intersection divided by union exceeds 0.8.
intersection = rectint(dets(:,1:4), dets(:,1:4));
union = repmat(intersection(1,1)*2, nd) - intersection;
D = (intersection./union) > 0.8;

% Reduce dets using graphconncomp
[S, C] = graphconncomp(sparse(D));

% Calculate average rectangle for overlaps
fdets = zeros(S, 4);
sum = zeros(S);
for i=1:length(C)
    fdets(C(i),:) = fdets(C(i),:) + dets(i,1:4);
    sum(C(i)) = sum(C(i)) + 1;
end
for i=1:S
    fdets(i,:) = floor(fdets(i,:) / sum(i));
end

end

