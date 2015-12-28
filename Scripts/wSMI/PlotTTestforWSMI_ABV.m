function [ResultMatrix Pmask] = PlotTTestforWSMI(condition1,condition2,tau,fileName,channelNr,path,newFileName,labels,p_value,Tmax,Tmin)

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

% %connectivity matrix condition1
 mean_ShO_con=mean(M.C1, 3);
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
% %caxis([-0.1 0.1])
% axis square
% colorbar
% colormap('summer')
% %set_figure_size(14)  
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);
% name = [newFileName '-' condition1];
% saveas(gcf,name,'png');
% %saveas(gcf, [newTitleName '_matrix'],'fig')
% saveas(gcf,name,'fig');
% 
%     
% %connectivity matrix condition2
 mean_ShO_pax=mean(M.C2, 3);
% means=figure, imagesc(mean_ShO_pax);
% name = [newFileName '-' condition2];
% % 
% % caxisValues = [];
% % PfileName = name;
% % PlotMap(mean_ShO_pax,labels,caxisValues,PfileName);
% % rotateXLabels(gca,90);

%PLOT SUSTRACTION MATRIX
sustractionMatrix = mean_ShO_con - mean_ShO_pax;
caxisvalues = [-0.01 0.01];
titlename = [newFileName '-' condition1 '-' condition2];
dosave = 1;
colorMap = 'jet';
PlotFormattedMap(sustractionMatrix,labels,caxisvalues,colorMap,titlename,titlename,dosave);

%PLOT BINARY SUSTRACTION MATRIX 
sustractionMatrix = mean_ShO_con - mean_ShO_pax;
sustractionMatrix(sustractionMatrix < 0)= -1;
sustractionMatrix(sustractionMatrix > 0)= 1;

dosave = 1;
caxisvalues = [-0.01 0.01];
colorMap = 'jet';
titlename = [newFileName 'binary-' condition1 '-' condition2];

PlotFormattedMap(sustractionMatrix,labels,caxisvalues,colorMap,titlename,titlename,dosave);

% MATRIX ANALISIS OF CONDITION: ACC
% tau
% percentage = 0.6;
% %meanSus = mean(sustractionMatrix,3);
% meanSus = sustractionMatrix;
% 
% for m = 1 : matrixSize
%     tempV = meanSus(m,:);
%            
%     if length(find(tempV < 0)) >= round(matrixSize*percentage)
%         str1 = ['El electrodo ' num2str(m) 'favorece acc.'];
%         display(str1)
%     end
% end
% 
% susmeans=figure;

C12stat = M.C1;
C22stat = M.C2;

C12stat(isnan(C12stat)) = 0;
C22stat(isnan(C22stat)) = 0;

%[stats df pvals surrog] = statcond({C12stat,C22stat},'paired','off','method','bootstrap','naccu',200);
% [stats df pvals surrog] = statcond({mean(C12stat,3),mean(C22stat,3)},'method','param');
% 
% susMat2plot = sustractionMatrix;
% susMat2plot(pvals > p_value) = 0;

% intValues = length(find(sustractionMatrix>0));
% accValues = length(find(sustractionMatrix<0));
% 
% str = ['En tau ' int2str(tau) ' con p value = ' num2str(p_value) ' hay int: ' int2str(intValues) ' vs acc: ' int2str(accValues)];
% display(str)

% susMat2plot = sustractionMatrix;
% susMat2plot(susMat2plot < 0) = 0;

%imagesc(sustractionMatrix);
% imagesc(susMat2plot);
% name = [newFileName '-' condition1 '-' condition2];
% 
% % 
% % caxisValues = [];
% % PfileName = name;
% % PlotMap(mean_ShO_pax,labels,caxisValues,PfileName);
% % rotateXLabels(gca,90);
% 
% set(gca,'YTick',[1:size(labels,1)] );
% set(gca,'YTickLabel',labels);      
% 
% set(gca,'XTick',[1:size(labels,1)] );
% set(gca,'XTickLabel',labels);   
% titlename = name;
% title(titlename)
% %caxis([-0.01 0.01])
% axis square
% colorbar
% colormap('jet')
% 
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);
% % %set_figure_size(20)
% 
% % 
% saveas(gcf,name,'png');
% %saveas(gcf, [newTitleName '_matrix'],'fig')
% saveas(gcf,name,'fig');
% %color1=[0 0 0];
%     %h= figure;
%     %draw_links_scalp_Threshold(mean_ShO_pax ,Tmax,color1)
%     %title('Pacientes: Mean')

