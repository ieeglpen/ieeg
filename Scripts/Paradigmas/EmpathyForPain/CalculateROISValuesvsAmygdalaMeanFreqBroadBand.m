function [labels,trialsResults] = CalculateROISValuesvsAmygdalaMeanFreqBroadBand(EmpathyForPainStruct,ROIINT,ROIACC,AmygdalaDiff,timeWindow,frequencyIndex,baseTimeWindow,pvalue)
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
    valerpsINT = squeeze(mean(valerpsINT,1));
    
    erpsACC = ROIACC(i).erpsByTrial;
    valerpsACC = erpsACC(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);
    meanValueACC = mean(mean(squeeze(mean(valerpsACC,1)),1));
    valerpsACC = squeeze(mean(valerpsACC,1));
    
    valerpsINTACC = valerpsINT - valerpsACC;
    meanINTACC = mean(squeeze(mean(valerpsINTACC,1)));
    
    %INT vs Baseline
    %create INT baseline values
    valerpsINTBase= erpsINT(initFrequencyIndex:endFrequencyIndex,initBaseTimeIndex:endBaseTimeIndex,:);
    meanValueINTBase = mean(mean(squeeze(mean(valerpsINTBase,1)),1));
    valerpsINTBase = squeeze(mean(valerpsINTBase,1));
    
    rvalerpsINT = reshape(valerpsINT,size(valerpsINT,1)*size(valerpsINT,2),1);
    rvalerpsINTBase = reshape(valerpsINTBase,size(valerpsINTBase,1)*size(valerpsINTBase,2),1);
    
    [t df pvals] = statcond({rvalerpsINT,rvalerpsINTBase}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
    
    if pvals > pvalue || (pvals < pvalue & meanValueINTBase > meanValueINT)
        trialsResults(i) = 1; %NO DISCRIMINA
    else
        %INT VS ACC
        rvalerpsACC = reshape(valerpsACC,size(valerpsACC,1)*size(valerpsACC,2),1);
        [t df pvals] = statcond({rvalerpsINT,rvalerpsACC}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
        
      if pvals > pvalue || (pvals < pvalue & (meanValueACC > meanValueINT))
            trialsResults(i) = 1; %NO DISCRIMINA
      else       
      
        %INT - ACC vs BASELINE
        valerpsACCBase = erpsACC(initFrequencyIndex:endFrequencyIndex,initBaseTimeIndex:endBaseTimeIndex,:);                
        valerpsACCBase = squeeze(mean(valerpsACCBase,1));
        valerpsINTACCBase = valerpsINTBase - valerpsACCBase;
        meanINTACCBase = mean(squeeze(mean(valerpsINTACCBase,1)));
                
        rvalerpsINTACC = reshape(valerpsINTACC,size(valerpsINTACC,1)*size(valerpsINTACC,2),1);
        rvalerpsINTACCBase = reshape(valerpsINTACCBase,size(valerpsINTACCBase,1)*size(valerpsINTACCBase,2),1);
        
        [t df pvals] = statcond({rvalerpsINTACC,rvalerpsINTACCBase}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
        
            if pvals > pvalue || (pvals < pvalue & (meanValueACC > meanValueINT || meanINTACCBase >= meanINTACC))
                trialsResults(i) = 1; %NO DISCRIMINA
            else
                %vs Amygdala
                valerpsAmygdalaINTACC = AmygdalaDiff(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);
                meanAmygdalaINTACC = mean(mean(squeeze(mean(valerpsAmygdalaINTACC,1)),1));
                valerpsAmygdalaINTACC = squeeze(mean(valerpsAmygdalaINTACC,1));

                rvalerpsAmygdalaINTACC = reshape(valerpsAmygdalaINTACC,size(valerpsAmygdalaINTACC,1)*size(valerpsAmygdalaINTACC,2),1);
                rvalerpsINTACC = reshape(valerpsINTACC,size(valerpsINTACC,1)*size(valerpsINTACC,2),1);

                [t df pvals] = statcond({rvalerpsAmygdalaINTACC,rvalerpsINTACC}, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones

                if pvals < pvalue & meanAmygdalaINTACC > meanINTACC
                    trialsResults(i) = 0; % Amygdala significativamente mayor 
                else 
                                        %nombre de las variables no representan lo que son,
                    %solo por utilidad
                    timeWindowSize = endTimeIndex - initTimeIndex + 1;
                    broadband2INT = erpsINT(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);    
                    broadband2ACC = erpsACC(initFrequencyIndex:endFrequencyIndex,initTimeIndex:endTimeIndex,:);    
                    
                    pbroadband2INT = permute(broadband2INT,[2 3 1]);
                    rbroadband2INT = reshape(pbroadband2INT,timeWindowSize,size(broadband2INT,3)*size(broadband2INT,1));

                    pbroadband2ACC = permute(broadband2ACC,[2 3 1]);
                    rbroadband2ACC = reshape(pbroadband2ACC,timeWindowSize,size(broadband2ACC,3)*size(broadband2ACC,1));

                    Permut{1}=rbroadband2INT;                         % transforma las variables en cellarray
                    Permut{2}=rbroadband2ACC;                         % transforma las variables en cellarray

                     [t df pvals] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
                     [i_ind y]=find(pvals<pvalue);
                     i_ind = i_ind(i_ind > 40); %valor harcodeado de cero - no incluyo lo significativo del baseline
                     
                     if size(i_ind,2) < 6 %valor hardcodeado de lo que es significativo para broadband
                         trialsResults(i) = -1;
                     else
%                          %los valores significativos debieran de ser
%                          %consecutivos
%                          result = 1;
%                          for sig = 1 : size(i_ind,2) - 1
%                              diff = i_ind(sig + 1) - i_ind(sig);
%                              if diff ~= 1
%                                  result= 0;
%                              end
%                          end
%                          
%                          if result == 0
%                              trialsResults(i) = -1;
%                          else
                            trialsResults(i) = -2;
                         end
                     end
                end
            end
      end    
  end
end