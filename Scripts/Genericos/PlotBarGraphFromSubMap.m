function PlotBarGraphFromSubMap(fileName,conditionsMapsStruct,freqs,times,freqsWindow,timeWindow,labels)

conditionNr = size(conditionsMapsStruct,2);
groupNr = size(conditionsMapsStruct(1).maps,1);
conditionValues = zeros(groupNr,conditionNr);
barLegend = cell(conditionNr,1);

for i = 1 : conditionNr
    maps = conditionsMapsStruct(i).maps;
    meanValues = GetMeanValuesFromSubMaps(maps,freqs,times,freqsWindow,timeWindow);
    conditionValues(:,i) = meanValues';
    barLegend{i} = conditionsMapsStruct(i).name;
end

figure
colormap Winter
hDataSeries = bar(conditionValues,1);

hLegend = legend(hDataSeries ,barLegend);
set(hLegend, 'FontSize',8);
set(gca,'XTickMode','manual','XTickLabel',labels,'fontsize',8)
XTickPosition = 1:25;
set(gca,'XTick',XTickPosition); 
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
%xlabel('Population','FontSize',12,'FontWeight','bold','Color','r')
%xlabel('','FontSize',6)
rotateXLabels(gca,90);

title(fileName)
saveas(gcf,fileName,'fig');
saveas(gcf,fileName,'png');