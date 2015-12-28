function PlotMetricasGrafosParaTauPorCanal(channel,taus,p_value,method,offset,conditionName1,conditionName2,color1,color2,colorPvalue,colorTvalue,fileNamePrefix,fileNameSuffix,root,labels)

for i = 1 : size(taus,2) 

    %load first matrix

    str = [fileNamePrefix conditionName1 num2str(taus(i)) fileNameSuffix]
    load(str)
    
    matsInStruct1 = metricasPorSuj;
    
    clear metricasPorSuj;
    
    str = [fileNamePrefix conditionName2 num2str(taus(i)) fileNameSuffix]
    load(str)
    
    matsInStruct2 = metricasPorSuj;
    
    clear metricasPorSuj;
    
    fileNamePrefixForPlot = [fileNamePrefix num2str(taus(i)) fileNameSuffix];
    
    PlotMetricasGrafoFor2ConditionsByChannel(channel,matsInStruct1,matsInStruct2,p_value,method,offset,conditionName1,conditionName2,color1,color2,colorPvalue,colorTvalue,fileNamePrefixForPlot,root,labels);
end