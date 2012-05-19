function [predictions, probability] = multiclass_predict(classifiers, test_x, omega)
% MULTILABEL_PREDICT return set of predictions for each class

  n_class     = size(classifiers,1);
  n_point     = size(test_x,2);
  probability = zeros(n_class,n_point);
  
  test_x     = [test_x; ones(1,n_point)];   % add constant term at the end 
  
  if ~exist('omega','var') || isempty(omega)
      omega = ones(n_class,1);
  end
  
  for i=1:n_class
    probability(i,:) = ...
      multilabel_probability(classifiers{i}.theta, test_x, omega(i));
  end
  [~,predictions] = max(probability,[],1);
end