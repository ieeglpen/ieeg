function [ResultMatrix Pmask] = PlotTTestforWSMIOriginal(condition1,condition2,tau,fileName,channelNr,path,newFileName,labels,p_value,Tmax,Tmin)

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

M.C1 = C1;
M.C2 = C2;

C_1 = [];
C_2 = [];

for suj=1:size(M,2)
        temp = M(1,suj).C1;    % condicion 1
        C_1 = [C_1,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
        
        temp = M(1,suj).C2;    % condicion 2
        C_2 = [C_2,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];        
end

C_1(isnan(C_1)) = 0;
C_2(isnan(C_2)) = 0;

[H,P,CI,STATS] = ttest2(C_1',C_2' ); 

T = reshape(STATS.tstat,matrixSize,matrixSize);
P = reshape(P,matrixSize,matrixSize);

Pmask = P;
Pmask(Pmask>p_value)=0;

T_signif = P;
T_signif(P>p_value)=0; 
T_signif(P<=p_value)=1; 

Tmask = T;
Tmask(Tmask>Tmin&Tmask<Tmax)=0;

signifMask = Tmask.*T_signif;
signifVals = T.*T_signif;
ResultMatrix = signifMask;

caxisValues = [Tmin Tmax];
PfileName = [newFileName '_Tsignificancemask'];
%PlotMap(signifMask,labels,caxisValues,PfileName); 
PlotFormattedMap(signifMask,labels,caxisValues,'jet',PfileName,PfileName,1); 

caxisValues = [Tmin Tmax];
PfileName = [newFileName '_TsignificancemaskCOMPLETE'];
%PlotMap(signifMask,labels,caxisValues,PfileName); 
PlotFormattedMap(signifVals,labels,caxisValues,'jet',PfileName,PfileName,1); 

%plot histogram of significant values
signifValsT = T.*T_signif;
signifVals = signifValsT(signifValsT ~= 0);
figure, hist(signifVals,100);
title([newFileName 'Signif'])

%plot histogram
figure, hist(T(:),100);
box off
name = [newFileName '_histogram'];

title(newFileName)

saveas(gcf,name,'png');
saveas(gcf,name,'fig');