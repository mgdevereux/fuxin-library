function [seeds, edge_strength, Superpixel_img, superpix_idx] = generate_seeds_from_Pb(Pb_fat, Pb_thin)
% Generate segment seeds from centroids of superpixels using watershed maps
% Seeds are sorted in edge_strength descending order, so that the first 50
% seeds are the 50 best ones.
    [Superpixel_img,edge_weights, num_edges] = group_boundaries(Pb_fat, Pb_thin);
    [edge_strength, superpix_idx] = sort(edge_weights ./ num_edges, 'descend');
    cent = arrayfun(@(x) regionprops(Superpixel_img == x,'Centroid'), superpix_idx);
    seeds = reshape([cent.Centroid],2, numel(cent));
end