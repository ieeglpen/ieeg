function PlotHeadConnectivityForTimeRange(signalFileName,electrodeInfoFile,anatomicFile,threshold,timeWindows,titleName)
%signalFileName: .mat - must contain
%   * 3D matrix named result, 1D:electrode pairs - 2D: time -
%                             3D: frequency
%   * EjeX: 1 x time points
%   * EjeF: 1 x frequency bins
%   * ParElec: electrode pairs x 2
% electrodeInfoFile: .txt - 5 columns with channel labels and cartesian
%                   coordinates of channels - NO HEADER FILE
%   * 1 - nr of channel 
%   * 2 - label of channel
%   * 3 - x
%   * 4 - y
%   * 5 - z
%threshold: value used to binarize vector
%timeWindows: N x 2, indicates the initial and final times of window ([initTime finalTime]) 


%load .mat with signal, time, frequency and pair of electrodes values
load(signalFileName);

%import data of .txt - loads textdata (N x 1) with labels and coordinate data (N x 3)
elecs = importdata(electrodeInfoFile);

matrixSize = size(elecs.data,1);

%create electrodes structure
x = elecs.data(:,1);
y = elecs.data(:,2);
z = elecs.data(:,3);

ch_label = elecs.textdata(:,2);

electrodes.x = x;
electrodes.y = y;
electrodes.z = z;
electrodes.labels = ch_label;

% mean by frequency
resultMean = mean(result,3);

[timeWindowPositions] = GetTimeWindowPositionsForRange(EjeX,timeWindows);

for i = 1 : size(timeWindowPositions,1)

    timeWindowColumns = timeWindowPositions(i,:);
    values2Plot = GetValues2Plot(resultMean,timeWindowColumns,threshold);

    %plot de todos los electrodos y de las conexiones con umbral mayor a
    %threshold
    %completeTitleName = [titleName '- timeWindow: ' num2str(EjeX(timeWindowColumns(1,1))) '-' num2str(EjeX(timeWindowColumns(1,2))) ' - threshold: ' num2str(threshold)];
    completeTitleName = [titleName '(' num2str(threshold) ')' num2str(round(EjeX(timeWindowColumns(1,1)))) '-' num2str(round(EjeX(timeWindowColumns(1,2))))];
    PlotIntracranealsConnections(electrodes,ParElec,values2Plot,completeTitleName);

    %shortTitleName = [titleName '(' num2str(threshold) ')' num2str(round(EjeX(timeWindowColumns(1,1)))) '-' num2str(round(EjeX(timeWindowColumns(1,2)))) '_Connections.mat'];
    shortTitleName = [titleName '(' num2str(threshold) ')' num2str(round(EjeX(timeWindowColumns(1,1)))) '-' num2str(round(EjeX(timeWindowColumns(1,2))))];
    connectionMatrix = PrintConnections(matrixSize,[completeTitleName '_Connections.txt'],shortTitleName);

    %nodeTitleName = [titleName '(' num2str(threshold) ')' num2str(round(EjeX(timeWindowColumns(1,1)))) '-' num2str(round(EjeX(timeWindowColumns(1,2)))) '.node'];
    
    nodeSpecStruct = [];
    mode = 'connectionNr';
    PrintNodeFile(electrodeInfoFile,anatomicFile,connectionMatrix,shortTitleName,nodeSpecStruct,mode);
    
    %PrintNodeFile(preprocessedElectrodeFile,anatomicFile,connectionMatrix,fileName2Save,nodeSpecStruct,mode);
    PrintEdgeFile(shortTitleName,connectionMatrix);
end
