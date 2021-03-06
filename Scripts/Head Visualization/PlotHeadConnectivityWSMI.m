function PlotHeadConnectivityWSMI(signalMatrix,electrodeInfoFile,anatomicFile,threshold,titleName,doPlot)
%signalMatrix: .
%   * 2D matrix, indexes represent the electrode pair
%                             
% electrodeInfoFile: .txt - 5 columns with channel labels and cartesian
%                   coordinates of channels - NO HEADER FILE
%   * 1 - nr of channel 
%   * 2 - label of channel
%   * 3 - x
%   * 4 - y
%   * 5 - z
%threshold: value used to binarize vector

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

binarizedMatrix = BinarizeMatrixByThreshold(signalMatrix, threshold);

if doPlot == 1
    PlotIntracranealsConnectionsWSMI(electrodes,binarizedMatrix,titleName);
end

completeTitleName = [titleName '(' num2str(threshold) ')'];
shortTitleName = [titleName '(' num2str(threshold) ')'];

%reemplaza a PrintConnections que en este caso no es necesario
%connectionMatrix = PrintConnections(matrixSize,[completeTitleName '_Connections.txt'],shortTitleName);
channels = binarizedMatrix;
variableNameMat = [shortTitleName '.mat'];
text = ['save ' variableNameMat  ' channels'];
eval(text);

connectionMatrix = binarizedMatrix;

PrintNodeFile(electrodeInfoFile,anatomicFile,connectionMatrix,shortTitleName);
PrintEdgeFile(shortTitleName,connectionMatrix);
