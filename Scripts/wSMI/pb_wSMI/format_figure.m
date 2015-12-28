%%%%%%%%%%%%%%%%%% print -depsc -tiff -painters -r600 nombredelafigura

function format_figure(hfig,varargin)
%format_figure(hfig,varargin)

hax = get(hfig,'children');

invert_colors = 0;
FontSize = 6.8;
LineWidth = 0.335;
for i=1:length(varargin)
   if strcmp(varargin{i},'presentation')
       FontSize = 18;
       LineWidth = 1;
       hax = get(gcf,'Children');
       for j = 1:length(hax)
           set(hax(j),'LineWidth',2.5)
       end

   end
   if strcmp(varargin{i},'invert_colors')
       invert_colors = 1;
   end
end

all_text = findall(hfig,'Type','text');
set(all_text,'FontSize',FontSize)

for i=1:length(hax)
   set(hax(i),'FontSize',FontSize,'LineWidth',LineWidth,'box','off')
end

if invert_colors==1
   a = findall(hfig);
   w = findobj(a,'Color','w');
   b = findobj(a,'Color','k');
   set(w,'Color','k');
   set(b,'Color','w');

   for j=1:length(hax)
       set(hax(j),'Ycolor','w')
       set(hax(j),'Xcolor','w')
       set(hax(j),'Color','none') % Para fondo
       %transparente
   end

   set(hfig,'Color','none') % Para fondo transparente
   set(hfig,'InvertHardcopy','off')
end