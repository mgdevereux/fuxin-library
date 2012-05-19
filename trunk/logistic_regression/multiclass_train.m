function classifiers = multiclass_train(train_x, train_y, eta, theta_l2)
% MULTILABEL_TRAIN return set of classifiers for each class

  n_class     = max(train_y);
  n_point     = size(train_x,2);
  classifiers = cell(n_class,1);
  if(nargin < 4),  theta_l2   = 0; end;
  
  train_x     = [train_x; ones(1,n_point)];   % add constant term
  
  for i=1:n_class
    classifiers{i} = struct;
    classifiers{i}.theta = ...
        train_theta_i(train_x, train_y, eta(i,:), theta_l2);
  end
end

function theta = train_theta_i(train_x, train_y, eta_row_i, theta_l2)
  options = ...
    struct(...
    'TolFun',1e-3,...  % A minimization terminates when ||g|| < \ref epsilon * max(1, ||x||)
...%    'LS',0,...    % Delta for convergence test.
    'MaxIter',1000,... %The maximum number of iterations.
    'MaxFunEvals',100000,...
    'Display','final'); % The maximum number of function evaluations
  
  fn = @(x) fn_expect_like_theta(x, train_x, train_y, eta_row_i, theta_l2);
  theta = minFunc(fn, zeros(size(train_x,1),1), options);
end
