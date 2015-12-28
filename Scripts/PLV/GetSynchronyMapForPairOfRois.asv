function [SynchronyMap] = GetSynchronyMapForPairOfRois(ROIInfo,path2files, EEG, data2process, titlePrefix, Fs,Frange, Fstep,Trange, WinSig, BinFreq,Step)

h = 0; %counter
for i = 1 : size(ROIInfo,2)-1
    for j = i + 1 : size(ROIInfo,2)
        h = h + 1;
        
        SynchronyMap(h).ROI1 = ROIInfo(i).name;
        SynchronyMap(h).ROI2 = ROIInfo(j).name;
        SynchronyMap(h).title = ['PLV Frequency Map - ' titlePrefix ' - ' ROIInfo(i).name '-' ROIInfo(j).name];
        
        %to construct the map of frequencies all channels are needed
        threshold = -1;
        
        EjeY = [];
        completePLV = [];
        counter = 0;
        %for k = Frange(1,1):Fstep:Frange(1,2)
            %counter = counter + 1;        
            %EjeY(counter) = k;
            %fr = [k k+Fstep]
            %[SynchedResults] = SynchBetween2ROIS(ROIInfo(i).channels,ROIInfo(j).channels,path2files, EEG, data2process, Fs,fr, Trange, WinSig, BinFreq,Step,threshold);
            EjeY = Frange;
            [SynchedResults resultDiffRois] = SynchBetween2ROIS(ROIInfo(i).channels,ROIInfo(j).channels,path2files, EEG, data2process, Fs,Frange, Trange, WinSig, BinFreq,Step,threshold);
            %OUTPUT
            %struct containing the PLV Synch between the two ROIs
            %that exceeds the threshold value
            %It contains the following properties:
            %channels: Mx2 vector containing the values of the pair of channels
            %PLV: Mxtx1 matrix where M is the number of pair of channels that exceeded
            %the threshold value, t is the time length and the third dimension is the
            %PLV value
            %time: the values corresponding to the time (x) axis   
            
            %completePLV(counter,:,:) = SynchedResults.PLV;
            
            %meanFreqPLV = mean(SynchedResults.PLV,1);
              
            %normalizing PLV values for frequency
            %window = GetBaselineWindow(SynchedResults.time);
            %[normalizedSignal] = NormalizeSignal(meanFreqPLV, window);
                        
            window = GetBaselineWindow(SynchedResults.time);
            plvmapNorm = Znorm3(resultDiffRois, [window(1,1):window(1,2)], 2);
            plvMap = mean(plvmapNorm,1);
            
            EjeX = SynchedResults.time;
            %plvMap(counter,:) = normalizedSignal; 
            %plvMap(counter,:) = meanFreqPLV; 
        %end
        
        SynchronyMap(h).PLV = plvMap;
        SynchronyMap(h).EjeX = EjeX;
        SynchronyMap(h).EjeY = EjeY;
        SynchronyMap(h).CompletePLV = completePLV;
                       
        %plot
        figure
        imagesc(squeeze(plvMap)')
        title(SynchronyMap(h).title)
        tickPercentage = 0.05;
        [XTickValues XTickPosition] = CalculateXTicks(EjeX,tickPercentage);
        %set(gca,'XTick',[20 40 60 80 100 120 140 160 180] ); 
        %set(gca,'XTickLabel',[EjeX(1,20) EjeX(1,40) EjeX(1,60) EjeX(1,80) EjeX(1,100) EjeX(1,120) EjeX(1,140) EjeX(1,160) EjeX(1,180)]);
        
        set(gca,'XTick',XTickPosition); 
        set(gca,'XTickLabel',XTickValues);
        
        set(gca,'YTick',[1:size(EjeY,2)] );
        %set(gca,'YTickLabel',[EjeY(1,20) EjeY(1,40) EjeY(1,60) EjeY(1,80) EjeY(1,100) EjeY(1,120) EjeY(1,140) EjeY(1,160) EjeY(1,180)]);        
        set(gca,'YTickLabel',EjeY);      
        set(gca,'YDir','normal');
        colorbar
        %caxis([-2 2])
        
        saveas(gcf,SynchronyMap(h).title,'png');
        saveas(gcf,SynchronyMap(h).title,'fig');
    end
end



