function [Omega] = subsampling_code(X_input, obs)
rng('shuffle');
temp_val = floor((obs * numel(X_input)));
temp_idx = randperm(numel(X_input),temp_val);
temp_mat = zeros(1,numel(X_input));
temp_mat(temp_idx) = 1;
Omega = reshape(temp_mat,size(X_input,1),size(X_input,2));
index_zero = find(all(Omega==0));
% if(~isempty(length(index_zero)))
%     Omega = subsampling_code(X_input, obs);
% end
end
