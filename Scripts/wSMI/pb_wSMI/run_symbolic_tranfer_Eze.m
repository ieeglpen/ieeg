clc,clear all,

cfg.kernel = 3; %% kernel , para poner el kernel == 4 hay que corregir PE_paralel!
cfg.chan_sel = 1:60;  %% all channels

cfg.sf = 500; %% sampling frequency
%cfg.taus = [1 2 4 8];
cfg.taus = [1 2 4 8 16 32]; % Ver taus en do_MI_final.m // ultimos dos agregados por mi - Eze

direc = 'C:\AnalisisEEG\Alzheimer_colombia';

grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};


sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 1:2
    sujetos = grupo{pac};
    for i = 1:10
        for cond = 1:3
            if i==1 && cond==1, continue,end
            
            if cond ==1, cfg.data_sel = 1:2500;else cfg.data_sel = 1:1750;end
            
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
            
            load(fullfile(direc,'data','set_epochs_trialandICArejected',[sujetos,sujs{i},'_',conds2{cond},'_ICArejectedCSD.mat']));
            
            [sym ,count ] = S_Transf(data,cfg);
            
            save(fullfile(direc,'Results','ST',[sujetos,sujs{i},'_',conds2{cond},'_CSD.mat']),'sym','count');
        end
    end
end





