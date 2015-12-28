function normConnMat = NormalizeConnMat(connMat)
% From a symmetric connectivity matrix (of T-values) returns the normalized
% matrix to a range of values of -1 to 1. Sets diagonal values to 0

%just in case -> set diagonal values to 0
connMat(logical(eye(size(connMat)))) = 0;

%get maximum value to scale values
%because the matrix can have positive and negative values 
%the maximum value is calculated from the absolute value mat
maxVal = max(reshape(abs(connMat), 1 , size(connMat,1)*size(connMat,1)));

normConnMat = connMat/maxVal;

