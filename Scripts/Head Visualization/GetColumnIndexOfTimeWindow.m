function [timeWindow] = GetColumnIndexOfTimeWindow(timeVector,initTime,endTime)

initIndex = 0;
endIndex = 0;

halfStep = (timeVector(2)- timeVector(1))/2;

initTimeAssigned = 0;
endTimeAssigned = 0;

for i = 1: length(timeVector)
    currentTimeValue = timeVector(i);
    if initTimeAssigned == 0        
        if initTime >= currentTimeValue - halfStep && initTime <= currentTimeValue + halfStep
            initIndex =  i;
            initTimeAssigned = 1;
        end
    else
        if endTime >= currentTimeValue - halfStep && endTime <= currentTimeValue + halfStep
            endIndex = i;
            endTimeAssigned = 1;
        end
    end
end

if endTimeAssigned == 0
    endIndex = length(timeVector);
end

timeWindow = [initIndex endIndex];