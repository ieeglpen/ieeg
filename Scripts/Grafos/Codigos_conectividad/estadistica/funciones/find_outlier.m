function [val_outliers]=find_outlier(valores,umbral_desvio)
%% saco los outliers de un vector

%% (1) Calculo los valores de media y desvio
media=nanmean(valores);
desvio=nanstd(valores);

%% (2) Calculo el limite inferior y superior para considerar outlier utilizando el valor de outlier que uso
%(2.1)limite inferior
lim_inf=media-desvio*umbral_desvio;
%(2.2)limite superior
lim_sup=media+desvio*umbral_desvio;
clear media desvio

%% (3) Aquellos valores del grupo que superen los limites inferior o superior se los llena con NaN
%(3.1) saco el limite superior
out_sup=find(valores>=lim_sup);
%(3.2) saco el limite inferior
out_inf=find(valores<=lim_inf);
%(3.3) reemplazo los lugares donde hay outliers con NaN
valores(out_sup)=NaN;
valores(out_inf)=NaN;
clear out_sup out_find

%% (4) Guardo los nuevos valores en la variable que guardo.

val_outliers=valores;

end