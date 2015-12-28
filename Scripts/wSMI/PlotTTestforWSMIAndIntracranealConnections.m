function PlotTTestforWSMIAndIntracranealConnections(condition1,condition2,p_value,colorMax,colorMin,Tmax,Tmin,tau,fileName,channelNr,path,newFileName,labels,electrodeInfoFile,anatomicFile,nodeSpec)

%plot de la matriz de T values y del histograma
%T = PlotTTestforWSMI(condition1,condition2,tau,fileName,channelNr,path,newFileName,labels);
[T Pmask] = PlotTTestforWSMIOriginal(condition1,condition2,tau,fileName,channelNr,path,newFileName,labels,p_value,Tmax,Tmin);
%plot de los valores que superan umbrales de T en head plot
TTestHeadPlot(T,Pmask,Tmax,Tmin,colorMax,colorMin,p_value,electrodeInfoFile,newFileName,anatomicFile,nodeSpec);
