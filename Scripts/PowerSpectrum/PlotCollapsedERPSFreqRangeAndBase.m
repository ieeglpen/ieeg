function PlotCollapsedERPSFreqRangeAndBase(condMat1,condMat2,conditionName1,conditionName2,freqs,freqRange,timesout,epochTime,statmethod,p_value,prefixFileName,titleName,color1,color2,colorPvalue)
%condMat1, condMat2 deben tener 3 dimensiones: frequency x time x trials

minFreq = interp1(freqs,1:size(freqs,2),freqRange(1));
maxFreq = interp1(freqs,1:size(freqs,2),freqRange(2));

condition1FreqMat = condMat1(minFreq:maxFreq,:,:);
condition2FreqMat = condMat2(minFreq:maxFreq,:,:);

PlotCollapsedERPSWithBaseline(condition1FreqMat,condition2FreqMat,conditionName1,conditionName2,timesout,baseTime,statmethod,p_value,prefixFileName,titleName,color1,color2,colorPvalue);
