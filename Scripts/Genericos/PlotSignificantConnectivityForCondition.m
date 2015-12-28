function PlotSignificantConnectivityForCondition(conditionMat,p_value,path2save,labels,Tmax,Tmin,colorMax,colorMin,electrodeInfoFile,titleName,anatomicFile,nodeSpecStruct)
%calculates ttest for mean value of condition matrix for each point.
%INPUTS:
%conditionMat: 3D matrix, 1D and 2D: channels, 3D: trials
%asumes conditionMat y symmetric to its diagonal

channelNr = size(conditionMat,1);

%calculate mean connectivity value for matrix
matrixMeanTrial = squeeze(mean(conditionMat,3));
uniqueValuesForMeanMatrix = triu(matrixMeanTrial); %get triangular values of matrix
uniqueValuesForMeanMatrix(logical(eye(size(uniqueValuesForMeanMatrix)))) = 0; %sets diagonal values to 0
matrixMean = mean(uniqueValuesForMeanMatrix(uniqueValuesForMeanMatrix~=0));

%calculate ttest for each connection
pvalueMatrix = zeros(channelNr,channelNr);
tvalueMatrix = zeros(channelNr,channelNr);

for i = 1 : channelNr - 1
    for j = i + 1 : channelNr
        X = squeeze(conditionMat(i,j,:));
        [H,P,CI,STATS] = ttest(X,matrixMean,p_value,'both');
        pvalueMatrix(i,j) = P;
        pvalueMatrix(j,i) = P;
        tvalueMatrix(i,j) = STATS.tstat;
        tvalueMatrix(j,i) = STATS.tstat;
    end
end

PMask = pvalueMatrix;
PMask(PMask > p_value) = 0;

tSignifMat = tvalueMatrix;
tSignifMat(PMask == 0) = 0;

tSignifVals = tSignifMat(tSignifMat ~= 0);
%histogram?
%plot histogram of significant values
figure, hist(tSignifVals(:),100);
title([titleName 'Signif'])

%plot mean connection matrix
caxisValues = [];
PfileName = [path2save titleName '_ConnMat'];
PlotFormattedMap(matrixMeanTrial,labels,caxisValues,'jet',titleName,PfileName,1); 

%plot significant T value connection matrix
caxisValues = [];
PfileName = [path2save titleName '_SignifTValMat'];
PlotFormattedMap(tSignifMat,labels,caxisValues,'jet',[titleName 'Significant'],PfileName,1); 

%print .edge weighted //pTTestHeadPlot???
TTestHeadPlot(tSignifMat,PMask,Tmax,Tmin,colorMax,colorMin,p_value,electrodeInfoFile,[path2save titleName 'ConnPlot'],anatomicFile,nodeSpecStruct);
%PrintEdgeFile([path titleName '_weighted'],tSignifMat);