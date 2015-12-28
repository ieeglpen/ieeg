function correica()
dir='/media/discoex/eeg/Alzheimer_colombia';
% addpath('/neurospin/local/eeglab');eeglab,close
epochsadescartar
grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};

% matlabpool(3)
sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 2
    sujetos = grupo{pac};
    for i = [2 9 ]
        for cond = 1:3
            if i==1 && cond==1, continue,end
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
            
             corre([sujetos,sujs{i},'_',conds2{cond}],...
                 fullfile(dir,'data','set_epochs_trialrejected')...
                 );
        end
    end
end

end

function corre(file,dir)

EEG = pop_loadset('filename',[file '_epoched_trialrejected.set'],'filepath',dir);
EEG = eeg_checkset( EEG );

if isempty(EEG.icaweights)
    EEG = pop_runica(EEG, 'icatype', 'runica', 'dataset',1, 'options',{ 'extended',1, 'pca',50});
    EEG = pop_saveset( EEG, 'filename',file,'filepath',dir);
end
end