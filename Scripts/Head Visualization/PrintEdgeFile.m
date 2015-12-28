function PrintEdgeFile(fileName,connectionMatrix)

edgeFileName = [fileName '.edge'];
dlmwrite(edgeFileName,connectionMatrix,'delimiter','\t');