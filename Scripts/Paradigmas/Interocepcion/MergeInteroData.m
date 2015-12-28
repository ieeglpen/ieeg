function MergeInteroData(filename1,filename2,mergedFileName,filepath,event2Epoch,epochWindow,doRebase,rebaseWindow)
%es necesario tener el eeglab en el path para poder llamar esta funcion
%cargo la primera señal
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',filename1,'filepath',filepath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
firstSet = CURRENTSET;

%cargo la segunda señal
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_loadset('filename',filename2,'filepath',filepath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
secondSet = CURRENTSET;

%hago el merge de los datasets
EEG = pop_mergeset( ALLEEG, [1  2], 0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EEG = eeg_checkset( EEG );

%extraigo los epochs
EEG = pop_epoch( EEG, {  event2Epoch  }, [epochWindow(1)         epochWindow(2)], 'newname', 'Merged datasets epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off'); 
EEG = eeg_checkset( EEG );

if doRebase == 1
    EEG = pop_rmbase( EEG, [rebaseWindow(1)             rebaseWindow(2)]);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
end

%verifico que la cantidad de epochs sea igual a la suma de epochs por
%separado (en caso de no cumplirse se agregó un epoch en la union de los
%dataset que debe ser eliminado)
[totalEpochNR epochNRfirstSet epochNRsecondSet] = CalculateTotalEpochNrFrom2DataSets(EEG,ALLEEG,CURRENTSET,firstSet,secondSet,filepath,event2Epoch,epochWindow);

if totalEpochNR ~= size(EEG.data,3)
    %debo eliminar el epoch ficticio que se genera en la unión de los
    %datasets
    epoch2remove = epochNRfirstSet + 1;
    EEG = pop_rejepoch( EEG, epoch2remove,0);
end

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'savenew',mergedFileName,'gui','off');

epochs = EEG.data;

evalStr = ['save ' mergedFileName 'EpochedData.mat epochs'];
eval(evalStr)