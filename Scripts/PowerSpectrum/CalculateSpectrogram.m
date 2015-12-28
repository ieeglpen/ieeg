function [completeSpectrogram] = CalculateSpectrogram(signal,windowRange)
%Calculates spectrogram for each row in signal,creates a matrix with
%windowRange * rows and then calculates the mean.

initRange = windowRange(1,1);
endRange = windowRange(1,2);
range = endRange - initRange + 1;

for i = 1 : size(signal,1)
        
    initMIndex = 0
    endMIndex = 0
    
    for j = 1 : size(signal,3)
            
        %by trial
        [S,F,T,P] = spectrogram(double(signal(i,:,:)),hamming(8),1,512,1024);

        Y = 1:size(F,1);
        X = F;

        initIndex = floor(interp1(X,Y,initRange))
        endIndex = ceil(interp1(X,Y,endRange))
        
        initMIndex = endMIndex + 1
        endMIndex = endMIndex + endIndex - initIndex + 1
                
        size(P)
        temp(initMIndex:endMIndex,:) = P(initIndex:endIndex,:);
    
        
    end
    size(temp)
    
    completeSpectrogram(i,:) = mean(temp,1);
    
    initMIndex = 1;
    endMIndex = endRange - initRange;
    
end

