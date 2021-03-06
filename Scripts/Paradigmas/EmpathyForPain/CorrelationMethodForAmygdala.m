function CorrelationMethodForAmygdala(fileName,filePath,epochs,condition1, condition2,pvalue,bandpassRange,timeRange,amygdalaChanNr,newFileName,labels,caxisvalues)

%filter signal
eeglab

EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );

EEG.srate = 1024;

EEG.data = epochs.int;

EEG = pop_eegfilt( EEG, bandpassRange(1,1), bandpassRange(1,2), [], [0], 0, 0, 'fir1', 0);
filteredInt = reshape(EEG.data,[size(epochs.int,1) size(epochs.int,2) size(epochs.int,3)]);

EEG.data = epochs.acc;

EEG = pop_eegfilt( EEG, bandpassRange(1,1), bandpassRange(1,2), [], [0], 0, 0, 'fir1', 0);

filteredAcc = reshape(EEG.data,[size(epochs.acc,1) size(epochs.acc,2) size(epochs.acc,3)]);

epochs.int = filteredInt;
epochs.acc = filteredAcc;
newepochs = epochs;

newepochs.int = newepochs.int(:,timeRange(1):timeRange(2),:);
newepochs.acc = newepochs.acc(:,timeRange(1):timeRange(2),:);
newepochs.neu = newepochs.neu(:,timeRange(1):timeRange(2),:);

epochs = newepochs;

%calculo correlacion INT
valINT = epochs.int;

chanNr = size(epochs.int,1);

intTrialNr = size(epochs.int,3);
corrInt = zeros(chanNr,chanNr,intTrialNr);

for i = 1 : intTrialNr
    [RINT,P,RLO,RUP] = corrcoef(valINT(:,:,i)');
    corrInt(:,:,i) = RINT;
end

valACC = epochs.acc;

accTrialNr = size(epochs.acc,3);
corrAcc = zeros(chanNr,chanNr,accTrialNr);

for j = 1 : accTrialNr
    [RACC,P,RLO,RUP]=corrcoef(valACC(:,:,j)');
    corrAcc(:,:,j) = RACC;
end

matrixFilename = [newFileName '-' condition1 '.mat'];
m = corrInt;

str = ['save ' matrixFilename ' m'];
eval(str)

matrixFilename = [newFileName '-' condition2 '.mat'];
m = corrAcc;
str = ['save ' matrixFilename ' m'];
eval(str)

%[stats df pvals surrog] = statcond({RINT',RACC'},'paired','off','method','perm','naccu',200);
%[t df pvals] = statcond({corrInt,corrAcc}, 'mode', 'bootstrap','paired','off','tail','both','naccu',200);   %calcula permutaciones
[t df pvals] = statcond({corrInt,corrAcc}, 'mode', 'perm','paired','off','tail','both','naccu',1000);   %calcula permutaciones

t2plot = t;
t2plot(pvals>pvalue) = 0;

colorMap = 'jet';
titlename = [newFileName '-' condition1 '-' condition2];
dosave = 0;

PlotFormattedMap(t2plot,labels,caxisvalues,colorMap,titlename,titlename,dosave);

amygdalaInt = corrInt(amygdalaChanNr,:,:);
amygdalaAcc = corrAcc(amygdalaChanNr,:,:);
r_amygdalaInt = reshape(amygdalaInt,size(amygdalaChanNr,2)*chanNr,intTrialNr);
r_amygdalaAcc = reshape(amygdalaAcc,size(amygdalaChanNr,2)*chanNr,accTrialNr);

[tamygdala df pvalsamygdala] = statcond({r_amygdalaInt,r_amygdalaAcc}, 'mode', 'bootstrap','paired','off','tail','both','naccu',200);

tamygdala2plot = tamygdala;
tamygdala2plot(pvalsamygdala > pvalue) = 0;

tamygdala2plot = reshape(tamygdala2plot,size(amygdalaChanNr,2),chanNr);

amygdalaMat = zeros(chanNr,chanNr);

amygdalaMat(amygdalaChanNr,:) = tamygdala2plot;

%caxisvalues = [-3 3];
colorMap = 'jet';
titlename = [newFileName 'amygdala-' condition1 '-' condition2];
dosave = 0;
PlotFormattedMap(amygdalaMat,labels,caxisvalues,colorMap,titlename,titlename,dosave);



