function [selectedChanPairsIndexes] = GetChanPairsOfVals(edgefile,condition)

%return a list of channel pairs (matrix indexes) of an edgefile
%condition: 1 -> positive values
%condition: -1 -> negative values
%condition: 0 -> positive AND negative values

mat = load(edgefile);

mat_triu = triu(mat); %upper triangle
mat_triu(logical(eye(size(mat_triu)))) = 0; %set diagonal values to zero

switch condition
    case 1
        %positive values
        [row1,col1] = find(mat_triu > 0);
    case -1
        %negative values
        [row1,col1] = find(mat_triu < 0);
    case 0
        %values different to 0
        [row1,col1] = find(mat_triu ~= 0);
end

selectedChanPairsIndexes = sub2ind(size(mat_triu), row1, col1);

