clear,clc,close all

direc = 'C:\AnalisisEEG\Alzheimer_colombia';

grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};
load(fullfile(direc,'\scripts\chanlocs.mat'))

M = nan(2,10,3,60,60);

sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 1:2 
    sujetos = grupo{pac};
    for s = 1:10
        s
        for cond = 1 
 
            if s==1 && cond==1, continue,end
            
            load(fullfile(direc,'Results','ST',[sujetos,sujs{s},'_',conds2{cond},'_CSD.mat']));

            H(s,:) = mean(-squeeze(sum(count{4}.*log(count{4}),2)),2);

        end 
    end
    H = mean(H,1);
    
%     if pac ==1, 
        LIM = [1.2 1.4]; 
    figure
    topoplot(H,chanlocs,'plotrad',0.6,'maplimits',LIM,'colormap',colormap('jet'),'whitebk', 'on', 'numcontour',0);
    h=gcf;
    set(h,'Color','w')
    colorbar
%     set(gcf,'Position',[42   422   382   252]);
end

%%


