function threshold = GetThresholdValueForConnectivityMatrix(mat,thresholdPercentage)
% returns a threshold value (always positive) of a connectivity matrix (assumes symmetry) for
% a certain percentage of values - if percentage is 0.1 returns
% the value of mat above which the 10% of values lie.

% INPUTS:
% mat: connectivity matrix, N x N, symmetric through its diagonal. Diagonal
% values are considered.
% thresholdPercentage: the percentage of surviving connections desired.
% Value range: [0 1]

%get values from triangle (without diagonal) of mat
triu_mat = triu(mat);
%set diagonal values to 0
triu_mat(logical(eye(size(triu_mat)))) = 0;

%get values of upper triangular matrix without diagonal
values = triu_mat(triu_mat~=0);

%sort values
sortedvalues = sort(abs(values),'descend');

thresholdIndex = round(length(sortedvalues) * thresholdPercentage);

threshold = sortedvalues(thresholdIndex);

