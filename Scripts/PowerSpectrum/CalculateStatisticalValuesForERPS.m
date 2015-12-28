function CalculateStatisticalValuesForERPS(totalERPSCondition1,totalERPSCondition2,roiStruct,conditionNames,conditionFreqs,freqs,p_value,statmethod,fileName)

roiNr = size(roiStruct,2);

results = [];

for i = 1 : roiNr

    i
    roiERPSCondition1 = totalERPSCondition1(i).erpsByTrial;
    roiERPSCondition2 = totalERPSCondition2(i).erpsByTrial;
    
    
    for j = 1 : size(conditionNames,2)
        conditionNames{j}
        minFreq = floor(interp1(freqs,1:size(freqs,2),conditionFreqs(j,1)));
        maxFreq = floor(interp1(freqs,1:size(freqs,2),conditionFreqs(j,2)));
        
        condition1FreqMat = roiERPSCondition1(minFreq:maxFreq,:,:);
        condition2FreqMat = roiERPSCondition2(minFreq:maxFreq,:,:);
    
        [indexes pvals t df] = GetSignificantTimeValues(condition1FreqMat,condition2FreqMat,p_value,statmethod);
               
        str2eval = ['results(i).' conditionNames{j} '.indexes = indexes;'];
        eval(str2eval);
        
        str2eval = ['results(i).' conditionNames{j} '.pvals = pvals;'];
        eval(str2eval);
        
        str2eval = ['results(i).' conditionNames{j} '.t = t;'];
        eval(str2eval);
        
        str2eval = ['results(i).' conditionNames{j} '.df = df;'];
        eval(str2eval);
        
    end
    
end

savestr2eval = ['save ' fileName '.mat results;'];
eval(savestr2eval);

