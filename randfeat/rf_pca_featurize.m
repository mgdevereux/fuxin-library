function [F, rf_obj] = rf_pca_featurize(rf_obj, x,train_pca, Npcadim, Napp)
% The returned rf_obj will contain the PCA means and bases.
%
% This function has two functionalities: if train_pca is on, it overwrites
% the PCA mean and bases in rf_obj (for training). Otherwise, it uses the PCA mean and
% bases stored within rf_obj, if there aren't any, it reports an error.
%
% Napp doesn't need to be specified (see document of rf_featurize).
%
% Npcadim doesn't need to be specified during test time.
%
% Napp is temporary, if PCA works, will implement an incremental SVD so
% that we can extract even more random vectors but still return a vector with
% Npcadim length.
    if exist('Napp','var')
        F = rf_featurize(rf_obj, x, Napp);
    else
        F = rf_featurize(rf_obj,x);
        Napp = size(F,2);
    end
    % Training: do PCA and store the pca_mean and pca_basis in rf_obj
    if exist('train_pca','var') && train_pca
        rf_obj.pca_mean = mean(F);
        t = tic();
% This already uses the economy form
        basisx = princomp(F);
        disp('PCA time: ');
        toc(t);
% Random projection version, doesn't work
%        basisx = randn(Napp, Npcadim);
%        len = sum(basisx.^2);
%        basisx = basisx ./ repmat(sqrt(len),Napp, 1);
        rf_obj.pca_basis = basisx(:,1:Npcadim);
        t = tic();
        F = F - rf_obj.pca_mean(ones(1,size(F,1)),:);
        F = F * rf_obj.pca_basis;
        disp('Projection time: ');
        toc(t);
        rf_obj.final_dim = Npcadim;
    % Testing: Project the data to the PCA subspace
    else
        if ~isfield(rf_obj,'pca_mean') || ~isfield(rf_obj, 'pca_basis')
            error('Before projecting the test data, need to do rf_pca_featurize with is_train first!');
        end
        F = F - rf_obj.pca_mean(ones(1,size(F,1)),:);
        F = F * rf_obj.pca_basis;
    end
end
