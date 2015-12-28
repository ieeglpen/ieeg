function electrodeList = PreprocessChannelLocation(fileName,bad_chans,titleName)

electrodes = importdata(fileName);
size(electrodes.data)

electrodes.data(bad_chans,:)=[];
electrodes.textdata(bad_chans) = [];

coordinates = electrodes.data;
electrodeList = electrodes.textdata;

newElectrodes.coordinates = coordinates;
newElectrodes.labels = electrodeList;

PrintElectrodeLocalization(newElectrodes,titleName);


