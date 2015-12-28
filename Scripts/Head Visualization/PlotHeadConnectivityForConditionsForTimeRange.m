function PlotHeadConnectivityForConditionsForTimeRange(signalFileName,electrodeInfoFile,threshold,timeWindows,titleName)
%signalFileName: .mat with the following variables
%   * 4D matrix named conditions, 1D: conditionNr - 2D:electrode pairs - 
%                             4D: time - 4D: frequency
%   * EjeX: 1 x time points
%   * EjeF: 1 x frequency bins
%   * ParElec: electrode pairs x 2
%   * InfoCond: structure - conditions x 2:
%               * conditionName
%               * color: condition plot properties /as text)
% electrodeInfoFile: .txt - 5 columns with channel labels and cartesian
%                   coordinates of channels - NO HEADER FILE
%   * 1 - nr of channel 
%   * 2 - label of channel
%   * 3 - x
%   * 4 - y
%   * 5 - z
%threshold: value used to binarize vector
%timeWindow: N x 2, indicates the initial and final times of each window ([initTime finalTime]) 

%load .mat with signal, time, frequency and pair of electrodes values
load(signalFileName);

%import data of .txt - loads textdata (N x 1) with labels and coordinate data (N x 3)
elecs = importdata(electrodeInfoFile);

%create electrodes structure
x = elecs.data(:,1);
y = elecs.data(:,2);
z = elecs.data(:,3);

matrixSize = size(x,1);

ch_label = elecs.textdata(:,2);

electrodes.x = x;
electrodes.y = y;
electrodes.z = z;
electrodes.labels = ch_label;
        
[timeWindowPositions] = GetTimeWindowPositionsForRange(EjeX,timeWindows);

for i = 1 : size(timeWindowPositions,1)
                              
        for j = 1 : size(conditions,1)
            % mean by frequency
            %result = squeeze(conditions(i,:,:,:),1);
            result = squeeze(conditions(j,:,:,:));
            %size(result)
            resultMean = mean(result,3);
            timeWindowColumns = timeWindowPositions(i,:);
            values = GetValues2Plot(resultMean,timeWindowColumns,threshold);
                    
            values2Plot(j).conditionName = InfoCond(j).conditionName;
            values2Plot(j).color = InfoCond(j).color;
            values2Plot(j).binarizedArray = values;
        end

        %plot de todos los electrodos y de las conexiones con umbral mayor a
        %threshold
        %completeTitleName = [titleName '- timeWindow: ' num2str(EjeX(timeWindowColumns(1,1))) '-' num2str(EjeX(timeWindowColumns(1,2))) ' - threshold: ' num2str(threshold)];
        completeTitleName = [titleName '(' num2str(threshold) ')' num2str(round(EjeX(timeWindowColumns(1,1)))) '-' num2str(round(EjeX(timeWindowColumns(1,2))))];
        shortTitleName =    [titleName '(' num2str(threshold) ')' num2str(round(EjeX(timeWindowColumns(1,1)))) '-' num2str(round(EjeX(timeWindowColumns(1,2)))) '.mat'];
        PlotIntracranealsConnectionsForConditions(electrodes,ParElec,values2Plot,completeTitleName);
%        PrintConnections(matrixSize,[completeTitleName '.mat'],shortTitleName);        
    
end
