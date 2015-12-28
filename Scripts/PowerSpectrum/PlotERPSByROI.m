function [erpsMapsByTrialByROIs,erpsByROIs, meanERPSMap, R, Pboot, Rboot, ERP, freqs, timesout, mbase, maskersp, maskitc, g,PboottrialsByROI] = PlotERPSByROI(patientROI,EEG,tlimits,frequencyRange,alpha,fdrCorrect,titleName,weightedSignificance,surroundingsWeight)
%function [erpsByROIs, meanERPSMap, R, Pboot, Rboot, ERP, freqs, timesout,
%mbase, maskersp, maskitc, g] = PlotERPSByROI(patientROI,EEG,tlimits,frequencyRange,titleName)

erpsByROIs = [];
PboottrialsByROI = [];

for i = 1 : size(patientROI,2)
    plotTitleName = [titleName ' - ' patientROI(i).name];
    channels = patientROI(i).channels;
    [erpsMapsByTrial meanERPSMap, R, Pboot, Rboot, ERP, freqs, timesout, mbase, maskersp, maskitc, g,Pboottrials] = PlotERPSMap(EEG,channels,tlimits,frequencyRange,alpha,fdrCorrect,plotTitleName,weightedSignificance,surroundingsWeight);
    erpsByROIs(i,:,:) = meanERPSMap;
    erpsMapsByTrialByROIs(i).erpsByTrial = erpsMapsByTrial;
    PboottrialsByROI(i).pboot = Pboottrials;
end