%PLOT HISTOGRAM OF SUSTRACTION MATRIX
figure;
hist(sustractionMatrix(:),100);
title(tau)
titlename = [newFileName '-' condition1 '-' condition2];
saveas(gcf, [titlename '_histogram'],'fig')

ResultMatrix = [];
Pmask = [];

%RESHAPE MATRICES FOR STATISTICAL ANALYSIS
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

% sustractionMatrix = C_1 - C_2;
% susMat2plot = reshape(mean(sustractionMatrix,2),channelNr,channelNr);

sustractionMatrix = mean(C_1,2) - mean(C_2,2);
susMat2plot = reshape(sustractionMatrix,channelNr,channelNr);

%STATISTICAL ANALYSIS OF WILCOXON RANK SUM TEST
[p h zval ranksum] = ranksumForMatrices(C_1,C_2,p_value);

P = reshape(p,channelNr,channelNr);

susMat2plot(P > p_value) = 0;

intValues = length(find(susMat2plot>0));
accValues = length(find(susMat2plot<0));

str = ['En tau ' int2str(tau) ' con p value = ' num2str(p_value) ' hay int: ' int2str(intValues) ' vs acc: ' int2str(accValues)];
display(str)

caxisvalues = [-0.01 0.01];
colorMap = 'jet';
titlename = [newFileName 'mask-' condition1 '-' condition2];
dosave = 1;
PlotFormattedMap(susMat2plot,labels,caxisvalues,colorMap,titlename,titlename,dosave);

% figure
% imagesc(susMat2plot);
% 
% set(gca,'YTick',[1:size(labels,1)] );
% set(gca,'YTickLabel',labels);      
% 
% set(gca,'XTick',[1:size(labels,1)] );
% set(gca,'XTickLabel',labels);   
% 
% title(titlename)
% caxis([-0.01 0.01])
% axis square
% colorbar
% colormap('jet')
% 
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);


susMat2plot(susMat2plot>0) = 1;
susMat2plot(susMat2plot<0) = -1;

posVec = ones(length(find(susMat2plot>0)),1);
negVec = -1*ones(length(find(susMat2plot<0)),1);
Vec = cat(1,posVec,negVec);

figure;
hist(Vec(:),100);
title([int2str(tau) '-mask']) 
titlename = [newFileName '-' condition1 '-' condition2];
saveas(gcf, [titlename 'mask_histogram'],'fig')

