function [returnValue] = DoesVectorContainNConsecutiveNrs(vec,N)
%returns 1 if the vector vec contains N consecutive values, 0 if it does
%not
%vec: 1 dim vector of values
%N: nr of consecutive values
consCell = SplitVec(vec,'consecutive');

returnValue = 0;
for l = 1 : size(consCell,2)
    cons = consCell{l};
    if ~isempty(cons)
        if length(cons) >= N
            returnValue = 1;
        end
    end
end