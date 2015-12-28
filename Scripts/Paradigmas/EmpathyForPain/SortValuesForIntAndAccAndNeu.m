function [sortedValues] = SortValuesForIntAndAccAndNeu(intMap,accMap,neuMap)

%size intMap and accMap have 11 trials
columnNr = size(intMap,2);
rowNr = 25; %int trials + acc trials + neu trials

sortedValues = zeros(rowNr,columnNr);

sortedValues(1:3,:) = intMap(1:3,:);
sortedValues(4,:) = accMap(1,:);
sortedValues(5,:) = intMap(4,:);
sortedValues(6,:) = neuMap(1,:);
sortedValues(7,:) = intMap(5,:);
sortedValues(8:9,:) = accMap(2:3,:);
sortedValues(10,:) = intMap(6,:);
sortedValues(11:12,:) = accMap(4:5,:);
sortedValues(13,:) = intMap(7,:);
sortedValues(14:15,:) = accMap(6:7,:);
sortedValues(16,:) = neuMap(2,:);
sortedValues(17,:) = intMap(8,:);
sortedValues(18:19,:) = accMap(8:9,:);
sortedValues(20,:) = intMap(9,:);
sortedValues(21:22,:) = accMap(10:11,:);
sortedValues(23,:) = neuMap(3,:);
sortedValues(24:25,:) = intMap(10:11,:);