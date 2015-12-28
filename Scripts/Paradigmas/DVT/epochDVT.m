function epochDVT(fileName,filePath, data, type, epoch_window, base_window,file2save)

eeglab

EEG = pop_loadset('filename',fileName,'filepath',filePath);
%[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

EEG.data = data;

EEG = pop_epoch( EEG,     type   , epoch_window, 'newname', '', 'epochinfo', 'yes');
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );

display('size data')
size(EEG.data)

if epoch_window(1) ~= 0
    display('Baseline Removal')
    EEG = pop_rmbase( EEG, base_window);
end

data = EEG.data;
str = ['save ' file2save '.mat data;']
eval(str)