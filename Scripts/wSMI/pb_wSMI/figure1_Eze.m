clear,clc,close all

color1 = [1 0 0];
color2 = [0 0 1];

direc = 'C:\AnalisisEEG\Alzheimer_colombia';
load(fullfile(direc,'\scripts\chanlocs.mat'))

grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','SS2','SS3'};

M = nan(2,10,3,60,60);

sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 1:2
    sujetos = grupo{pac};
    for s = 1:10
        s
        for cond = 2
            if s==1 && cond==1, continue,end
            
            fileout= fullfile(direc,'Results','SMI',[sujetos,sujs{s},'_',conds2{cond},'_CSD.mat']);
            
            load(fileout)
            aux = wSMI.MEAN{1}; 
            n = 0;
            for i = 1:60
                for j = (i+1):60
                    n = n+1;
                    aux2(i,j) = aux(n);
                    aux2(j,i) = aux(n);
                end
            end
            M(pac,s,cond,:,:) = aux2;
        end
    end
end
%%
G = {'b','r'};
close all
for pac =1:1
    for cond=2
        cond = squeeze(nanmean(M(pac,:,cond,:,:)));
        figure
        imagesc(cond),axis square, axis off,colormap(hot)
        caxis([0 .02 ])
        format_figure(gcf)
        set_figure_size(10)
%         cd /home/pbarttfe/Desktop/figuras_alzheimer
%         print('-depsc', '-tiff', '-painters', '-r600', ['matriz',num2str(pac)])
        
        figure(1123),hold on
        plot(mean(cond),G{pac})
        figure
        topoplot(mean(cond),chanlocs,'plotrad',0.6,'maplimits',[0.001 .02],...
            'colormap',colormap('hot'),'whitebk', 'on', 'numcontour',0);
        h=gcf;
        set(h,'Color','w')
        colorbar
%         format_figure(gcf)
%         set_figure_size(10)
%         cd /home/pbarttfe/Desktop/figuras_alzheimer
%         print('-depsc', '-tiff', '-painters', '-r600', ['topo',num2str(pac)])
        
    end
end

%%
cond = 2;

con = squeeze(M(1,:,cond,:,:));
alz = squeeze(M(2,:,cond,:,:));

con = reshape(con,size(con,1),size(con,2)*size(con,3));
alz = reshape(alz,size(alz,1),size(alz,2)*size(alz,3));

[H,P,CI,STATS] = ttest2(con,alz);
T = reshape(STATS.tstat,60,60);
P = reshape(P,60,60);
figure(55),imagesc(T)
axis square
colorbar

format_figure(gcf)
set_figure_size(10)
% cd /home/pbarttfe/Desktop/figuras_alzheimer
% print('-depsc', '-tiff', '-painters', '-r600', 'T')
%%

Tmax = 1; Tmin = -Tmax;
figure
draw_links_scalp(T .* (P<.05) ,Tmax,Tmin,color1,color2)
format_figure(gcf)
set_figure_size(10)
% xlim([-1 1])
% ylim([-0.7 0.7])
% cd /home/pbarttfe/Desktop/figuras_alzheimer
% print('-depsc', '-tiff', '-painters', '-r600', 'links')

