function [f, g] = fn_expect_like_theta(theta, X, z, eta_ith_row, theta_l2)
  eta_vector  = eta_vector_from_z(eta_ith_row,z);
  
  thetaT_X   = theta' * X;
  p          = 1 ./ (1 + exp (-thetaT_X));

  f          = - full(sum( eta_vector .* thetaT_X ...
                      + log (1-p) ));

  g          = - full(sum( bsxfun(@times,(eta_vector - p),X),2 ));
                    
   f          = f + theta_l2*norm(theta).^2;
   g          = g + 2*theta_l2*theta;
end

function eta_vec = eta_vector_from_z(eta_ith_row,z)
  eta_vec = eta_ith_row(z);
end