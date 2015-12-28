clear,clc
dir='C:\AnalisisEEG\Alzheimer_colombia';
% addpath('/neurospin/local/eeglab');
eeglab,close

grupo = {'MP_ALZ_C','MP_ALZ_P'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};
sujs = {'001','002','003','004','005','006','007','008','009','010'};

INTc{1} = [];
INTc{2} = [];
INTc{3} = [32];
INTc{4} = [];
INTc{5} = [];
INTc{6} = [];
INTc{7} = [24 32 43];
INTc{8} = [];
INTc{9} = [ 32 43];
INTc{10} = [];

INTp{1} = [];
INTp{2} = [43];
INTp{3} = [];
INTp{4} = [];
INTp{5} = [];
INTp{6} = [];
INTp{7} = [];
INTp{8} = [];
INTp{9} = [32];
INTp{10} = [];

for pac = 2 
    if pac ==1, INT = INTc; else INT = INTp;end
    
    sujetos = grupo{pac};
    for i = [2 9 ]
        for cond = 1:3
            if i==1 && cond==1, continue,end
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
            
            try
                EEG = pop_loadcnt(fullfile(dir,'data','cnt',[sujetos,sujs{i},'_',conds1{cond},'.cnt']) , 'dataformat', 'auto', 'memmapfile', '');
                EEG.setname = [sujetos,sujs{i},'_',conds1{cond}];
            catch
                EEG = pop_loadcnt(fullfile(dir,'data','cnt',[sujetos,sujs{i},'_',conds2{cond},'.cnt']) , 'dataformat', 'auto', 'memmapfile', '');
                EEG.setname = [sujetos,sujs{i},'_',conds2{cond}];
            end
            EEG = eeg_checkset( EEG );
            
            if not(EEG.srate==500),
                EEG = pop_resample( EEG, 500);
                EEG = eeg_checkset( EEG );
            end
            % interpola
%             if not(isempty(INT{i}))
%                 EEG = pop_interp(EEG, INT{i}, 'spherical');
%             end
            
            disp('carga posiciones de canales')
            EEG=pop_chanedit(EEG,  'load',{fullfile(dir,'Channel_Locations_64chnsCol.ced'), 'filetype', 'autodetect'});
            EEG = eeg_checkset( EEG );
        
            disp('pasaaltos')
            EEG = pop_eegfilt( EEG, .5, 0, [], 0);
            EEG = eeg_checkset( EEG );
%             disp('pasabajos')
%             EEG = pop_eegfilt( EEG, 0, 90, [], 0);
%             EEG = eeg_checkset( EEG );
            
            EEG = pop_saveset( EEG,  'filename', [sujetos,sujs{i},'_',conds2{cond}], 'filepath', fullfile(dir,'data','set'));
        end
        disp('terminado')
    end
end