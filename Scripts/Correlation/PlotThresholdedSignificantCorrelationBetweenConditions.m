function PlotThresholdedSignificantCorrelationBetweenConditions(t,df,pvals,newFileName,labels,caxisvalues,colorMap,colorMax,colorMin,pvalue,threshold,electrodeInfoFile,anatomicFile,nodeSpecStruct)

t2plot = t;
t2plot(pvals>pvalue) = 0;

pmask = pvals;
pmask(pmask > pvalue) = 0;
pmask(pmask~= 0) = 1;

colorMap = 'jet';
%titlename = [newFileName '-' condition1 '-' condition2];
dosave = 0;

%calculate Tmax, Tmin
Tmax = GetThresholdValueForConnectivityMatrix(t2plot,threshold);
Tmin = -Tmax;

%plot matrix
PlotFormattedMap(t2plot,labels,caxisvalues,colorMap,newFileName,newFileName,dosave);

signifVals = t2plot(t2plot~=0);
figure,hist(signifVals(:),100)
name = [newFileName '_Signif'];
title(name)

%histogram
%plot histogram
figure, hist(t(:),100);
box off
name = [newFileName '_histogram'];
title(newFileName)
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

%print conexions: 3D plot - plot 2 BrainNet Viewer 
TTestHeadPlot(t2plot,pmask,Tmax,Tmin,colorMax,colorMin,pvalue,electrodeInfoFile,newFileName,anatomicFile,nodeSpecStruct)
