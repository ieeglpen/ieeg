function [EEG] = PreprocessFromEEGlab(EEG,labelFileName,channels2Delete,notchHz,notchWidth,bandpassRange,filteredFileName,referencedFileName)

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

EEG.data = data;

%save 'data.mat' data;
evalStr = ['save ' referencedFileName '.mat data'];
eval(evalStr);
