function [completeSignalSpectrogram,T] = CalculateSpectrogramForChannels(signal,windowRange)

for i = 1 : size(signal,1)
    data = mean(squeeze(signal(i,:,:)),2);
    [signalSpectrogram,T] = CalculateFrequencyRangeSpectrogram(data,windowRange);
    completeSignalSpectrogram(i,:) = signalSpectrogram;
end
    