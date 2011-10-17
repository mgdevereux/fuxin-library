function [train_splits, test_splits] = cv_split(len, folds)
    t = randperm(len);
    train_splits = cell(folds,1);
    test_splits = cell(folds,1);
    for i=1:folds
        if i==1
            train_bags = t((floor(len/folds)+1):len);
            test_bags = t(1: floor(len/folds));
        elseif i==folds
            train_bags = t(1:(folds - 1)*floor(len/folds));
            test_bags = t(((folds-1)*floor(len/folds)+1):len);
        else
            train_bags = [t(1:(i-1)*floor(len/folds)) t((i*floor(len/folds)+1):len)];
            test_bags = t((((i-1)*floor(len/folds)+1):(i)*floor(len/folds)));
        end
        train_splits{i} = train_bags;
        test_splits{i} = test_bags;
    end
end
