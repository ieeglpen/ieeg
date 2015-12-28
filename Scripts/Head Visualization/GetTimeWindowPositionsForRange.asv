function [timeWindowPositions] = GetTimeWindowPositionsForRange(timeVector,timeIntervals)

timeWindowPositions = zeros(size(timeIntervals,1),2);

for i = 1 : size(timeWindowPositions,1)
    
    inittime = timeIntervals(i,1);
    endtime = timeIntervals(i,2);
    initposition = INTERP1(timeVector,1:length(timeVector),inittime,'nearest');
    endPosition = INTERP1(timeVector,1:length(timeVector),endtime,'nearest');
    
    if endPosition > length(timeVector)
        endPosition = length(timeVector);
    end
    
    timeWindowPositions(i,:) = [initposition endPosition];
end
    
    