function correica()
dir='/media/discoex/eeg/Alzheimer_colombia';
% addpath('/neurospin/local/eeglab');eeglab,close

cd(dir)
ica_channelstoremove

grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};

% matlabpool(3)
sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 1:2
    sujetos = grupo{pac};
    for i = 1:10
        for cond = 1:3
            if i==1 && cond==1, continue,end
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
            
            EEG = pop_loadset('filename',[sujetos,sujs{i},'_',conds2{cond},'.set'],'filepath',fullfile(dir,'data','set_epochs_trialrejected'));
            EEG = eeg_checkset( EEG );

            IC = eval([G{pac},num2str(i),'ss',num2str(cond)]);

            EEG = pop_subcomp( EEG, IC, 0);
            EEG = eeg_checkset( EEG );

%             EEG = pop_saveset( EEG, 'filename',[sujetos,sujs{i},'_',conds2{cond},'_ICArejected.set'],...
%                 'filepath',fullfile(dir,'data','set_epochs_trialandICArejected/'));
            cd(fullfile(dir,'data','set_epochs_trialandICArejected/'))
            data = EEG.data([1:32 34:42 44:59 61:63],:,:);
            save([sujetos,sujs{i},'_',conds2{cond},'_ICArejected.mat'],'data');    
        end
    end
end
