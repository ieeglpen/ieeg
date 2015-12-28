function [selectedChanPairs] = GetChanPairsOfValsNotZero(root,prefix,condition1,condition2,suffix)

cond1 = load([root prefix condition1 suffix]);

cond1_triu = triu(cond1); %upper triangle
cond1_triu(logical(eye(size(cond1_triu)))) = 0; %set diagonal values to zero
[row1,col1] = find(cond1_triu ~= 0);
linearInds1 = sub2ind(size(cond1_triu), row1, col1);

cond2 = load([root prefix condition2 suffix]);
cond2_triu = triu(cond2); %upper triangle
cond2_triu(logical(eye(size(cond2_triu)))) = 0; %set diagonal values to zero
[row2,col2] = find(cond2_triu ~= 0);
linearInds2 = sub2ind(size(cond2_triu), row2, col2);

uniqueInds = union(linearInds1,linearInds2);
[row,col] = ind2sub(size(cond1_triu),uniqueInds);

selectedChanPairs = [row col];
