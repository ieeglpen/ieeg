function [channels2Discard prechannels2Discard jumps nr_jumps]  = GetChannels2DiscardFromEEG(filePath,fileName)

eeglab

EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );

[channels2Discard prechannels2Discard jumps nr_jumps]  = GetChannelsToDiscard(EEG.data,true);