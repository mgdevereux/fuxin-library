function merged = merge_img(segments, Is)
    if ~iscell(segments)
        segments = {segments};
    end
    if ~iscell(Is)
        Is = {Is};
    end
    cmap = [0 0 0;0 1 0];
    for i=1:length(segments)
        rgbimg = uint8(ind2rgb(segments{i},cmap) * 255);
        merged{i} = immerge(Is{i}, rgbimg, double(segments{i} > 0) * 0.4);
    end
    if size(merged) == 1
        merged = merged{1};
    end
end