% %print ttest matrix
% [H,P,CI,STATS] = ttest2(C_1',C_2' ); 
% 
% display('P')
% size(P)
% display('T')
% size(STATS.tstat)
% T = reshape(STATS.tstat,matrixSize,matrixSize);
% P = reshape(P,matrixSize,matrixSize);
% 
% %h = figure,imagesc(T);
% 
% %H = reshape(H,matrixSize,matrixSize);
% %h = figure,imagesc(H);
% %caxisValues = [];
% %HfileName = [newFileName '_H'];
% %PlotMap(H,labels,caxisValues,HfileName);
% 
% caxisValues = [0 p_value];
% PfileName = [newFileName '_P'];
% PlotMap(P,labels,caxisValues,PfileName);
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);
% name = [PfileName '_matrix'];
% saveas(gcf,name,'png');
% %saveas(gcf, [newTitleName '_matrix'],'fig')
% saveas(gcf,name,'fig');
% 
% T_signif = P;
% %signif=find(P<p_value);
% %t_signif=STATS.tstat(signif);
% T_signif(P>p_value)=0; 
% T_signif(P<=p_value)=1; 
% 
% Pmask = P;
% Pmask(Pmask>p_value)=0;
% 
% %para plotear el cuartil 25 ->Y = quantile(X,p) ?
% % left_side_t=t_signif(find(t_signif<0));
% % right_side_t=t_signif(find(t_signif>0));
% % 
% % median_left=nanmedian(left_side_t);
% % median_right=nanmedian(right_side_t);
% % 
% % left_side_t_50=t_signif(find(t_signif<median_left));
% % right_side_t_50=t_signif(find(t_signif>median_right));
% % 
% % T075right=nanmedian(right_side_t_50);
% % T075left=nanmedian(left_side_t_50);
% % 
% % T2 = T;
% % T2(find(T2<T075right & T2>T075left))=0;
% % 
% % T2(find(T2<T075right & T2>T075left))=0;
% 
% Tmask = T;
% 
% if ~isempty(Tmax) & ~isempty(Tmin)
%     caxisValues = [Tmin Tmax];
%     Tmask(Tmask>Tmin&Tmask<Tmax)=0;
% else
%     caxisValues = [];
% end
% PfileName = [newFileName '_T'];
% PlotMap(T,labels,caxisValues,PfileName);
% rotateXLabels(gca,90);
% set(gca,'position',[0.07 0.125 0.8 0.8]);
% name = [PfileName '_matrix'];
% saveas(gcf,name,'png');
% %saveas(gcf, [newTitleName '_matrix'],'fig')
% saveas(gcf,name,'fig');
% 
% if ~isempty(Tmax) & ~isempty(Tmin)
%     PfileName = [newFileName '_Tmask'];
%     PlotMap(Tmask,labels,caxisValues,PfileName);
%     rotateXLabels(gca,90);
%     set(gca,'position',[0.07 0.125 0.8 0.8]);
%     name = [PfileName '_matrix'];
%     saveas(gcf,name,'png');
%     %saveas(gcf, [newTitleName '_matrix'],'fig')
%     saveas(gcf,name,'fig');
%     
%     signifMask = Tmask.*T_signif;
%     ResultMatrix = signifMask;
%     PfileName = [newFileName '_Tsignificancemask'];
%     PlotMap(signifMask,labels,caxisValues,PfileName); 
%     rotateXLabels(gca,90);
%     set(gca,'position',[0.07 0.125 0.8 0.8]);
%     name = [PfileName '_matrix'];
%     saveas(gcf,name,'png');
%     %saveas(gcf, [newTitleName '_matrix'],'fig')
%     saveas(gcf,name,'fig');
% else
%     ResultMatrix = T;
% end
% 
% 
% % % set(gca,'YTick',[1:size(labels,1)] );
% % % set(gca,'YTickLabel',labels);      
% % % 
% % % set(gca,'XTick',[1:size(labels,1)] );
% % % set(gca,'XTickLabel',labels);      
% % % 
% % % colorbar
% % % 
% % % %caxis([-5 5])
% % % caxis([0 0.05])
% % % axis square
% % % colorbar
% % % 
% % % %format_figure(gcf)
% % % set_figure_size(14)
% % % 
% % % title(newFileName)
% % % 
% % % %saveas(h, ['matriz_condicion' cond],'png')
% % % %saveas(gcf, [newFileName '_matrix'],'png')
% % % name = [newFileName '_matrix'];
% % % saveas(gcf,name,'png');
% % % %saveas(gcf, [newTitleName '_matrix'],'fig')
% % % saveas(gcf,name,'fig');
% 
% %plot histogram
% figure, hist(T(:),100);
% box off
% name = [newFileName '_histogram'];
% 
% title(newFileName)
% 
% saveas(gcf,name,'png');
% saveas(gcf,name,'fig');
% 
% % saveas(gcf, [newTitleName '_histogram'],'png')
% % saveas(gcf, [newTitleName '_histogram'],'fig')
% 
% %TODO implementar el plot 3D
% % Tmax = 5 ; Tmin = -Tmax;
% % h= figure
% % draw_links_scalp(T ,Tmax,Tmin,color1,color2)
% 
% % format_figure(gcf)
% % set_figure_size(14)
% % saveas(h, ['scalp_condicion' num2str(cond)],'png')

%%
% a = mean(C_2,2) - mean(C_1,2);
% b = mean(P_2,2) - mean(P_1,2);
% 
% 
% c = a-b;
% c = reshape(c,60,60);
% h= figure,imagesc(c)
% caxis([-.002 .002])
% axis square
% colorbar
% format_figure(gcf)
% set_figure_size(14)
% saveas(h, ['interaccion' ],'png')
% 
% 
% figure, hist(c(:),100)
% box off
% Tmax = .0015; Tmin = -Tmax ;
% figure
% draw_links_scalp(c,Tmax,Tmin,color2,color1)
 