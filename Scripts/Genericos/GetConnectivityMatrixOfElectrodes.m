function resultMat = GetConnectivityMatrixOfElectrodes(mat,channels)
% puts 0 value to rows and columns that are not included in channels list
% INPUTS
% mat: N * N connectivity matrix
% channels: list of values of mat that are NOT zeroed

resultMat = mat;

N = size(mat,1);
completeChannelsSet = 1 : N;
set2Silence = setdiff(completeChannelsSet,channels);

resultMat(set2Silence,set2Silence) = 0;