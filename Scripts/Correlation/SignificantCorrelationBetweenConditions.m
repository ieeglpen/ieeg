function SignificantCorrelationBetweenConditions(signal1,signal2,condition1, condition2,pvalue,newFileName,labels,caxisvalues,Tmax,Tmin,colorMax,colorMin,electrodeInfoFile,anatomicFile,nodeSpecStruct)

%calculo correlacion 
chanNr = size(signal1,1);

cond1TrialNr = size(signal1,3);
corrCond1 = zeros(chanNr,chanNr,cond1TrialNr);

for i = 1 : cond1TrialNr
    [R1,P,RLO,RUP] = corrcoef(signal1(:,:,i)');
    corrCond1(:,:,i) = R1;
end

cond2TrialNr = size(signal2,3);
corrCond2 = zeros(chanNr,chanNr,cond2TrialNr);

for j = 1 : cond2TrialNr
    [R2,P,RLO,RUP]=corrcoef(signal2(:,:,j)');
    corrCond2(:,:,j) = R2;
end

% matrixFilename = [newFileName '-' condition1 '.mat'];
% m = corrCond1;
% 
% str = ['save ' matrixFilename ' m'];
% eval(str)
% 
% matrixFilename = [newFileName '-' condition2 '.mat'];
% m = corrCond2;
% str = ['save ' matrixFilename ' m'];
% eval(str)

%[stats df pvals surrog] = statcond({RINT',RACC'},'paired','off','method','perm','naccu',200);
%[t df pvals] = statcond({corrInt,corrAcc}, 'mode', 'bootstrap','paired','off','tail','both','naccu',500);   %calcula permutaciones
[t df pvals] = statcond({corrCond1,corrCond2}, 'mode', 'perm','paired','off','tail','both','naccu',500);   %calcula permutaciones

matrixFilename = [newFileName '-' condition1 '-' condition2 '.mat'];
str = ['save ' matrixFilename ' t df pvals'];
eval(str)

% t2plot = t;
% t2plot(pvals>pvalue) = 0;
% 
% pmask = pvals;
% pmask(pmask > pvalue) = 0;
% pmask(pmask~= 0) = 1;
% 
% colorMap = 'jet';
% titlename = [newFileName '-' condition1 '-' condition2];
% dosave = 0;
% 
% PlotFormattedMap(t2plot,labels,caxisvalues,colorMap,titlename,titlename,dosave);
% 
% %print conexions: 3D plot - plot 2 BrainNet Viewer 
% TTestHeadPlot(t2plot,pmask,Tmax,Tmin,colorMax,colorMin,pvalue,electrodeInfoFile,titlename,anatomicFile,nodeSpecStruct)


