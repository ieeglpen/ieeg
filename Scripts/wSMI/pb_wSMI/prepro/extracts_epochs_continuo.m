clear,clc
dir='C:\AnalisisEEG\Alzheimer_colombia';
% addpath('/neurospin/local/eeglab');eeglab,close

grupo = {'MP_ALZ_C','MP_ALZ_P'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};
sujs = {'001','002','003','004','005','006','007','008','009','010'};
cond =1;

L_EPOCH = 5;

for pac =  2
    sujetos = grupo{pac};
    for i = [2 9 ]
        if i==1 && cond==1, continue,end
        disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
        EEG = pop_loadset('filename',[sujetos,sujs{i},'_',conds2{cond},'.set'],'filepath',fullfile(dir,'data','set'));
        EEG = eeg_checkset( EEG );
        EEG = eeg_checkset( EEG );
        
        largo = size(EEG.data,2);
        EEG.event = [];
        cont =0;
        for l =1:EEG.srate*L_EPOCH:largo
            cont = cont+1;
            EEG.event(cont).type = 'trial';
            EEG.event(cont).latency = l;
        end
        EEG = pop_epoch( EEG, {  'trial'  }, [0  L_EPOCH], 'newname', [sujetos,sujs{i},'_',conds2{cond},'_epoched'], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        
        filepath = fullfile(dir,'data','set_epochs');
        EEG = pop_saveset( EEG,  'filename', [sujetos,sujs{i},'_',conds2{cond},'_epoched.set'],'filepath',filepath);
    end
end    
