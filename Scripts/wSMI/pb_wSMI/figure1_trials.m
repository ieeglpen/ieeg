clear,clc,close all
color1 = [1 0 0];
color2 = [0 0 1];

cd /media/'My Passport'/eeg'/Alzheimer_colombia'/scripts'/prepro'/
epochsadescartar

direc = '/media/My Passport/eeg/Alzheimer_colombia';

grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','ss2','ss3'};

cd(fullfile(direc,'data','dat'))

load Comportamiento
sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 1:2
    contsuj = 0;
    sujetos = grupo{pac};
    for suj = 1:10
        if suj ==9, continue,end % alz 9 tiene menos trials, ver!
        contsuj = contsuj +1;
        
        for cond =  3
            fileout= fullfile(direc,'Results','SMI',[sujetos,sujs{suj},'_',conds1{cond},'_CSD.mat']);
            
            load(fileout); aux = wSMI.Trials{2};
            
            epochs = eval([G{pac},num2str(suj),'ss',num2str(cond)]);
            
            temp = size(aux,2) + length(epochs);
            if not(temp ==100 | temp ==200),error,end
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(suj),' cond ',num2str(cond)])
            
            Trial       = COMP.pac(pac).suj(suj).cond(cond).Trial;      Trial(epochs)=[];
            Condition   = COMP.pac(pac).suj(suj).cond(cond).Condition;  Condition(epochs)=[];
            Correct     = COMP.pac(pac).suj(suj).cond(cond).Correct;    Correct(epochs)=[];
   
%             if not(length(Trial) ==temp),error,end
            aux2 = nan(60);
            C1 = [];C2 =[];
            for tr =1:size(aux,2)
                
                TEMP = aux(:,tr);
                n = 0;
                for i = 1:60
                    for j = (i+1):60;
                        n = n + 1;
                        aux2(i,j) = TEMP(n);
                        aux2(j,i) = TEMP(n);
                    end
                end
                if Condition(tr) ==1
                    C1 = cat(3,C1,aux2);
                else
                    C2 = cat(3,C2,aux2);
                end
            end
            M(pac,contsuj).C1 = C1;
            M(pac,contsuj).C2 = C2;
        end
    end
end

%%
C_1 = [];
C_2 = [];
P_1 = [];
P_2 = [];

for suj=1:size(M,2)
        temp = M(1,suj).C1;    % controles cond 1   
        C_1 = [C_1,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
        
        temp = M(1,suj).C2;    % controles cond 2   
        C_2 = [C_2,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];

        temp = M(2,suj).C1;    % pacientes cond 1   
        P_1 = [P_1,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];

        temp = M(2,suj).C2;    % pacientes cond 2   
        P_2 = [P_2,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
end


C_1(isnan(C_1)) =0;
C_2(isnan(C_2)) =0;
P_1(isnan(P_1)) =0;
P_2(isnan(P_2)) =0;

%%
close all
cd /home/pbarttfe/Bureau/figuras/
cond = 1;

c = eval(['C_' num2str(cond)]);
p = eval(['P_' num2str(cond)]);


[H,P,CI,STATS] = ttest2(c',p' ); % rojo grande 2
T = reshape(STATS.tstat,60,60);
P = reshape(P,60,60);
h = figure,imagesc(T)
caxis([-10 10])
axis square
colorbar

format_figure(gcf)
set_figure_size(14)
saveas(h, ['matriz_condicion' num2str(cond)],'png')


figure, hist(T(:),100)
box off



Tmax = 5 ; Tmin = -Tmax;
h= figure
draw_links_scalp(T ,Tmax,Tmin,color1,color2)

format_figure(gcf)
set_figure_size(14)
saveas(h, ['scalp_condicion' num2str(cond)],'png')

%%
a= mean(C_2,2) - mean(C_1,2);
b= mean(P_2,2) - mean(P_1,2);


c = a-b;
c = reshape(c,60,60);
h= figure,imagesc(c)
caxis([-.002 .002])
axis square
colorbar
format_figure(gcf)
set_figure_size(14)
saveas(h, ['interaccion' ],'png')


figure, hist(c(:),100)
box off
Tmax = .0015; Tmin = -Tmax ;
figure
draw_links_scalp(c,Tmax,Tmin,color2,color1)
 