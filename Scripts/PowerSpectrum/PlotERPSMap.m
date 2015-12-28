function [erpsMapsByTrial, meanERPSMaps, R, Pboot, Rboot, ERP, freqs, timesout, mbase, maskersp, maskitc, g,Pboottrialsmean] = PlotERPSMap(EEG,channels,tlimits,frequencyRange,alpha,fdrCorrect,titleName,weightedSignificance,surroundingsWeight)

%channels must be a vector with the channels used to calculate the power
%spectrum
typeproc = 1; %deprecated - useless
cycles = 0; %?

erpsMaps = [];
erpsMapsByTrial = [];
Pboottrialstotal = []; 
counter = 0;
for num = channels
    counter = counter + 1;
    [P,R,mbase,timesout,freqs,Pboot,Rboot,alltfX,PA,ERP,maskersp, maskitc, g,Pboottrials] = mypop_newtimef(EEG, typeproc, num, tlimits, cycles, frequencyRange,alpha,fdrCorrect, 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1,'mcorrect','fdr','scale','log' );
                                                                                                                                                     %pop_newtimef(EEG, 1, canal, epoch_window*1000 + [0 100], [3 0.5] , 'alpha',0.05, 'freqs', [0 150], 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1);
    erpsMaps(:,:,counter) = P;
    if ~isempty(Pboottrials)
        Pboottrialstotal(:,:,counter) = Pboottrials;
    end
    erpsMapsByTrial = cat(3,erpsMapsByTrial,PA);
end

meanERPSMaps = mean(erpsMaps,3);
Pboottrialsmean = mean(Pboottrialstotal,3);

if weightedSignificance == 1
    exactp_ersp = mycompute_pvals(meanERPSMaps, Pboottrialsmean);
    significantMatrix = exactp_ersp;
    [weightedSignificantMatrixMask weightedSignificantMatrix] = CalculateWeightedSignificantMatrix(alpha,significantMatrix,surroundingsWeight);
    maskersp = weightedSignificantMatrixMask;
end
ERP = zeros(1535,1);
myplottimef(titleName,squeeze(meanERPSMaps), R, Pboot, Rboot, ERP, freqs, timesout, mbase, maskersp, maskitc, g);

meanERPSMaps = squeeze(meanERPSMaps);