function [degree BC] = GetMetricasPesadas(matsInStruct)

trialNr = size(matsInStruct,2);
channelNr = size(matsInStruct(1).metricas.Umbral.C,1);

degree = zeros(trialNr,channelNr);
BC = zeros(trialNr,channelNr);

for i = 1 : trialNr
    degree(i,:) = matsInStruct(i).metricas.Pesadas.degree;
    BC(i,:) = matsInStruct(i).metricas.Pesadas.BC;
end