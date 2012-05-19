function probability = multilabel_probability(theta, test_x, omega)
% MULTILABEL_PROBABILITY compute probabilities for each point given theta
% omega should be a column vector here since test_x is d*n
  if size(omega,2) > size(omega,1)
      omega = omega';
  end
  new_output = bsxfun(@times,-theta' * test_x,omega);
  probability = 1./ (1 + exp(new_output));
end