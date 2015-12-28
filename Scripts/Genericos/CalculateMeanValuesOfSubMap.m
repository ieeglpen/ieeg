function [conditionValues barLegend] = CalculateMeanValuesOfSubMap(conditionsMapsStruct,freqs,times,freqsWindow,timeWindow)

conditionNr = size(conditionsMapsStruct,2);
groupNr = size(conditionsMapsStruct(1).maps,1);
conditionValues = zeros(groupNr,conditionNr);
barLegend = cell(conditionNr,1);

for i = 1 : conditionNr
    maps = conditionsMapsStruct(i).maps;
    meanValues = GetMeanValuesFromSubMaps(maps,freqs,times,freqsWindow,timeWindow);
    conditionValues(:,i) = meanValues';
    barLegend{i} = conditionsMapsStruct(i).name;
end