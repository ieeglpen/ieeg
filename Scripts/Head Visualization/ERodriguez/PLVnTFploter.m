function     ok = PLVnTFploter(filename, PlotingFormat, norm, climits)

% PLVnTFploter(filename, PlotingFormat, norm) 
% Plots the grand average Time-Frequency charts of
% gamma power and synchrony.
%
% filename  : Name of the result file.
%
% PlotingFormat : plots either 'global' (averaged) charts
%                 or a 'matrix' of charts for each electrode
%
% norm      : Z normalize? choose between   'norm' or 'brut'
%
% climits   : color scale limits, is either a 2 components vector or 'auto'
%
% eg:     
%         PLVnTFploter('RESULTSHUF13_60_5121_Apple_as_Sample_csap.mat','matrix','norm',[-5 5])
%         PLVnTFploter('RESULTSHUF13_60_5121_Apple_as_Sample_csap.mat','matrix','brut','auto')
%

filename
filename2 = strrep(filename,'_','-');
filename2
load(filename)
LimEjesX =[min(ejesX) max(ejesX)];
LimEjesY =[min(ejesY) max(ejesY)];
whos
switch PlotingFormat
case 'global' % PLOTS AVERAGE CHARTS
    switch norm
    case 'norm'  % PLOT NORMALIZED DATA
        if exist('MATSYNCHRO')==1 % Plot Phase locking if the required matrix exist
            % Indexes of the baseline
            YI = INTERP1(ejesX,[1:length(ejesX)],BaseLine,'nearest');
            MATSYNCHRO = Znorm3(MATSYNCHRO,[YI(1):YI(2)],2);
            figure
            ChartPlotter(ejesX,ejesY,squeeze(mean(MATSYNCHRO,1))',LimEjesX,LimEjesY,['Z Phase Synchrony of ',filename2],climits)
        end
        
        if exist('ZTIMEFREQ')==1 % Plot Spectral power if the required matrix exist
            figure
            ChartPlotter(ejesX,ejesY,squeeze(mean(ZTIMEFREQ,1))',LimEjesX,LimEjesY,['Z Spectral Power of ',filename2],climits)
        end
    case 'brut' % PLOT BRUT DATA
        if exist('MATSYNCHRO')==1 % Plot Phase locking if the required matrix exist
            figure
            %ChartPlotter(ejesX,ejesY,squeeze(mean(MATSYNCHRO,1))',LimEjesX,LimEjesY,['Brut Phase Synchrony of ',filename2],[0 1])
            ChartPlotter(ejesX,ejesY,squeeze(mean(MATSYNCHRO,1))',LimEjesX,LimEjesY,['Brut Phase Synchrony of ',filename2],climits)    
        end
    
        if exist('SHUFSYNCHRO')==1 % Plot SHUFFLED Phase locking if the required matrix exist
            figure
            %ChartPlotter(ejesX,ejesY,squeeze(mean(SHUFSYNCHRO,1))',LimEjesX,LimEjesY,['Brut Shuffled Synchrony of ',filename2],[0 1])
            ChartPlotter(ejesX,ejesY,squeeze(mean(SHUFSYNCHRO,1))',LimEjesX,LimEjesY,['Brut Shuffled Synchrony of ',filename2],climits)
        end
    
        if exist('TIMEFREQ')==1 % Plot Spectral power if the required matrix exist
            figure
            ChartPlotter(ejesX,ejesY,squeeze(mean(TIMEFREQ,1))',LimEjesX,LimEjesY,['Brut Spectral Power of ',filename2],climits)
        end    
    end
    
    
case 'matrix'% PLOTS A CHART FOR EACH ELECTRODE
    switch norm
    case 'norm'  % PLOT NORMALIZED DATA
        if exist('MATSYNCHRO')==1 % Plot Phase locking if the required matrix exist
            % Indexes of the baseline
            YI = INTERP1(ejesX,[1:length(ejesX)],BaseLine,'nearest');
            MATSYNCHRO = Znorm3(MATSYNCHRO,[YI(1):YI(2)],2);
            
            % How many electrodes 'nelecs' gave rise to MATSYNCHRO
            [I, nelecs] = FindInParelec(1, length(ParElec));
            for j = 1 : nelecs
            if rem(j-1,16)==0 ; figure; set(gcf, 'Position',  [10 50 1000 650] );end
            [V, trash] = FindInParelec(j, length(ParElec));
            subplot(4,4,rem(j-1,16)+1)
            ChartPlotter(ejesX,ejesY,squeeze(mean(MATSYNCHRO(V,:,:),1))',LimEjesX,LimEjesY,['Z Phase Synchrony '],climits)
            end
        end
        
        if exist('ZTIMEFREQ')==1 % Plot Spectral power if the required matrix exist
            
                for j = 1 : nelecs
                if rem(j-1,16)==0 ; figure;set(gcf, 'Position',  [10 50 1000 650] ) ;end
                subplot(4,4,rem(j-1,16)+1)
                ChartPlotter(ejesX,ejesY,squeeze(ZTIMEFREQ(j,:,:))',LimEjesX,LimEjesY,['Z Spectral Power '],climits)
                end
             
        end
    case 'brut' % PLOT BRUT DATA
        if exist('MATSYNCHRO')==1 % Plot Phase locking if the required matrix exist
            % How many electrodes 'nelecs' gave rise to MATSYNCHRO
            [I, nelecs] = FindInParelec(1, length(ParElec));
            for j = 1 : nelecs
                if rem(j-1,16)==0 ; figure;set(gcf, 'Position',  [10 50 1000 650] ) ;end
                [V, trash] = FindInParelec(j, length(ParElec));
                subplot(4,4,rem(j-1,16)+1)
                ChartPlotter(ejesX,ejesY,squeeze(mean(MATSYNCHRO(V,:,:),1))',LimEjesX,LimEjesY,['Brut Phase Synchrony '],[0 1])
            end
        end
    
        if exist('SHUFSYNCHRO')==1 % Plot SHUFFLED Phase locking if the required matrix exist
            % How many electrodes 'nelecs' gave rise to MATSYNCHRO
            [I, nelecs] = FindInParelec(1, length(ParElec));
            for j = 1 : nelecs
                if rem(j-1,16)==0 ; figure;set(gcf, 'Position',  [10 50 1000 650] ) ;end
                [V, trash] = FindInParelec(j, length(ParElec));
                subplot(4,4,rem(j-1,16)+1)
                ChartPlotter(ejesX,ejesY,squeeze(mean(SHUFSYNCHRO(V,:,:),1))',LimEjesX,LimEjesY,['Brut Shuffled Synchrony '],[0 1])
            end
        end
    
        if exist('TIMEFREQ')==1 % Plot Spectral power if the required matrix exist
            for j = 1 : nelecs
                if rem(j-1,16)==0 ; figure;set(gcf, 'Position',  [10 50 1000 650] ) ;end
                subplot(4,4,rem(j-1,16)+1)
                ChartPlotter(ejesX,ejesY,squeeze(TIMEFREQ(j,:,:))',LimEjesX,LimEjesY,['Brut Spectral Power '],climits)
            end

        end    
    end
    
    
otherwise
    error(['aceptable values for ''PlotFormat'' are either ''global'' or ''matrix'''])
end