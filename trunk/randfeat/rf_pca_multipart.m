function rf_obj = rf_pca_multipart(rf_obj, LinReg_Build, dim)
    if ~strcmp(class(LinReg_Build), 'LinearRegressor_Data')
        error('LinReg_Build must be of class LinearRegressor_Data');
    end
    [rf_obj.pca_basis, rf_obj.pca_mean] = LinReg_Build.PCA(dim);
    rf_obj.final_dim = dim;
    rf_obj.pca_mean = rf_obj.pca_mean';
end
