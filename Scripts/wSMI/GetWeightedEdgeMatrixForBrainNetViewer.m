function weightedMatrix = GetWeightedEdgeMatrixForBrainNetViewer(matrix,pvalue)

channelNr = size(matrix,1);
weightedMatrix = zeros(channelNr,channelNr);

for i = 1 : channelNr
    for j = 1 : channelNr
        
        value = matrix(i,j);
        if value ~= 0
            weightedMatrix(i,j) = -1.2/pvalue * value + 1.5;
        end
    end
end