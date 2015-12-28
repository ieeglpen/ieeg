function [meanValues] = GetMeanValuesFromSubMaps(maps,freqs,times,freqsWindow,timeWindow)

mapNr = size(maps,1);
meanValues = zeros(1,mapNr);

for i = 1 : mapNr
    map = squeeze(maps(i,:,:));
    meanValue = GetSubMapMeanValue(map,freqs,times,freqsWindow,timeWindow);
    meanValues(1,i) = meanValue;
end
