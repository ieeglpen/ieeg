function [channels] = PrintConnections(matrixSize,fileName,variableName)
%generates a matrixSize x MatrixSize matrix of connections between
%electrodes, setting to 1 the row,column pair and column,row pair of
%channels indicated in fileName.txt and saves it to a variableName.mat file- 

data = importdata(fileName);
 
channels = zeros(matrixSize,matrixSize);

if ~isempty(data)
    nr = size(data.data,1);
    for i = 1 : nr        
        chanConnection = data.data(i,:);
        channels(chanConnection(1,1),chanConnection(1,2)) = 1;
        channels(chanConnection(1,2),chanConnection(1,1)) = 1;
    end
end

variableNameMat = [variableName '.mat'];

text = ['save ' variableNameMat  ' channels'];

eval(text);
