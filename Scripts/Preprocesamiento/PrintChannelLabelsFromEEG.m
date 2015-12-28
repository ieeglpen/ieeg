function channelList = PrintChannelLabelsFromEEG(fileName,filePath,outputFileName)

eeglab

EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );

channelList = PrintChannelsLabels(EEG,outputFileName);