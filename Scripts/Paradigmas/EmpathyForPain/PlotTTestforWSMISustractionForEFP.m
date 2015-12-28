function [ResultMatrix Pmask] = PlotTTestforWSMISustractionForEFP(condition1,condition2,condition3,tau,fileName,channelNr,path,newFileName,labels,p_value,Tmax,Tmin)

direc = path;

cond = {condition1,condition2,condition3};
C1 = [];C2 =[]; C3 = []; 

for c = 1:size(cond,2)
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
        elseif c == 2
            C2 = cat(3,C2,tempResultMatrix);            
        else
            C3 = cat(3,C3,tempResultMatrix);
        end
    end
end

M.C1 = C1;
display('C1')
size(M.C1)
M.C2 = C2;
display('C2')
size(M.C2)

M.C3 = C3;
display('C3')
size(M.C3)

C1xs = [];
C2xs = [];
C341xs = [];
C342xs = [];

temp = M.C1;   
C1xs = [C1xs,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
display('C1xs')
size(C1xs)

temp = M.C2;   
C2xs = [C2xs,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
display('C2xs')
size(C2xs)

%temp = M.C3;   
meanC3 = mean(M.C3,3);
temp = repmat(meanC3,[1 1 size(M.C1,3)]);
display('temp 341')
size(temp)
C341xs = [C341xs,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
display('C341xs')
size(C341xs)

temp = repmat(meanC3,[1 1 size(M.C2,3)]);
C342xs = [C342xs,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
display('C342xs')
size(C342xs)

% C_1(isnan(C_1)) = 0;
% C_2(isnan(C_2)) = 0;

C1xs(isnan(C1xs)) =0;
C2xs(isnan(C2xs)) =0;
C341xs(isnan(C341xs)) =0;
C342xs(isnan(C342xs)) =0;

a = C1xs - C341xs; 
b = C2xs - C342xs;

%MODIFY?
% connectivity matrix condition1
% mean_ShO_con=mean(M.C1, 3);
% means=figure, imagesc(mean_ShO_con);
% 
% set(gca,'FontSize',8)
% 
% set(gca,'YTick',[1:size(labels,1)] );
% set(gca,'YTickLabel',labels);      
% 
% set(gca,'XTick',[1:size(labels,1)] );
% set(gca,'XTickLabel',labels);   
% 
% titlename = [newFileName '-' condition1];
% title(titlename)
% 
% axis square
% colorbar
% colormap('summer')
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);
% name = [newFileName '-' condition1];
% saveas(gcf,name,'png');
% saveas(gcf,name,'fig');
%     
% connectivity matrix condition2
% mean_ShO_pax=mean(M.C2, 3);
% means=figure, imagesc(mean_ShO_pax);
% name = [newFileName '-' condition2];
% 
% set(gca,'YTick',[1:size(labels,1)] );
% set(gca,'YTickLabel',labels);      
% 
% set(gca,'XTick',[1:size(labels,1)] );
% set(gca,'XTickLabel',labels);   
% titlename = [newFileName '-' condition2];
% title(titlename)
% axis square
% colorbar
% colormap('winter')
% 
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);
% saveas(gcf,name,'png');
% saveas(gcf,name,'fig');

% C_1 = [];
% C_2 = [];

% for suj=1:size(M,2)
%         temp = M(1,suj).C1;    % condicion 1
%         C_1 = [C_1,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];
%         
%         temp = M(1,suj).C2;    % condicion 2
%         C_2 = [C_2,reshape(temp,size(temp,1)*size(temp,1),size(temp,3))];        
% end
% 
% C_1(isnan(C_1)) = 0;
% C_2(isnan(C_2)) = 0;

%print ttest matrix
[H,P,CI,STATS] = ttest2(a',b' ); 
size(STATS.tstat)
T = reshape(STATS.tstat,matrixSize,matrixSize);
P = reshape(P,matrixSize,matrixSize);

caxisValues = [0 p_value];
PfileName = [newFileName '_P'];
PlotMap(P,labels,caxisValues,PfileName);
rotateXLabels(gca,90);
set(gca,'position',[0.07 0.125 0.8 0.8]);
name = [PfileName '_matrix'];
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

T_signif = P;
T_signif(P>p_value)=0; 
T_signif(P<=p_value)=1; 

Pmask = P;
Pmask(Pmask>p_value)=0;

Tmask = T;

if ~isempty(Tmax) & ~isempty(Tmin)
    caxisValues = [Tmin Tmax];
    Tmask(Tmask>Tmin&Tmask<Tmax)=0;
else
    caxisValues = [];
end
PfileName = [newFileName '_T'];
PlotMap(T,labels,caxisValues,PfileName);
rotateXLabels(gca,90);
set(gca,'position',[0.07 0.125 0.8 0.8]);
name = [PfileName '_matrix'];
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

if ~isempty(Tmax) & ~isempty(Tmin)
    PfileName = [newFileName '_Tmask'];
    PlotMap(Tmask,labels,caxisValues,PfileName);
    rotateXLabels(gca,90);
    set(gca,'position',[0.07 0.125 0.8 0.8]);
    name = [PfileName '_matrix'];
    saveas(gcf,name,'png');
    saveas(gcf,name,'fig');
    
    signifMask = Tmask.*T_signif;
    ResultMatrix = signifMask;
    PfileName = [newFileName '_Tsignificancemask'];
    PlotMap(signifMask,labels,caxisValues,PfileName); 
    rotateXLabels(gca,90);
    set(gca,'position',[0.07 0.125 0.8 0.8]);
    name = [PfileName '_matrix'];
    saveas(gcf,name,'png');
    saveas(gcf,name,'fig');
else
    ResultMatrix = T;
end

%plot histogram
figure, hist(T(:),100);
box off
name = [newFileName '_histogram'];

title(newFileName)

saveas(gcf,name,'png');
saveas(gcf,name,'fig');
 