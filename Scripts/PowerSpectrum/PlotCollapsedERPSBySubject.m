function PlotCollapsedERPSBySubject(matInt,matAcc,timesout,statmethod,p_value,prefixFileName,titleName,color1,color2,colorPvalue)
%matInt y matAcc tienen 3 dimensiones: freqs x time x trials

%promedio por frecuencias
meanInt = squeeze(mean(matInt,1));
meanAcc = squeeze(mean(matAcc,1));

h = figure;
%subplot(2,1,1)
[h1 maxcondInt] = plot_std_met(meanInt,timesout, color1);  %grafica variable "uno"  r="red", m="magenta"
hold on
[h2 maxcondAcc] = plot_std_met(meanAcc,timesout, color2);  %grafica variable "dos"  b="blue", c="celeste" orange=[1 .5 0]
%legend([h1,h2],{conditionName1,conditionName2},'Location','Best')
titleName = [titleName '-' statmethod];
%title(titleName)
ylabel('mean ERPS(std.)')
%set(gca,'xticklabel',[])
set(gca,'box','off')

pINT = permute(matInt,[2 3 1]);
rINT = reshape(pINT,200,size(matInt,3)*size(matInt,1));

pACC = permute(matAcc,[2 3 1]);
rACC = reshape(pACC,200,size(matAcc,3)*size(matAcc,1));

Permut{1}=rINT;                         % transforma las variables en cellarray
Permut{2}=rACC;                         % transforma las variables en cellarray

if strcmp(statmethod,'boot')
    [t df pvals] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',200);   %calcula permutaciones
    %[t df pvals] = statcond(Permut, 'mode', 'perm','paired','off','tail','both','naccu',1000);   %calcula permutaciones   
    %pv = ones(1,200)*p_value;
    %plot(timesout,pvals,'g',timesout,pv,'k','LineWidth',2)
    %plotpvals_lpen_met2(p_value,pvals,time,colorPvalue,1,0,'-')
    [i_ind y]=find(pvals<p_value);
    
else
    [p h zval ranksum] = ranksumForMatrices(rINT,rACC,p_value);
    %subplot(2,1,2)
    %pv = ones(1,200)*p_value;
    %plot(timesout,p,'g',timesout,pv,'k','LineWidth',2)    
    %plotpvals_lpen_met2(p_value,p,time,colorPvalue,1,0,'-')
    pvals = p;
    [i_ind y]=find(p<p_value);
end

if ~isempty(i_ind)
    i_ind = i_ind(i_ind < 180) %valor harcodeado de cero - no incluyo lo significativo del baseline
    
    max_cond = max([maxcondInt maxcondAcc]);
    size(timesout(i_ind))
    
    plot(timesout(i_ind),max_cond*1.1,'*', 'Color',colorPvalue, 'MarkerSize', 5)

end

% subplot(2,1,2)
% plotpvals_lpen_met2(p_value,pvals,timesout,colorPvalue,1,0,'-')
% pv = ones(1,200)*p_value;
% plot(timesout,pvals,'g',timesout,pv,'k','LineWidth',2) 

% ylabel('p values')
 xlabel('Time (ms)')
% set(gca,'YTickLabel',['0.01';'0.05'])
set(gca,'box','off')
set(gcf,'color','w')
title(titleName)
% 
saveas(gcf,[prefixFileName titleName],'fig');
saveas(gcf,[prefixFileName titleName],'eps');
saveas(gcf,[prefixFileName titleName],'png');