function GetConditionsFromFilteredData(fileName,filePath,data,srate,epochWindow,baseWindow,newFileName)
%saves structure epochs in epochedData.mat that contains epochs.int and
%epochs.acc with both conditions
%INPUTS: 
%fileName - .set file name
%filePath - path to .set file
%data - signal to be epoched
%epochWindow - a 1x2 vector of the trial window [startEpoch endEpoch] in
%SECONDS
%baseWindow - a 1x2 vector of base window used to reference data [startBase
%endBase] in MILISECONDS

%----- CONDITION: INT ----------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',fileName,'filepath',filePath);
                                                                            
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
size(data)
EEG.data = data;
EEG.srate = srate;
eeglab redraw
epochWindow(1,1)
epochWindow(1,2)
EEG = pop_epoch( EEG, {  'int'  }, [epochWindow(1,1)         epochWindow(1,2)], 'newname', 'EDF file epochs', 'epochinfo', 'yes');

EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [baseWindow(1,1)    baseWindow(1,2)]);
EEG = eeg_checkset( EEG );

epochs_int=EEG.data;

%----- CONDITION: ACC ----------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',fileName,'filepath',filePath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

EEG.data = data;
EEG.srate = srate;
eeglab redraw

EEG = pop_epoch( EEG, {  'acc'  }, [epochWindow(1,1)         epochWindow(1,2)], 'newname', 'EDF file epochs', 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [baseWindow(1,1)    baseWindow(1,2)]);
EEG = eeg_checkset( EEG );

epochs_acc=EEG.data;

%----- CONDITION: NEU ----------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',fileName,'filepath',filePath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

EEG.data = data;
EEG.srate = srate;
eeglab redraw

EEG = pop_epoch( EEG, {  'neu'  }, [epochWindow(1,1)         epochWindow(1,2)], 'newname', 'EDF file epochs', 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [baseWindow(1,1)    baseWindow(1,2)]);
EEG = eeg_checkset( EEG );

epochs_neu=EEG.data;

epochs.int = epochs_int;
epochs.acc = epochs_acc;
epochs.neu = epochs_neu;

evalStr = ['save ' newFileName '.mat epochs'];
eval(evalStr);
