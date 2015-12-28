function SubplotMapsAndSaveInRoot(map2Plot1,map2Plot2,condition1,condition2,titleName,tickPercentage,EjeX,EjeY,caxisValues,root)

%plot
figure
subplot(2,1,1)
imagesc(map2Plot1)
title([titleName '-' condition1])
%tickPercentage = 0.05;
[XTickValues XTickPosition] = CalculateXTicks(EjeX,tickPercentage);

set(gca,'XTick',XTickPosition); 
set(gca,'XTickLabel',XTickValues);

set(gca,'YTick',[1:size(EjeY,1)] );
set(gca,'YTickLabel',EjeY);      
%set(gca,'YDir','normal');
set(gca,'YDir','reverse');
colorbar
if ~isempty(caxisValues)
    caxis(caxisValues)
end
rotateXLabels(gca,90);

subplot(2,1,2)
imagesc(map2Plot2)
title(condition2)
%tickPercentage = 0.05;
[XTickValues XTickPosition] = CalculateXTicks(EjeX,tickPercentage);

set(gca,'XTick',XTickPosition); 
set(gca,'XTickLabel',XTickValues);

set(gca,'YTick',[1:size(EjeY,1)] );
set(gca,'YTickLabel',EjeY);      
%set(gca,'YDir','normal');
set(gca,'YDir','reverse');
colorbar
if ~isempty(caxisValues)
    caxis(caxisValues)
end
rotateXLabels(gca,90);

fileName = [root titleName '-' condition1 '-' condition2];
saveas(gcf,fileName,'fig');
saveas(gcf,fileName,'eps');
saveas(gcf,fileName,'png');