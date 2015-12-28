function [timeWindowPositions] = GetTimeWindowPositions(timeVector,initTime,timeInterval)

boxSize = timeVector(2)-timeVector(1);

if timeInterval < boxSize
    error(['time interval is smaller than resolution: ' num2str(boxSize)])
end

initTimePosition = INTERP1(timeVector,1:length(timeVector),initTime,'nearest');

%calculate total duration of time window
initTimeValue = timeVector(initTimePosition) - boxSize/2;
endTimeValue = timeVector(end) + boxSize/2;

%calculte into how many steps must the total signal must be divided into
timeWindowValue = endTimeValue - initTimeValue;
timeWindowSteps = round(timeWindowValue / timeInterval);

%calculate how many time columns must be included in each step
columnNr = round(timeInterval / boxSize);

timeWindowPositions = zeros(timeWindowSteps,2);

for i = 1 : length(timeWindowPositions)
    time = initTime + timeInterval*(i-1);
    position = INTERP1(timeVector,1:length(timeVector),time,'nearest');
    
    intEndPosition = position + columnNr;
    if intEndPosition > length(timeVector)
        intEndPosition = length(timeVector);
    end
    
    timeWindowPositions(i,:) = [position intEndPosition];
end
    
    