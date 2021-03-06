function PlotMetricasGrafoFor2ConditionsByChannel(channel,matsInStruct1,matsInStruct2,p_value,method,offset,conditionName1,conditionName2,color1,color2,colorPvalue,colorTvalue,fileNamePrefix,root,labels)
%INPUTS:
%matsInStruct1: metricasPorSuj de la primera condicion
%matsInStruct2: metricasPorSuj de la segunda condicion
%conditionName1
%conditionName2
%root: path where figures are going to be saved
%titleName: suffix of titles and file names to be saved
%?colorCode1: color that represents condition1
%?colorCode2: color that represents condition2

[L1_d C1_d degree1_d BC1_d globalEfficiency1_d localEfficiency1_d SW1_d] = GetMetricasPorDensidad(matsInStruct1);
[L2_d C2_d degree2_d BC2_d globalEfficiency2_d localEfficiency2_d SW2_d] = GetMetricasPorDensidad(matsInStruct2);

%[L1_u C1_u degree1_u BC1_u globalEfficiency1_u localEfficiency1_u SW1_u] = GetMetricasPorDensidad(matsInStruct1);
%[L2_u C2_u degree2_u BC2_u globalEfficiency2_u localEfficiency2_u SW2_u] = GetMetricasPorDensidad(matsInStruct2);

% [degree1_w BC1_w] = GetMetricasPesadas(matsInStruct1);
% [degree2_w BC2_w] = GetMetricasPesadas(matsInStruct2);

pasosNr = size(L1_d,2);
trialNr = size(L1_d,1);
chanNr = size(BC1_d,2);

%settings for measures by channel
EjeX = 1:pasosNr;
EjeY = labels;
tickPercentage = 0.05;

%%DENSIDAD

%Clustering: C - dim: chanNr x pasos
meanC1_d = squeeze(mean(C1_d(:,channel,:),2));
meanC2_d = squeeze(mean(C2_d(:,channel,:),2));
titleName = [fileNamePrefix '-DClustering-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(meanC1_d(:,offset:end)',meanC2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(meanC1_d',meanC2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

%degree: degree: - dim: chanNr x pasos
meandegree1_d = squeeze(mean(degree1_d(:,channel,:),2));
meandegree2_d = squeeze(mean(degree2_d(:,channel,:),2));
titleName = [fileNamePrefix '-DDegree-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(meandegree1_d(:,offset:end)',meandegree2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(meandegree1_d',meandegree2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

%Betweenness: BC - dim: chanNr x pasos
meanBC1_d = squeeze(mean(BC1_d(:,channel,:),2));
meanBC2_d = squeeze(mean(BC2_d(:,channel,:),2));
titleName = [fileNamePrefix '-DBetweenness-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(meanBC1_d(:,offset:end)',meanBC2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(meanBC1_d',meanBC2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

% %%UMBRAL
% 
% %Clustering: C - dim: chanNr x pasos
% meanC1_u = squeeze(mean(C1_u(:,channel,:),2));
% meanC2_u = squeeze(mean(C2_u(:,channel,:),2));
% titleName = [fileNamePrefix '-UClustering-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(meanC1_u',meanC2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
% 
% %degree: degree: - dim: chanNr x pasos
% degree1_u = squeeze(mean(degree1_u(:,channel,:),2));
% degree2_u = squeeze(mean(degree2_u(:,channel,:),2));
% titleName = [fileNamePrefix '-UDegree-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(degree1_u',degree2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
% 
% %Betweenness: BC - dim: chanNr x pasos
% meanBC1_u = squeeze(mean(BC1_u(:,channel,:),2));
% meanBC2_u = squeeze(mean(BC2_u(:,channel,:),2));
% titleName = [fileNamePrefix '-UBetweenness-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(meanBC1_u',meanBC2_u',method,p_value,color1,color
% 2,colorPvalue,conditionName1,conditionName2,titleName,root)
