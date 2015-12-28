function PrintFromFilesConnMatIndices(condition1,condition2,filePrefixes,fileNames,root2write)
%calculates connection indices and prints to file for filenames
fileName = [root2write condition1 '-' condition2 '_ConnIndexes.txt'];

fileID = fopen(fileName,'w');
fprintf(fileID,'%s \n',sprintf('\t%s\t%s', condition1,condition2));

for f = 1 : size(fileNames,2)
    connMat = load(fileNames{1,f});    
    connVals = triu(connMat);

    condition1vals = connVals(connVals>0);
    condition2vals = abs(connVals(connVals<0));

    condition1sumT = sum(condition1vals);
    condition2sumT = sum(condition2vals);

    condition1meanT = mean(condition1vals);
    condition2meanT = mean(condition2vals);

    %TODO add meanT for long and short distances (needs distance matrix)
    
    A = sprintf('sumT_%s \t %.2f \t %.2f',filePrefixes{f},condition1sumT,condition2sumT);
    fprintf(fileID,'%s\n',A);
    
    A = sprintf('meanT_%s \t %.2f\t %.2f',filePrefixes{f},condition1meanT,condition2meanT);
    fprintf(fileID,'%s\n',A);
end

fclose(fileID);
