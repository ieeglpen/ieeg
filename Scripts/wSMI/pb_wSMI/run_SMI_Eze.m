clear,clc

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
            if i==1 && cond==1, continue,end %preguntar!! Es porque no hay datos de rest de ese sujeto?
            
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(i),' cond ',num2str(cond)])
    
            file = fullfile(direc,'Results','ST',[sujetos,sujs{i},'_',conds2{cond},'_CSD.mat']);
            fileout= fullfile(direc,'Results','SMI',[sujetos,sujs{i},'_',conds2{cond},'_CSD.mat']);
            do_MI_final(file,fileout);
        end
    end
end

