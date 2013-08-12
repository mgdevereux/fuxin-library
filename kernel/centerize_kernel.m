function [K2, input_kernel_mean] = centerize_kernel(K)
    input_kernel_mean = sum(K,1) / size(K,1);
    K2 = bsxfun(@minus, K, input_kernel_mean);
    K2 = bsxfun(@minus, K2, sum(K,2)/size(K,1));
    K2 = bsxfun(@plus,K2, sum(K(:))/(size(K,1)*size(K,1)));
    K2 = (K2 + K2') / 2;
end