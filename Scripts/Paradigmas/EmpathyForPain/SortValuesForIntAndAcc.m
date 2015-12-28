function [sortedValues] = SortValuesForIntAndAcc(intMap,accMap)

%size intMap and accMap have 11 trials
columnNr = size(intMap,2);
rowNr = 22; %int trials + acc trials

sortedValues = zeros(rowNr,columnNr);

sortedValues(1:3,:) = intMap(1:3,:);
sortedValues(4,:) = accMap(1,:);
sortedValues(5:6,:) = intMap(4:5,:);
sortedValues(7:8,:) = accMap(2:3,:);
sortedValues(9,:) = intMap(6,:);
sortedValues(10:11,:) = accMap(4:5,:);
sortedValues(12,:) = intMap(7,:);
sortedValues(13:14,:) = accMap(6:7,:);
sortedValues(15,:) = intMap(8,:);
sortedValues(16:17,:) = accMap(8:9,:);
sortedValues(18,:) = intMap(9,:);
sortedValues(19:20,:) = accMap(10:11,:);
sortedValues(21:22,:) = intMap(10:11,:);
