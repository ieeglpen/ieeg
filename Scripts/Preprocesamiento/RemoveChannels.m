function RemoveChannels(EEG,channels2Delete,fileName)

%remove bad channels
EEG.data(channels2Delete,:) = [];

size(EEG.chanlocs)
%EEG.chanlocs(channels2Delete,:) = [];

PrintChannelsLabels(EEG,fileName);
