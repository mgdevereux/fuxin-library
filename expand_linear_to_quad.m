function quad_feats = expand_linear_to_quad(linear_feats)
    [N,D] = size(linear_feats);
    quad_feats = zeros(N,D*2 + D*(D-1)/2);
    quad_feats(:,1:D) = linear_feats;
    quad_feats(:,(D+1):(2*D)) = linear_feats.^2;
    counter = 2*D;
    for i=1:(D-1)
        quad_feats(:,(counter+1):(counter+D-i)) = bsxfun(@times, linear_feats(:,i), linear_feats(:,(i+1):end));
        counter = counter + D-i;
    end
end