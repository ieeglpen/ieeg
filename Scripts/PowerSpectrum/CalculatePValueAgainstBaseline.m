function [t,pvals,meanbaselineValue,meantimeWindowValue] = CalculatePValueAgainstBaseline(erps,frequencyIndex,baselineIndex,timeWindowIndex)
%INPUTS
%erps: matrix containing the frequency maps by trial
%       erps must be 3D: 
%                   dim 1: frequency bins
%                   dim 2: time bins
%                   dim 3: trials

%frequencyIndex: is a two value vector that indicates time indeces for
%               the beginning and end of the frequency range
%               [initFrequencyIndex endFrequencyIndex]
%baselineIndex: is a two value vector that indicates time indeces for 
%               the beginning and end of the baseline 
%               [initBaselineIndex endBaselineIndex]
%timeWindowIndex: is a two value vector that indicates time indeces for
%               the beginning and end of the timeWindow
%               [initTimeWindow endTimeWindow]

%OUTPUTS
%t: resulting t value from the comparison between baseline and time window
%   a positive t value indicates that timeWindow is predominant over
%   baseline
%pvals: resulting p-value from the bootstrap/permutation comparison between
%       baseline and time window
%meanbaselineValue: mean value averaged over frequency range, baseline and
%                   trials
%meantimeWindowValue: mean value averaged over frequency range, time window
%                     and trials

%Frequency
initFrequencyIndex = frequencyIndex(1);
endFrequencyIndex = frequencyIndex(2);
map = erps(initFrequencyIndex:endFrequencyIndex,:,:);
%mean frequency
meanFreqMap = squeeze(mean(map,1));

%Baseline
initBaselineIndex = baselineIndex(1);
endBaselineIndex = baselineIndex(2);
baseline = meanFreqMap(initBaselineIndex:endBaselineIndex,:);
%mean baseline
mbaseline = mean(baseline,1); 
%reshape baseline
%rbaseline = reshape(baseline,size(baseline,1)*size(baseline,2)*size(baseline,3),1);
rbaseline = reshape(baseline,size(baseline,1)*size(baseline,2),1);
%mean value for baseline
meanbaselineValue = mean(mbaseline);

%TimeWindow
initTimeWindow = timeWindowIndex(1);
endTimeWindow = timeWindowIndex(2);
%timeWindow = map(:,initTimeWindow:endTimeWindow,:);
timeWindow = meanFreqMap(initTimeWindow:endTimeWindow,:);
%mean time window
mtimeWindow = mean(timeWindow,1);
%reshape baseline
%rtimeWindow = reshape(timeWindow,size(timeWindow,1)*size(timeWindow,2)*size(timeWindow,3),1);
rtimeWindow = reshape(timeWindow,size(timeWindow,1)*size(timeWindow,2),1);
%mean value for time window
meantimeWindowValue = mean(mtimeWindow);

%statistical comparison between baseline and time window
%Permut = {mbaseline,mtimeWindow};
Permut = {rbaseline,rtimeWindow};

[t df pvals] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
%[t df pvals] = statcond(Permut, 'mode', 'perm','paired','off','tail','both','naccu',1000);   %calcula permutaciones   

