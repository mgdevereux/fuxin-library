function wSoftmax = multinomial_lr(X,y,lambda)
if ~exist('lambda','var') || isempty(lambda)
    lambda = 0;
end
[m,n] = size(X);
c = max(y);
X = [ones(n,1) X];
funObj = @(W)SoftmaxLoss2(W,X,y,c);
lambda = lambda * ones(m+1,c-1);
options.TolFun = 1e-3;
options.TolX = 1e-6;

wSoftmax = minFunc(@penalizedL2,zeros((m+1)*(c-1),1),options,funObj,lambda(:));
wSoftmax = reshape(wSoftmax,[m+1 c-1]);
wSoftmax = [wSoftmax zeros(m+1,1)];
end
