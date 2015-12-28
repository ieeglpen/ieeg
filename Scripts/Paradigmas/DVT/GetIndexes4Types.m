function [facesIndexes,wordsIndexes,facesNegativeIndexes,facesPositiveIndexes,wordsNegativeIndexes,wordsPositiveIndexes,positiveIndexes,negativeIndexes] = GetIndexes4Types(file2load)

%load file2load.mat table (log structure from where stimuli type can de discerned)
load(file2load)

facesIndexes = find(table(:,5)==1);
wordsIndexes = find(table(:,5)==0);

positiveIndexes = find(table(:,3)==2 | table(:,4)==8);
negativeIndexes = find(table(:,3)==1 | table(:,4)==7);

facesNegativeIndexes = find(table(:,5)==1 & table(:,3)==1 );
facesPositiveIndexes = find(table(:,5)==1 & table(:,3)==2 );
wordsNegativeIndexes = find(table(:,5)==0 & table(:,4)==7 );
wordsPositiveIndexes = find(table(:,5)==0 & table(:,4)==8 );





