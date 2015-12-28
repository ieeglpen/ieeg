function PrintNodeFile(preprocessedElectrodeFile,anatomicFile,connectionMatrix,fileName2Save,nodeSpecStruct,mode)
% preprocessedElectrodeFile: .txt - 6 columns with channel labels and cartesian
%                   coordinates of channels - NO HEADER FILE
%   * 1 - nr of channel 
%   * 2 - label of channel
%   * 3 - x
%   * 4 - y
%   * 5 - z
%   * 6 - neuroanatomic area

%nodeSpecStruct: contains the info relative to size, color, etc... relative
%to the mode selected
%mode:  connectionNr -> size of node is proportional to connectionNr
%       condition -> size of node depends on condition, color of default
%       value is determined
%import data of .txt - loads textdata (N x 1) with labels and coordinate data (N x 3)
elecs = importdata(preprocessedElectrodeFile);

matrixSize = size(elecs.data,1);
connectionMatrixSize = size(connectionMatrix,1);

if matrixSize ~= connectionMatrixSize
    throw('Exception matrices indices do not coincide.')
end

%create electrodes structure
x = elecs.data(:,1);
y = elecs.data(:,2);
z = elecs.data(:,3);

%ch_label = elecs.textdata(:,2);
anatomicData =  importdata(anatomicFile);
neuroanatomicarea = anatomicData;

connections = sum(connectionMatrix)';

% electrodes.x = x;
% electrodes.y = y;
% electrodes.z = z;
%electrodes.labels = ch_label;
%electrodes.color = CreateColorValuesOfNeuroAnatomicRegions(neuroanatomicarea);
color = CreateColorValuesOfNeuroAnatomicRegions(neuroanatomicarea);
display('color')
size(color)
display('neuroanatomicarea')
size(neuroanatomicarea)

%electrodes.connections = connections;
%electrodes.neuroanatomicarea = neuroanatomicarea;

fileID = fopen([fileName2Save '.node'],'w');
formatSpec = '%s\r\n';
%formatSpec = '%.1f\t%.1f\t%.1f\t%d\t%d\t%s\r\n';  

for i = 1 : matrixSize
    %fprintf(fileID,formatSpec,i,electrodes.labels{i},electrodes.coordinates(i,1),electrodes.coordinates(i,2),electrodes.coordinates(i,3),'');    
    
    color2print= '';
    size2print = '';

    switch(mode)
        case 'connectionNr' 
            color2print = num2str(color(i));
            size2print = num2str(connections(i));
        case 'condition'
            defaultIndex = 0;
            otherIndex = 0;
            if connections(i) == 0
                defaultIndex = structfind(nodeSpecStruct,'condition','default');
                color2print = nodeSpecStruct(defaultIndex).color;
                size2print = nodeSpecStruct(defaultIndex).size;
            else
                color2print = num2str(color(i));
                otherIndex = structfind(nodeSpecStruct,'condition','other');
                size2print = nodeSpecStruct(otherIndex).size;
            end            
        otherwise
            color2print = -1;
            size2print = -1;
    end
    %text2Print = [num2str(x(i)) ' ' num2str(y(i)) ' ' num2str(z(i)) ' ' num2str(color(i)) ' ' num2str(connections(i)) ' ' neuroanatomicarea{i} ];

    text2Print = [num2str(x(i)) ' ' num2str(y(i)) ' ' num2str(z(i)) ' ' color2print ' ' size2print ' ' neuroanatomicarea{i} ];
    fprintf(fileID,formatSpec,text2Print);
    
    %fprintf(fileID,formatSpec,electrodes(i).x,electrodes(i).y,electrodes(i).z,electrodes(i).color,electrodes(i).connections,electrodes(i).neuroanatomicarea);
    %fprintf(fileID,formatSpec,x(i),y(i),z(i),color(i),connections(i),neuroanatomicarea(i));
end

fclose(fileID);
