function [labels,trialsResults] = CalculateROISValuesvsAmygdala(EmpathyForPainStruct,ROIINT,ROIACC,AmygdalaDiff,timeWindow,frequencyIndex,baseTimeWindow,pvalue)
%INT del ROI -> int vs baseline
%INT + ACC del ROI -> int-acc vs baseline
%Amygdala INT - ACC

initFrequencyIndex = frequencyIndex(1);
endFrequencyIndex = frequencyIndex(2);

initTimeIndex = timeWindow(1);
endTimeIndex = timeWindow(2);

initBaseTimeIndex = baseTimeWindow(1);
endBaseTimeIndex = baseTimeWindow(2);

roiNr = size(EmpathyForPainStruct,2);

%meanResults = ones(roiNr,1);
trialsResults = ones(roiNr,1)*4;
%meanFrequTrialsResults = ones(roiNr,1);
%meanTrialsResults = ones(roiNr,1);
labels = {};

for i = 1 : roiNr
%  i = 10;  
    %create labels from struct
    labels{i} = EmpathyForPainStruct(i).name;
    
    %create variables for ROI INT and ACC
    erpsINT = ROIINT(i).erpsByTrial;
    valerpsINT = erpsINT(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);
    meanValueINT = mean(mean(squeeze(mean(valerpsINT,1)),1));
    
    erpsACC = ROIACC(i).erpsByTrial;
    valerpsACC = erpsACC(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);
    meanValueACC = mean(mean(squeeze(mean(valerpsACC,1)),1));
    
    valerpsINTACC = valerpsINT - valerpsACC;
    meanINTACC = mean(mean(squeeze(mean(valerpsINTACC,1)),1));
    
    %INT vs Baseline
    %create INT baseline values
    valerpsINTBase= erpsINT(initFrequencyIndex:endFrequencyIndex,initBaseTimeIndex:endBaseTimeIndex,:);
    meanValueINTBase = mean(mean(squeeze(mean(valerpsINTBase,1)),1));
    
    rvalerpsINT = reshape(valerpsINT,size(valerpsINT,1)*size(valerpsINT,2)*size(valerpsINT,3),1);
    rvalerpsINTBase = reshape(valerpsINTBase,size(valerpsINTBase,1)*size(valerpsINTBase,2)*size(valerpsINTBase,3),1);
    
    [t df pvals] = statcond({rvalerpsINT,rvalerpsINTBase}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
    
    if pvals > pvalue || (pvals < pvalue & meanValueINTBase > meanValueINT)
        trialsResults(i) = 1; %NO DISCRIMINA
    else
        %INT VS ACC
        rvalerpsACC = reshape(valerpsACC,size(valerpsACC,1)*size(valerpsACC,2)*size(valerpsACC,3),1);
        [t df pvals] = statcond({rvalerpsINT,rvalerpsACC}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
        
      if pvals > pvalue || (pvals < pvalue & (meanValueACC > meanValueINT))
            trialsResults(i) = 1; %NO DISCRIMINA
      else       
      
        %INT - ACC vs BASELINE
        valerpsACCBase = erpsACC(initFrequencyIndex:endFrequencyIndex,initBaseTimeIndex:endBaseTimeIndex,:);
        valerpsINTACCBase = valerpsINTBase - valerpsACCBase;
        meanINTACCBase = mean(mean(squeeze(mean(valerpsINTACCBase,1)),1));
                
        rvalerpsINTACC = reshape(valerpsINTACC,size(valerpsINTACC,1)*size(valerpsINTACC,2)*size(valerpsINTACC,3),1);
        rvalerpsINTACCBase = reshape(valerpsINTACCBase,size(valerpsINTACCBase,1)*size(valerpsINTACCBase,2)*size(valerpsINTACCBase,3),1);
        
        [t df pvals] = statcond({rvalerpsINTACC,rvalerpsINTACCBase}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
        
            if pvals > pvalue || (pvals < pvalue & (meanValueACC > meanValueINT || meanINTACCBase >= meanINTACC))
                trialsResults(i) = 1; %NO DISCRIMINA
            else
                %vs Amygdala
                valerpsAmygdalaINTACC = AmygdalaDiff(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);
                meanAmygdalaINTACC = mean(mean(squeeze(mean(valerpsAmygdalaINTACC,1)),1));

                rvalerpsAmygdalaINTACC = reshape(valerpsAmygdalaINTACC,size(valerpsAmygdalaINTACC,1)*size(valerpsAmygdalaINTACC,2)*size(valerpsAmygdalaINTACC,3),1);
                rvalerpsINTACC = reshape(valerpsINTACC,size(valerpsINTACC,1)*size(valerpsINTACC,2)*size(valerpsINTACC,3),1);

                [t df pvals] = statcond({rvalerpsAmygdalaINTACC,rvalerpsINTACC}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones

                if pvals < pvalue & meanAmygdalaINTACC > meanINTACC
                    trialsResults(i) = 0; % Amygdala significativamente mayor 
                else 
                    trialsResults(i) = -1;
                end
            end
      end    
  end
end