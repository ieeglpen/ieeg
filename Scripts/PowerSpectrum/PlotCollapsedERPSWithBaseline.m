function PlotCollapsedERPSWithBaseline(matCond1,matCond2,conditionName1,conditionName2,timesout,baseTime,statmethod,p_value,prefixFileName,titleName,color1,color2,colorPvalue)
%matInt y matAcc tienen 3 dimensiones: freqs x time x trials

%promedio por frecuencias
meanCond1 = squeeze(mean(matCond1,1));
meanCond2 = squeeze(mean(matCond2,1));

h = figure;
[h1 maxcondInt] = plot_std_met(meanCond1,timesout, color1);  
hold on
[h2 maxcondAcc] = plot_std_met(meanCond2,timesout, color2);  
legend([h1,h2],{conditionName1,conditionName2},'Location','Best')
titleName = [titleName '-' statmethod];

ylabel('mean ERPS(std)')
set(gca,'box','off')

pCond1 = permute(matCond1,[2 3 1]);
rCond1 = reshape(pCond1,200,size(matCond1,3)*size(matCond1,1));

pCond2 = permute(matCond2,[2 3 1]);
rCond2 = reshape(pCond2,200,size(matCond2,3)*size(matCond2,1));

Permut{1}=rCond1;                         % transforma las variables en cellarray
Permut{2}=rCond2;                         % transforma las variables en cellarray

if strcmp(statmethod,'boot')
    [t df pvals] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',200);   %calcula permutaciones   
else
    [pvals h zval ranksum] = ranksumForMatrices(rCond1,rCond2,p_value);    
end

[i_ind y]=find(pvals<p_value);

if ~isempty(i_ind)
    %i_ind = i_ind(i_ind < 180); %valor harcodeado de cero - no incluyo lo significativo del baseline    
    max_cond = max([maxcondInt maxcondAcc]);       
    plot(timesout(i_ind),max_cond*1.1,'*', 'Color',colorPvalue, 'MarkerSize', 5)

end

yL = get(gca,'YLim');
line([baseTime baseTime],yL,'Color','m','LineWidth', 2,'LineStyle','-');

xlabel('Time (ms)')
set(gca,'box','off')
set(gcf,'color','w')
title(titleName)
 
saveas(gcf,[prefixFileName titleName],'fig');
saveas(gcf,[prefixFileName titleName],'png');