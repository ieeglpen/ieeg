clear

direc = '/media/My Passport/eeg/Alzheimer_colombia';

grupo = {'MP_ALZ_C','MP_ALZ_P'};
G = {'c','p'};
conds1 = {'REP','SS2','SS3'};
conds2 = {'EEG','ss2','ss3'};

cd(fullfile(direc,'data','dat'))


sujs = {'001','002','003','004','005','006','007','008','009','010'};
for pac = 1:2 
    sujetos = grupo{pac};
    for suj = 1:10
        for cond = 2:3
           
            disp(['leyendo sujeto ', grupo{pac}(4:end),' sujeto ', num2str(suj),' cond ',num2str(cond)])

            fid = fopen(['MP_' grupo{pac}(4:end) sujs{suj},'-',conds2{cond},'.dat'],'r');
            M = [];cont =0;
            while 1
                tline = fgetl(fid); 
                cont = cont +1;
                if ~ischar(tline), 
                    break,
                else
                    tline(1) =[];tline(end) =[];
                    C = strsplit(tline,' ');
                end
                if cont >1
                    temp = [];
                    for i= [1 2 3 6 7 8 9 ],temp  = [temp str2num(C{i})];,end
                    M = [M; temp];
                end
            end
            fclose(fid);
            COMP.pac(pac).suj(suj).cond(cond).Trial         = M(:,1);
            COMP.pac(pac).suj(suj).cond(cond).Interval      = M(:,2);
            COMP.pac(pac).suj(suj).cond(cond).Condition     = M(:,3);
            COMP.pac(pac).suj(suj).cond(cond).ExpecResp     = M(:,4);
            COMP.pac(pac).suj(suj).cond(cond).Correct       = M(:,5);
            COMP.pac(pac).suj(suj).cond(cond).RT            = M(:,6);
            COMP.pac(pac).suj(suj).cond(cond).StudyOnset    = M(:,7);
        end
    end
end

  save(['Comportamiento.mat'],'COMP')
          
