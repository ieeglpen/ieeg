function PlotERPSFor3ConditionsAndDifference(fileName,filePath,cond1,cond2,cond3,condname1,condname2,condname3,prefix2save, path2save,roiStruct,tlimits,cycles,frequencyRange,alpha,fdrCorrect,weightedSignificance,surroundingsWeight,scale,tlimitsForBaseline,basenorm,erpsmax,marktimes)
%ERPS FOR FACES AND WORDS (+ DIFF)
%eeglab needs to be loaded already

%Condition1
%load EEG
EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );
EEG.data = cond1;

%calculate ERPS
titleName = [path2save prefix2save '-' condname1];
[erpsMapsByTrialByROIsCond1,erpsByROIsCond1, meanERPSMapCond1, RCond1, PbootCond1, RbootCond1, ERPCond1, freqsCond1, timesoutCond1, mbaseCond1, maskerspCond1, maskitcCond1, gCond1,PboottrialsCond1] = PlotERPSByROI2(roiStruct,EEG,tlimits,cycles,frequencyRange,alpha,fdrCorrect,titleName,weightedSignificance,surroundingsWeight,scale,tlimitsForBaseline,basenorm,erpsmax,marktimes);        
%save outputs
eval(['save ' titleName 'ERPS.mat erpsMapsByTrialByROIsCond1 erpsByROIsCond1']);   
eval(['save ' titleName 'ERPSOutputs.mat freqsCond1 timesoutCond1 mbaseCond1 gCond1']); 


%Condition2
%load EEG
EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );
EEG.data = cond2;

%calculate ERPS
titleName = [path2save prefix2save '-' condname2];
[erpsMapsByTrialByROIsCond2,erpsByROIsCond2, meanERPSMapCond2, RCond2, PbootCond2, RbootCond2, ERPCond2, freqsCond2, timesoutCond2, mbaseCond2, maskerspCond2, maskitcCond2, gCond2,PboottrialsCond2] = PlotERPSByROI2(roiStruct,EEG,tlimits,cycles,frequencyRange,alpha,fdrCorrect,titleName,weightedSignificance,surroundingsWeight,scale,tlimitsForBaseline,basenorm,erpsmax,marktimes);        

eval(['save ' titleName 'ERPS.mat erpsMapsByTrialByROIsCond2 erpsByROIsCond2']);   
eval(['save ' titleName 'ERPSOutputs.mat freqsCond2 timesoutCond2 mbaseCond2 gCond2']); 

%Condition3
%load EEG
EEG = pop_loadset('filename',fileName,'filepath',filePath);
EEG = eeg_checkset( EEG );
EEG.data = cond3;

%calculate ERPS
titleName = [path2save prefix2save '-' condname3];
[erpsMapsByTrialByROIsCond3,erpsByROIsCond3, meanERPSMapCond3, RCond3, PbootCond3, RbootCond3, ERPCond3, freqsCond3, timesoutCond3, mbaseCond3, maskerspCond3, maskitcCond3, gCond3,PboottrialsCond3] = PlotERPSByROI2(roiStruct,EEG,tlimits,cycles,frequencyRange,alpha,fdrCorrect,titleName,weightedSignificance,surroundingsWeight,scale,tlimitsForBaseline,basenorm,erpsmax,marktimes);        

eval(['save ' titleName 'ERPS.mat erpsMapsByTrialByROIsCond3 erpsByROIsCond3']);   
eval(['save ' titleName 'ERPSOutputs.mat freqsCond3 timesoutCond3 mbaseCond3 gCond3']); 


%Diff: 1 - 2 
file2SaveName = [prefix2save '-' condname1 '-' condname2];
PlotERPSForDiffConditions(erpsByROIsCond1,erpsByROIsCond2,file2SaveName,path2save,gCond2,PbootCond2,ERPCond2,mbaseCond2,freqsCond2,timesoutCond2,roiStruct);

%Diff: 1 - 3 
file2SaveName = [prefix2save '-' condname1 '-' condname3];
PlotERPSForDiffConditions(erpsByROIsCond1,erpsByROIsCond3,file2SaveName,path2save,gCond3,PbootCond3,ERPCond3,mbaseCond3,freqsCond3,timesoutCond3,roiStruct);

%Diff: 2 - 3 
file2SaveName = [prefix2save '-' condname2 '-' condname3];
PlotERPSForDiffConditions(erpsByROIsCond2,erpsByROIsCond3,file2SaveName,path2save,gCond2,PbootCond2,ERPCond2,mbaseCond2,freqsCond2,timesoutCond2,roiStruct);
