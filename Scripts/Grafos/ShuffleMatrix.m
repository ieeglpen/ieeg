function matPermFinal = ShuffleMatrix(mat)

chanNr = size(mat,1);

%reshape matrix to convert into a vector
mat22Vec = reshape(mat,size(mat,1)*size(mat,2),1);
permResult = zeros(size(mat,1)*size(mat,2),1);

%get indexes of unique values (lower triangle of matrix WITHOUT diagonal
ind = triu(~eye(chanNr));   
i = find(ind); 
originalValues = mat22Vec(i);

%permute indexes
idx = randperm(length(i));

%get values 
xperm = originalValues(idx);
permResult(i) = xperm; 
%matPerm = reshape(xperm,chanNr,chanNr);
matPerm = reshape(permResult,chanNr,chanNr);
matPermFinal = triu(matPerm)+triu(matPerm,1)';  % upper matrix, copyed to the lower half

