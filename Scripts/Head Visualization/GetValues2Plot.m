function values2Plot = GetValues2Plot(signal,timeWindowColumns,threshold)

timeWindowResult = signal(:,timeWindowColumns(1):timeWindowColumns(2));
timeWindowMeanResult = mean(timeWindowResult,2);

binarizedVector = BinarizeMatrixByThreshold(timeWindowMeanResult, threshold);

values2Plot = find(binarizedVector == 1);