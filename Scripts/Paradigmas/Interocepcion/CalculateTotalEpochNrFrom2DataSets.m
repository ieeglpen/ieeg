function [totalEpochNR epochNRfirstSet epochNRsecondSet] = CalculateTotalEpochNrFrom2DataSets(EEG,ALLEEG,CURRENTSET,dataset1,dataset2,filepath,event2Epoch,epochWindow)
display('IN CalculateTotalEpochNrFrom....')
%cargo el primer dataset
CURRENTSET
dataset1
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',dataset1,'study',0); 
EEG = eeg_checkset( EEG );

display('111111')
size(EEG.event)
size(EEG.data)
EEG = pop_epoch( EEG, {  event2Epoch  }, [epochWindow(1)         epochWindow(2)], 'newname', 'Merged datasets epochs', 'epochinfo', 'yes');

size(EEG.event)
size(EEG.data)
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off'); 
EEG = eeg_checkset( EEG );
eeglab redraw
pause(6)
display('22222')
%calculo la cantidad de epochs del primer dataset
epochNRfirstSet = size(EEG.data,3)

%cargo el segundo dataset
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',dataset2,'study',0); 

EEG = pop_epoch( EEG, {  event2Epoch  }, [epochWindow(1)         epochWindow(2)], 'newname', 'Merged datasets epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off'); 
EEG = eeg_checkset( EEG );
eeglab redraw
%calculo la cantidad de epochs del segundo dataset
epochNRsecondSet = size(EEG.data,3)

%calculo la cantidad total de epochs
totalEpochNR = epochNRfirstSet + epochNRsecondSet

display('OUT CalculateTotalEpochNrFrom....')