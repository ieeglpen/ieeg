function [metricas]=metricasAll(mat)
% Esta funcion llama a todas las funciones de metricas. 
%
% ----------------- INPUTS ---------------------------
%mat=matriz cuadrada de correlaciones una por cada sujeto
%
%----------------- OUTPUTS  ---------------------------
%Una estructura con el siguiente contenido
%       Densidad
%       Umbral
%       Pesadas
%Cada uno de estos contiene las metricas segun el metodo explicitado por su
%nombre
%
% --------------- ADVERTENCIA ----------------------------------------
%para funcionar esta funcion necesita que este en el path el toolbox BCT


%% (1) Comienzo a llamar las funciones que hacen las metricas

metricas.Densidad=metricasDensidad(mat);
metricas.Umbral=metricasUmbral(mat);
metricas.Pesadas=metricasPesadas(mat);

end
%%

%by hipereolo
