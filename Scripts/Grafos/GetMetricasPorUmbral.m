function [L C degree BC globalEfficiency localEfficiency SW] = GetMetricasPorUmbral(matsInStruct)

trialNr = size(matsInStruct,2);
pasosNr = size(matsInStruct(1).metricas.Umbral.L,2);
channelNr = size(matsInStruct(1).metricas.Umbral.C,1);

L = zeros(trialNr,pasosNr);
C = zeros(trialNr,channelNr,pasosNr);
degree = zeros(trialNr,channelNr,pasosNr);
BC = zeros(trialNr,channelNr,pasosNr);
globalEfficiency = zeros(trialNr,pasosNr);
localEfficiency = zeros(trialNr,channelNr,pasosNr);
SW = zeros(trialNr,pasosNr);

for i = 1 : trialNr
    L(i,:) = matsInStruct(i).metricas.Umbral.L;
    C(i,:,:) = matsInStruct(i).metricas.Umbral.C;
    degree(i,:,:) = matsInStruct(i).metricas.Umbral.degree;
    BC(i,:,:) = matsInStruct(i).metricas.Umbral.BC;
    globalEfficiency(i,:) = matsInStruct(i).metricas.Umbral.global_effi;
    localEfficiency(i,:,:) = matsInStruct(i).metricas.Umbral.local_effi;
    SW(i,:,:) = matsInStruct(i).metricas.Umbral.SW_sporns;
end