function PlotMetricasGrafoFor2Conditions(matsInStruct1,matsInStruct2,p_value,method,offset,conditionName1,conditionName2,color1,color2,colorPvalue,colorTvalue,fileNamePrefix,root,labels)
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

[degree1_w BC1_w] = GetMetricasPesadas(matsInStruct1);
[degree2_w BC2_w] = GetMetricasPesadas(matsInStruct2);

pasosNr = size(L1_d,2);
trialNr = size(L1_d,1);
chanNr = size(BC1_d,2);

%settings for measures by channel
EjeX = 1:pasosNr;
EjeY = labels;
tickPercentage = 0.05;

%%DENSIDAD
%Path Length: L - dim: 1 x pasos
%mat first dimension must be the steps
titleName = [fileNamePrefix '-DPathLength-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(L1_d(:,offset:end)',L2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(L1_d',L2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

%Clustering: C - dim: chanNr x pasos
meanC1_d = squeeze(mean(C1_d,2));
meanC2_d = squeeze(mean(C2_d,2));
titleName = [fileNamePrefix '-DClustering-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(meanC1_d(:,offset:end)',meanC2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(meanC1_d',meanC2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

% titleName = [fileNamePrefix '-DClusteringXChan']; 
% caxisValues = [];
% mapC1_d = squeeze(mean(C1_d,1));
% mapC2_d = squeeze(mean(C2_d,1));
% 
% SubplotMapsAndSaveInRoot(mapC1_d,mapC2_d,conditionName1,conditionName2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root);

%degree: degree: - dim: chanNr x pasos
meandegree1_d = squeeze(mean(degree1_d,1));
meandegree2_d = squeeze(mean(degree2_d,1));
titleName = [fileNamePrefix '-DDegree-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(meandegree1_d(:,offset:end)',meandegree2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(meandegree1_d',meandegree2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

% titleName = [fileNamePrefix '-DDegreeXChan']; 
% caxisValues = [];
% mapdegree1_d = squeeze(mean(degree1_d,1));
% mapdegree2_d = squeeze(mean(degree2_d,1));
% 
% SubplotMapsAndSaveInRoot(mapdegree1_d,mapdegree2_d,conditionName1,conditionName2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root);

%Betweenness: BC - dim: chanNr x pasos
meanBC1_d = squeeze(mean(BC1_d,1));
meanBC2_d = squeeze(mean(BC2_d,1));
titleName = [fileNamePrefix '-DBetweenness-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(meanBC1_d(:,offset:end)',meanBC2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
plotMeanSigniTValues(meanBC1_d',meanBC2_d',offset,method,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root);

% titleName = [fileNamePrefix '-DBetweennessXChan']; 
% caxisValues = [];
% mapBC1_d = squeeze(mean(BC1_d,1));
% mapBC2_d = squeeze(mean(BC2_d,1));
% 
% SubplotMapsAndSaveInRoot(mapBC1_d,mapBC2_d,conditionName1,conditionName2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root);

%Small World: SW_Sporns - dim: 1 x pasos
% titleName = [fileNamePrefix '-DSmallWorld-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(SW1_d(:,offset:end)',SW2_d(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)

% %%UMBRAL
% %Path Length: L - dim: 1 x pasos
% %mat first dimension must be the steps
% titleName = [fileNamePrefix '-UPathLength-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(L1_u',L2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
% 
% %Clustering: C - dim: chanNr x pasos
% meanC1_u = squeeze(mean(C1_u,2));
% meanC2_u = squeeze(mean(C2_u,2));
% titleName = [fileNamePrefix '-UClustering-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(meanC1_u',meanC2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
% 
% titleName = [fileNamePrefix '-UClusteringXChan']; 
% caxisValues = [];
% mapC1_u = squeeze(mean(C1_u,1));
% mapC2_u = squeeze(mean(C2_u,1));
% 
% SubplotMapsAndSaveInRoot(mapC1_u,mapC2_u,conditionName1,conditionName2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root);
% 
% %degree: degree: - dim: chanNr x pasos
% degree1_u = squeeze(mean(degree1_u,1));
% degree2_u = squeeze(mean(degree2_u,1));
% titleName = [fileNamePrefix '-UDegree-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(degree1_u',degree2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
% 
% titleName = [fileNamePrefix '-UDegreeXChan']; 
% caxisValues = [];
% mapdegree1_u = squeeze(mean(degree1_u,1));
% mapdegree2_u = squeeze(mean(degree2_u,1));
% 
% SubplotMapsAndSaveInRoot(mapdegree1_u,mapdegree2_u,conditionName1,conditionName2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root);
% 
% %Betweenness: BC - dim: chanNr x pasos
% meanBC1_u = squeeze(mean(BC1_u,1));
% meanBC2_u = squeeze(mean(BC2_u,1));
% titleName = [fileNamePrefix '-UBetweenness-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(meanBC1_u',meanBC2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)
% 
% titleName = [fileNamePrefix '-UBetweennessXChan']; 
% caxisValues = [];
% mapBC1_u = squeeze(mean(BC1_u,1));
% mapBC2_u = squeeze(mean(BC2_u,1));
% 
% SubplotMapsAndSaveInRoot(mapBC1_u,mapBC2_u,conditionName1,conditionName2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root);
% 
% %Small World: SW_Sporns - dim: 1 x pasos
% titleName = [fileNamePrefix '-USmallWorld-' conditionName1 '-' conditionName2]; 
% plotMeanAndSignificance(SW1_u',SW2_u',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)

%PESADAS
%degree: degree: - dim: chanNr x pasos
%TODO conseguir el nuevo script de metricas
%titleName = [fileNamePrefix '- PDegree - ' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(degree1_w',degree2_w',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root)

%Betweenness: BC - dim: chanNr x pasos
titleName = [fileNamePrefix '-WBetweenness-' conditionName1 '-' conditionName2]; 
%plotMeanAndSignificance(BC1_w',BC2_w',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,titleName,root);
plotMeanAndSignificanceXChan(BC1_w(:,offset:end)',BC2_w(:,offset:end)',method,p_value,color1,color2,colorPvalue,conditionName1,conditionName2,labels,titleName,root);