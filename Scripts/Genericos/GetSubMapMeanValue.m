function [meanValue] = GetSubMapMeanValue(map,freqs,times,freqsWindow,timeWindow)

timePosition1 = round(interp1(times,1:length(times),timeWindow(1)));
timePosition2 = round(interp1(times,1:length(times),timeWindow(2)));

freqPosition1 = round(interp1(freqs,1:length(freqs),freqsWindow(1)));
freqPosition2 = round(interp1(freqs,1:length(freqs),freqsWindow(2)));

subMap = map(freqPosition1:freqPosition2,timePosition1:timePosition2);

meanValue = mean2(subMap);