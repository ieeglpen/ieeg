function set_figure_size(xSize)
%set_figure_size(xSize)
% Setea la figura tal que cuando se imprima con el comando 
%"print -depsc -tiff 'Figure1.eps'"
% quede del tama�o xSize x ySize, donde ySize lo saca
% de las proporciones de la figura actual
%
% MEDIDAS LETTER: xSize = 21.6; ySize = 27.9;
pos=get(gcf,'Position');
YoverX=pos(4)/pos(3);

set(gcf,'PaperUnits','centimeters','PaperPosition',[1 1 xSize YoverX*xSize])
