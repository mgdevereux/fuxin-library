function [result,outrank] = top_k(y, outputs, max_k)
    if size(y,2) > size(y,1)
        y = y';
    end
	match = false(length(y),1);
	outrank = zeros(size(outputs));
    result = zeros(max_k,1);
	for i=1:size(outputs,1)
		[~,outrank(i,:)] = sort(outputs(i,:),'descend');
	end
	for i=1:max_k
		match = match | (outrank(:,i) == y); 
		result(i) = sum(match) / length(y);
	end
end
