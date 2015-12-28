function PlotMapAndSaveInRoot(map2Plot,titleName,tickPercentage,EjeX,EjeY,caxisValues,root)

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

fileName = [root titleName];
saveas(gcf,fileName,'fig');
saveas(gcf,fileName,'png');