function [shuffledMat] = RandomShuffleConnectivityMatrixByTrial(mat)
%mat: 3D matrix, 1D and 2D channels, 3D trials
%diagonal values are not considered (either if they are Nan o 0)
trialNr = size(mat,3);
channelNr = size(mat,1);
shuffledMat = zeros(channelNr,channelNr,trialNr);

for k = 1 : trialNr
    newmat = zeros(channelNr,channelNr);
    matTrial = squeeze(mat(:,:,k));
    uniqueValuesForMeanMatrix = triu(matTrial); %get triangular values of matrix
    uniqueValuesForMeanMatrix(logical(eye(size(uniqueValuesForMeanMatrix)))) = 0; %sets diagonal values to 0
    [indexes] = find(uniqueValuesForMeanMatrix~=0);
    
    newmat(indexes) = matTrial(indexes(randperm(length(indexes))));
    
    for i = 1 : channelNr - 1
        for j = i + 1 : channelNr
            newmatoneval = newmat(i,j);
            newmattwoval = newmat(j,i);
            newval = newmatoneval + newmattwoval;
            newmat(i,j) = newval;
            newmat(j,i) = newval;
        end
    end 

    shuffledMat(:,:,k) = newmat;
end