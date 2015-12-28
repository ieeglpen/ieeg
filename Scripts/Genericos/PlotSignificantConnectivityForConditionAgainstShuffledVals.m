function PlotSignificantConnectivityForConditionAgainstShuffledVals(conditionMat,p_value,path2save,labels,Tmax,Tmin,colorMax,colorMin,electrodeInfoFile,titleName,anatomicFile,nodeSpecStruct)
%calculates ttest for mean value of condition matrix for each point.
%INPUTS:
%conditionMat: 3D matrix, 1D and 2D: channels, 3D: trials
%asumes conditionMat y symmetric to its diagonal

channelNr = size(conditionMat,1);
[shuffledMat] = RandomShuffleConnectivityMatrixByTrial(conditionMat);

[stats, df, pvals, surrog] = statcond( {conditionMat,shuffledMat}, 'method','bootstrap','naccu',1000 );

PMask = pvals;
PMask(PMask > p_value) = 0;

tSignifMat = stats;
tSignifMat(PMask == 0) = 0;

%histogram?
%plot histogram of significant values
figure, hist(tSignifMat(:),100);
title([titleName 'Signif'])

%plot mean connection matrix
%calculate mean connectivity value for matrix
matrixMeanTrial = squeeze(mean(conditionMat,3));
caxisValues = [];
PfileName = [path2save titleName 'ConnMat'];
PlotFormattedMap(matrixMeanTrial,labels,caxisValues,'jet',titleName,PfileName,1); 

%plot significant T value connection matrix
caxisValues = [];
PfileName = [path2save titleName 'SignifTValMat'];
PlotFormattedMap(tSignifMat,labels,caxisValues,'jet',[titleName 'Significant'],PfileName,1); 

%print .edge weighted //pTTestHeadPlot???
TTestHeadPlot(tSignifMat,PMask,Tmax,Tmin,colorMax,colorMin,p_value,electrodeInfoFile,[path2save titleName 'ConnPlot'],anatomicFile,nodeSpecStruct);
%PrintEdgeFile([path titleName '_weighted'],tSignifMat);