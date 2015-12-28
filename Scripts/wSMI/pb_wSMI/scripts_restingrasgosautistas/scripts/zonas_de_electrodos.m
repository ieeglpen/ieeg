%%  definicion de regiones de electrodos
figure_defaults
 
ind_nuca_izq=[ 8:17];
ind_nuca_der=[ 26:30 37:41];
ind_nuca_centro= [21:25];
ind_nuca=[ind_nuca_izq,ind_nuca_der,ind_nuca_centro];
ind_frente=[72:74 76:85 89:96]; 

ind_temporal_derecho=[42:44 45:48 56:61];
ind_temporal_izquierdo=[104:106 117:122 125:128];
ind_centro=[1:3 33:34 51:53 64:66 75 86:88 97:98 109:114];




inds_derecha = [ ind_temporal_derecho];
inds_izquierda= [ind_temporal_izquierdo];
% 
ind_nuca_izq=[ 8:17];
ind_nuca_der=[ 26:30 37:41];
ind_nuca_centro= [21:25];
ind_nuca=[ind_nuca_izq,ind_nuca_der,ind_nuca_centro];
ind_frente=[72:74 76:85 89:96]; 
ind_temporal_derecho=[42:44 45:49 56:61];
ind_temporal_izquierdo=[104:106 117:123 125:128];
ind_centro=[1:3 33:34 51:53 64:66 75 86:88 97:98 109:114];
ind_frente_centro=[76:85 89:93];
ind_frente_derecha=[55:62 69:74 78 79 80];
ind_frente_izquierda=[ 94 95 96 91 92 93 101:107 116:119];
inds_derecha = [ind_nuca_der, ind_temporal_derecho, ind_frente_derecha];
inds_izquierda= [ind_nuca_izq, ind_temporal_izquierdo, ind_frente_izquierda];
% %
T=20;
figure
load coord
% scatter(y,x,T,'filled','MarkerFaceColor',[70 70 70]/255,'MarkerEdgeColor',[0 0 0]);
scatter(y,x,T,'filled','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0]);
axis off
hold on
 
%  scatter(y(inds_derecha),x(inds_derecha),T,'filled','MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 0],'linewidth',.005);
%  scatter(y(inds_izquierda),x(inds_izquierda),T,'filled','MarkerFaceColor',[0 1 0],'MarkerEdgeColor',[0 0 0],'linewidth',.005);

 scatter(y(ind_temporal_derecho),x(ind_temporal_derecho),T,'filled','MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 0],'linewidth',.005);
 scatter(y(ind_temporal_izquierdo),x(ind_temporal_izquierdo),T,'filled','MarkerFaceColor',[0 1 0],'MarkerEdgeColor',[0 0 0],'linewidth',.005);

% scatter(y(ind_nuca),x(ind_nuca),T,'filled','MarkerFaceColor',[0 1 0],'MarkerEdgeColor',[0 0 0]);
% scatter(y(ind_centro),x(ind_centro),T,'filled','MarkerFaceColor',[103, 64, 58] ./255,'MarkerEdgeColor',[0 0 0]);
% scatter(y(ind_frente_derecha),x(ind_frente_derecha),T,'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0]);
% scatter(y(ind_frente_izquierda),x(ind_frente_izquierda),T,'filled','MarkerFaceColor',[1 1 0],'MarkerEdgeColor',[0 0 0]);
% scatter(y(ind_frente),x(ind_frente),T,'filled','MarkerFaceColor',[ 0 0 1],'MarkerEdgeColor',[0 0 0]);


format_figure(gcf)
set_figure_size(5)
cd /home/pablo/Dropbox/dropbox_pablob/autistic_traits/figuras/figura2

print('-depsc', '-tiff', '-painters', '-r600', 'sc_lateral_chico')