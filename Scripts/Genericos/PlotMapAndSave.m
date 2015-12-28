function PlotMapAndSave(map2Plot,titleName,tickPercentage,EjeX,EjeY,caxisValues)

%plot
figure
imagesc(map2Plot)
title(titleName)
%tickPercentage = 0.05;
[XTickValues XTickPosition] = CalculateXTicks(EjeX,tickPercentage);

set(gca,'XTick',XTickPosition); 
set(gca,'XTickLabel',XTickValues);

set(gca,'YTick',[1:size(EjeY,1)] );
set(gca,'YTickLabel',EjeY);      
set(gca,'YDir','normal');
colorbar
if ~isempty(caxisValues)
    caxis(caxisValues)
end
%saveas(gcf,SynchronyMap(h).title,'png');
% saveas(gcf,titleName,'fig');
% saveas(gcf,titleName,'png');