function obj = InitExplicitKernel( kernel, alpha, D, Napp, options )
%INITEXPLICITKERNEL compute kernel based on explicit linear features
%
% kernel - the name of the kernel. Supported options are: 
%             'rbf': Gaussian, 
%             'laplace': Laplacian, 
%             'chi2': Chi-square, 
%             'chi2_skewed': Skewed Chi-square,
%             'intersection', Histogram Intersection, 
%             'intersection_skewed', Skewed Histogram Intersection
% alpha  - the parameter of the kernel, e.g., the gamma in \exp(-gamma ||x-y||) 
%        for the Gaussian.
% D      - the number of dimensions
% Napp 	 - the number of random points you want to sample
% options: options. Now including only: 
%         options.method: 'sampling' or 'signals', signals for [Vedaldi 
%                         and Zisserman 2010] type of fixed interval sampling. 
%                         'sampling' for [Rahimi and Recht 2007] type of 
%                         Monte Carlo sampling.
%
% copyright (c) 2010 
% Fuxin Li - fuxin.li@ins.uni-bonn.de
% Catalin Ionescu - catalin.ionescu@ins.uni-bonn.de
% Cristian Sminchisescu - cristian.sminchisescu@ins.uni-bonn.de

% number of explicit features with which to approximate
if nargin < 4
  Napp = 10; 
end
if ~exist('options','var')
    options = [];
end

switch kernel
    case 'rbf'
        % check
        obj = rf_init('gaussian', alpha, D, Napp, options);
    case 'exp_hel'
        obj = rf_init('exp_hel', alpha, D, Napp, options);
        
    case 'laplace'
        % not verified
        obj = rf_init('laplace', alpha, D, Napp, options);
    
  case 'chi2'
    if ~isfield(options, 'method')
      options.method = 'signals';
      if ~isfield(options,'period') || isempty(options.period)
        options.period = 4e-1;
      end
      if ~isfield(options,'Nperdim') || isempty(options.Nperdim)
        options.Nperdim = 7;
      end
    elseif strcmp(options.method,'chebyshev')
        if ~isfield(options,'Nperdim') || isempty(options.Nperdim)
            options.Nperdim = 50;
        end
    end
    obj = rf_init('chi2', alpha, D, Napp, options);
    
  case 'chi2_skewed'
    obj = rf_init('chi2', alpha, D, Napp, options);
    obj.name = 'chi2_skewed';
    
  case 'intersection'
    obj = rf_init('intersection', alpha, D, Napp, options);
  
  case 'intersection_skewed'
    obj = rf_init('intersection', alpha, D, Napp, options);
    obj.name = 'intersection_skewed';
    % Linear: no approximation, Napp is ignored
    
  case 'linear'
    obj.name = 'linear';
    obj.Napp = D;
    obj.dim = D;
    obj.final_dim = D;
    
  case 'exp_chi2'
    if ~isfield(options,'method')
        options.method = 'chebyshev';
    end
    if ~isfield(options,'period')
        options.period = 0.4;
    end
    if ~isfield(options,'Nperdim')
        options.Nperdim = 9;
    end
    obj = rf_init('exp_chi2', alpha, D, Napp, options);
  otherwise
    error('Unknown kernel');
end

end

