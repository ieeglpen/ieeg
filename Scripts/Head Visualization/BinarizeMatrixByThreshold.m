function binarizedMatrix = BinarizeMatrixByThreshold(matrix, threshold)

rows = size(matrix,1);
columns = size(matrix,2);

binarizedMatrix = zeros(rows,columns);

for i = 1 : rows
    for j = 1 : columns
        if matrix(i,j) >= threshold
            binarizedMatrix(i,j) = 1;
        end
    end
end

        