function [WI,edge_weights, num_edges] = group_boundaries(Pb_fat, Pb_thin)
% Group boundaries by the watershed image and a thin version of Pb
% Basically, we will run watershed transform on Pb_fat and group all the
% edges found from the watershed into different line segments, then we will
% eliminate the boundaries where Pb_thin = 0 and merge the corresponding
% superpixels
    WI = watershed(Pb_fat);
    [boundary_x, boundary_y] = ind2sub(size(WI),find(WI==0));
    locs = find(WI==0);
    num_superpix = double(max(WI(:)));
    boundary_x_small = max(1, boundary_x-1);
    boundary_x_large = min(boundary_x + 1, size(WI,1));
    boundary_y_small = max(1, boundary_y-1);
    boundary_y_large = min(boundary_y + 1, size(WI,2));
    in_box = arrayfun(@(x1,x2,y1,y2) find_unique_elems(x1,x2,y1,y2,WI), boundary_x_small, ...
       boundary_x_large, boundary_y_small, boundary_y_large,'UniformOutput',false);
    [groups,~, assignments] = unique(cell2mat(in_box),'rows');
    num_edges = histc(assignments, 1:size(groups,1));
    to_combine = arrayfun(@(x) sum(Pb_thin(locs(assignments==x))), 1:size(groups,1))';
    % Find the binary edges of to_combine
    bin_edges = to_combine == 0 & groups(:,3) == 0;
    the_graph = sparse(num_superpix,num_superpix);
    inds = sub2ind(size(the_graph), double(groups(bin_edges,1)), double(groups(bin_edges,2)));
    the_graph(inds) = 1;
    the_graph = the_graph + the_graph';
    % Find connected components
    [S,C] = graphconncomp(the_graph);
    num_coms = histc(C,1:S);
    num_in_group = sum(groups~=0,2);
    the_map = 1:num_superpix;
    for i=1:S
        if num_coms(i)==1
            continue;
        end
        all_in_C = find(C==i);
        all_groups_in_clique = sum(ismember(groups,all_in_C),2) == num_in_group;
        if nnz(to_combine(all_groups_in_clique)) == 0
            % Combine, also eliminate the internal boundary
            the_map(all_in_C) = all_in_C(1);
            WI(locs(ismember(assignments, find(all_groups_in_clique)))) = all_in_C(1);
        end
    end
    [~,~,reordered_map] = unique(the_map);
    reordered_map = [0;reordered_map];
    WI = reordered_map(WI+1);
    groups = reordered_map(groups+1);
    edge_weights = arrayfun(@(x) sum(to_combine(max(groups == x,[],2))),1:max(reordered_map));
    num_edges = arrayfun(@(x) sum(num_edges(max(groups == x,[],2))),1:max(reordered_map));
end

function elems = find_unique_elems(x1,x2,y1,y2,WI)
    elems = unique(WI(x1:x2,y1:y2))';
    elems = elems(2:end);
    % Append 0
    elems = [elems zeros(1,8-length(elems))];
end