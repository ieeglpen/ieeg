function [signalSpectrogram,T] = CalculateFrequencyRangeSpectrogram(signal,windowRange)

initRange = windowRange(1,1);
endRange = windowRange(1,2);

[S,F,T,P] = spectrogram(double(signal),hamming(8),1,512,1024);

Y = 1:size(F,1);
X = F;

initIndex = floor(interp1(X,Y,initRange));
endIndex = ceil(interp1(X,Y,endRange));
foiSpectrogram = P(initIndex:endIndex,:);

signalSpectrogram = mean(foiSpectrogram,1);