clear,clc
dir='C:\AnalisisEEG\Alzheimer_colombia';
% addpath('/neurospin/local/eeglab');
eeglab,close

grupo = {'MP_ALZ_C','MP_ALZ_P'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};
sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 2
    sujetos = grupo{pac};
    for i = [2 9 ]
        for cond = 2:3
            if i==1 && cond==1, continue,end
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
            
            EEG = pop_loadset('filename',[sujetos,sujs{i},'_',conds2{cond},'.set'],'filepath',fullfile(dir,'data','set'));
            EEG = eeg_checkset( EEG );
            EEG = eeg_checkset( EEG );
            EEG = pop_epoch( EEG, {  '11'  '21'  }, [-.5  3], 'newname', [sujetos,sujs{i},'_',conds2{cond},'_epoched'], 'epochinfo', 'yes');
            EEG = eeg_checkset( EEG );
            EEG = pop_rmbase( EEG, [-500     0]);
            EEG = eeg_checkset( EEG );
            
            EEG = pop_saveset( EEG,  'filename',[sujetos,sujs{i},'_',conds2{cond},'_epoched'] , 'filepath', fullfile(dir,'data','set_epochs'));
        end
        disp('terminado')
    end
end