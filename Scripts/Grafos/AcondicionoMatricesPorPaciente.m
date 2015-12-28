function [mat] = AcondicionoMatricesPorPaciente(M)

cond = M;

%promedio por los trials
%meancond = mean(cond,3);

%obtengo el valor minimo y lo sumo al resto
minVal = min(M(:));

%sumo el valor minimo para no tener valores negativos
mat = cond + abs(minVal);

%reemplazo los valores NaNs por 0
mat(isnan(mat))=0;
