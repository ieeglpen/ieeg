function LoadAndEpochData(filename,filepath,newfilename,labelFileName,channels2Delete,notchHz,notchWidth,bandpassRange,filteredFileName,referencedFileName,epochEvent,epochWindow,doRebase,rebaseWindow)

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',filename,'filepath',filepath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );

%Preprocess                                  
[newEEG] = PreprocessFromEEGlab(EEG,labelFileName,channels2Delete,notchHz,notchWidth,bandpassRange,filteredFileName,referencedFileName);
EEG = newEEG;

EEG = pop_epoch( EEG, {  epochEvent  }, [epochWindow(1)         epochWindow(2)], 'newname', 'bloque1 epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );

if doRebase
    EEG = pop_rmbase( EEG, [rebaseWindow(1)             rebaseWindow(2)]);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
end

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'savenew',newfilename,'gui','off');

epochs = EEG.data;
evalStr = ['save ' newfilename 'EpochedData.mat epochs'];
eval(evalStr)