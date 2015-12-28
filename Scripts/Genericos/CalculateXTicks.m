function [XTickValues XTickPosition] = CalculateXTicks(EjeX,tickPercentage)

%calculate X Ticks
%INPUTS:
%EjeX: Vector to be ticked
%tickPercentage: in decimal format, ej 5% -> 0.05, values ranges from 0 to 1.
totalSize = length(EjeX);

div = totalSize*tickPercentage;

tickNumber = floor(div);
tickStep = floor(totalSize/tickNumber);

XTickValues = zeros(1,tickNumber);
XTickPosition = zeros(1,tickNumber);
for i = 1:tickNumber
    tickValue = tickStep * i;
    XTickPosition(1,i) = tickValue; 
    XTickValues(1,i) = EjeX(1,tickValue);
end