function PrintElectrodeLocalization(electrodes,titleName)

%prints to a .txt the list the coordinates of each electrode in electrodes
%INPUT:
%electrodes: structure with two vectors
%           * coordinates: Nx3 array, N electrodes/channels, 3 -> cartesian
%               coordinates
%           * labels: cell array of N electrodes/channels labels
%titleName: name of file (OUTPUT)
%OUTPUT:
%titleName.txt: file containing N rows (nr of electrodes/channels)and 5 columns:
%           * nr
%           * label
%           * x
%           * y
%           * z

channelNr = size(electrodes.coordinates,1);

fileID = fopen([titleName '_ElectrodeLocalisation.txt'],'w');
%formatSpec = '%d %s %f %f %f %f %s\r\n';
%formatSpec = '%d %s %d %d %d %d %s\r\n';
formatSpec = '%s\r\n';

for i = 1 : channelNr
    %fprintf(fileID,formatSpec,i,electrodes.labels{i},electrodes.coordinates(i,1),electrodes.coordinates(i,2),electrodes.coordinates(i,3),'');
    text2Print = [num2str(i) ' ' electrodes.labels{i} ' ' num2str(electrodes.coordinates(i,1)) ' ' num2str(electrodes.coordinates(i,2)) ' ' num2str(electrodes.coordinates(i,3))];
    fprintf(fileID,formatSpec,text2Print);
end

fclose(fileID);
