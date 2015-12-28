function Preprocess(fileName,filePath,labelFileName,channels2Delete,notchHz,notchWidth,bandpassRange,filteredFileName,referencedFileName)

%preprocesses fileName.set at filePath -> e.g. 'C:\\Documents\\Sets\\'
%this includes opening eeglab to load the .set
%prints a file labelFileName__ChannelLabels.txt
%removes channels included in channels2Delete (for being noisy, for not being relevant, etc...
%prints a file labelFileName__PreprocessedChannelLabels.txt without the
%deleted channels of the previous step
%Notch Filter at each notchHz in array with a width of notchWidth
%Band-pass filter -> bandpassRange = [min max]
%re-referencing to the mean average of the signal

eeglab

EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );

%print channel labels
PrintChannelsLabels(EEG,labelFileName);

%remove bad channels
EEG.data(channels2Delete,:) = [];
EEG.chanlocs(channels2Delete,:) = [];

eeglab redraw

%print channel labels
PrintChannelsLabels(EEG,[labelFileName '_Preprocessed']);

%plot power spectrum one channel pre-Notch filtering 
PlotPowerSpectrum(EEG.data(1,:),EEG.srate,'Signal without Notch filtering')

%Notch filter
for i = 1 : size(notchHz,2)
    EEG.data = NotchFilter(EEG, notchHz(1,i),notchWidth);
end

%Band-pass filtering
%EEG = pop_iirfilt( EEG, bandpassRange(1,1), bandpassRange(1,2), [], [1]);
EEG = pop_eegfilt( EEG, bandpassRange(1,1), bandpassRange(1,2), [], [0], 0, 0, 'fir1', 0);
eeglab redraw
PlotPowerSpectrum(EEG.data(1,:),EEG.srate,'Band-pass filtered Signal')

filteredData = EEG.data;
%save 'filteredData.mat' filteredData
evalStr = ['save ' filteredFileName '.mat filteredData'];
eval(evalStr);

%referencia a la media
avg = mean(filteredData,1);
avgMatrix = repmat(avg,size(filteredData,1),1);
data = filteredData - avgMatrix;

%save 'data.mat' data;
evalStr = ['save ' referencedFileName '.mat data'];
eval(evalStr);
