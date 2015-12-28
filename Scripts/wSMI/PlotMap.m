function PlotMap(map,labels,caxisValues,newFileName)

h = figure,imagesc(map);

set(gca,'YTick',[1:size(labels,1)] );
set(gca,'YTickLabel',labels);      

set(gca,'XTick',[1:size(labels,1)] );
set(gca,'XTickLabel',labels);      

colorbar

if ~isempty(caxisValues)
    caxis([caxisValues(1) caxisValues(2)])
end
axis square
colorbar

%format_figure(gcf)
%set_figure_size(20)

title(newFileName)
%rotateXLabels(gca,90);  
%set(gca,'fontsize', 8);
%set(gca,'position',[0.07 0.125 0.8 0.8]);

%saveas(h, ['matriz_condicion' cond],'png')
%saveas(gcf, [newFileName '_matrix'],'png')
name = [newFileName '_matrix'];
saveas(gcf,name,'png');
%saveas(gcf, [newTitleName '_matrix'],'fig')
saveas(gcf,name,'fig');