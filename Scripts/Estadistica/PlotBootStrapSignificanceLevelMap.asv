function [bootstrapSignficanceLevelMaps, R, Pboot, Rboot, ERP, freqs, timesout, mbase, maskersp, maskitc, g] = PlotBootStrapSignificanceLevelMap(EEG,channels,tlimits,frequencyRange,titleName)

%channels must be a vector with the channels used to calculate the power
%spectrum
typeproc = 1; %deprecated - useless
cycles = 0; %?

bootstrapSignficanceLevelMaps = [];

counter = 0;
for num = channels
    counter = counter + 1;
    %[P,R,mbase,timesout,freqs,Pboot,Rboot,alltfX,PA,ERP,maskersp, maskitc, g] = mypop_newtimef(EEG, typeproc, num, tlimits, cycles, frequencyRange, 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1 );
    [P,R,mbase,timesout,freqs,Pboot,Rboot,alltfX,PA,ERP,maskersp, maskitc, g] = mypop_newtimef(EEG, typeproc, num, tlimits, cycles, frequencyRange, 'baseline',[0], 'alpha',0.05,'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1 );                                                                                
    bootstrapSignficanceLevelMaps(:,:,counter) = Pboot;
end

meanbootstrapSignficanceLevelMaps = mean(bootstrapSignficanceLevelMaps,3);

plottimef(titleName,squeeze(meanERPSMaps), R, Pboot, Rboot, ERP, freqs, timesout, mbase, maskersp, maskitc, g);

meanERPSMaps = squeeze(meanERPSMaps);