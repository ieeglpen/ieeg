function [mat] = AcondicionoMatrices(M)

cond = M;

%promedio por los trials
meancond = mean(cond,3);

%obtengo el valor minimo y lo sumo al resto
minVal = min(meancond(:));

%sumo el valor minimo para no tener valores negativos
mat = meancond + abs(minVal);

%reemplazo los valores NaNs por 0
mat(isnan(mat))=0;
