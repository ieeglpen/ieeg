function [C1, C2] = LoadwSMIConnectivityMatrixFor2Conditions(path,fileName,condition1,condition2,tau,channelNr)

direc = path;

cond = {condition1,condition2};
C1 = [];C2 =[];

for c = 1:2
    fileout= fullfile(direc,'Results','SMI',[fileName,'_',cond{c},'_CSD.mat']);
    load(fileout); 
        
    wSMI4Tau = wSMI.Trials{tau};
    matrixSize = channelNr;
    tempResultMatrix = nan(matrixSize);
    
    for tr =1:size(wSMI4Tau,2)
        wSMI4TauByTrial = wSMI4Tau(:,tr);       
        n = 0;
        for i = 1:matrixSize 
            for j = (i+1):matrixSize;
                n = n + 1;
                tempResultMatrix(i,j) = wSMI4TauByTrial(n);
                tempResultMatrix(j,i) = wSMI4TauByTrial(n);
            end
        end
        if c == 1
            C1 = cat(3,C1,tempResultMatrix);
        else
            C2 = cat(3,C2,tempResultMatrix);
        end
    end
end

C1(isnan(C1)) = 0;
C2(isnan(C2)) = 0;