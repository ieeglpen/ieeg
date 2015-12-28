function PlotMeanValuesForSortedConditionsInTimeWindowsAndFrequency(fileNameList,conditionsStruct,condition2sort,colors,freqs,timesout,freqsWindowList,timeWindowList,labels,caxisValuesList)

%filename is a cell array of values for every frequency
%Note: freqsWindow, timeWindow and filename must have the same first dimension

freqsWindowSize = size(freqsWindowList,1);
timeWindowSize = size(timeWindowList,1);
fileNameSize = size(fileNameList,2);

if ~(freqsWindowSize == fileNameSize)
    msgID = 'ERROR:';
    msg = 'Dimensions of inputs are incorrect.';
    baseException = MException(msgID,msg);
    throw(baseException)
end

for i = 1 : freqsWindowSize
    
    fileName = fileNameList{i};
    freqsWindow = [freqsWindowList(i,1) freqsWindowList(i,2)];
    caxisValues = [caxisValuesList(i,1) caxisValuesList(i,2)];
        
    for j = 1 : timeWindowSize    
        timeWindow = [timeWindowList(j,1) timeWindowList(j,2)];
        windowStr = strcat(num2str(timeWindowList(j,1)),'-',num2str(timeWindowList(j,2)));
        
        newFileName = horzcat(fileName,' ',windowStr);
        %newFileName = [fileName,' ',windowStr];
        %newFileName = [fileName,' ',num2str(timeWindowList(j,1)),'-',num2str(timeWindowList(j,2))];
        %newFileName = strcat(fileName,' ',num2str(timeWindowList(j,1)),'-',num2str(timeWindowList(j,2)));
        PlotMeanValuesForSortedConditions(newFileName,conditionsStruct,condition2sort,colors,freqs,timesout,freqsWindow,timeWindow,labels,caxisValues);
    end
end