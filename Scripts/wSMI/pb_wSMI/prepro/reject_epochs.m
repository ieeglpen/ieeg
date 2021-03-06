clear,clc
dir='C:\AnalisisEEG\Alzheimer_colombia';
% addpath('/neurospin/local/eeglab');eeglab,close
epochsadescartar
grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};


sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 2
    sujetos = grupo{pac};
    for i = [ 2 9 ]
        for cond = 1:3
            if i==1 && cond==1, continue,end
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
            
            EEG = pop_loadset('filename',[sujetos,sujs{i},'_',conds2{cond},'_epoched.set'],'filepath',fullfile(dir,'data','set_epochs'));
            EEG = eeg_checkset( EEG );

            epochs = eval([G{pac},num2str(i),'ss',num2str(cond)]);
            if not(isempty(epochs))
                EE= zeros(1,size(EEG.data,3));
                EE(epochs)= 1;
                EEG = pop_rejepoch( EEG, epochs,0);
                EEG = eeg_checkset( EEG );
            end
            EEG = pop_saveset( EEG,  'filename',[sujetos,sujs{i},'_',conds2{cond},'_epoched_trialrejected'] , 'filepath', fullfile(dir,'data','set_epochs_trialrejected'));
        end
    end
end