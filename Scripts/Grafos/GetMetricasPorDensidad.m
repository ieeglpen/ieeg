function [L C degree BC globalEfficiency localEfficiency SW] = GetMetricasPorDensidad(matsInStruct)

trialNr = size(matsInStruct,2);
pasosNr = size(matsInStruct(1).metricas.Densidad.L,2);
channelNr = size(matsInStruct(1).metricas.Densidad.C,1);

L = zeros(trialNr,pasosNr);
C = zeros(trialNr,channelNr,pasosNr);
degree = zeros(trialNr,channelNr,pasosNr);
BC = zeros(trialNr,channelNr,pasosNr);
globalEfficiency = zeros(trialNr,pasosNr);
localEfficiency = zeros(trialNr,channelNr,pasosNr);
SW = zeros(trialNr,pasosNr);

for i = 1 : trialNr
    L(i,:) = matsInStruct(i).metricas.Densidad.L;
    C(i,:,:) = matsInStruct(i).metricas.Densidad.C;
    degree(i,:,:) = matsInStruct(i).metricas.Densidad.degree;
    BC(i,:,:) = matsInStruct(i).metricas.Densidad.BC;
    globalEfficiency(i,:) = matsInStruct(i).metricas.Densidad.global_effi;
    localEfficiency(i,:,:) = matsInStruct(i).metricas.Densidad.local_effi;
    SW(i,:,:) = matsInStruct(i).metricas.Densidad.SW_sporns;
end