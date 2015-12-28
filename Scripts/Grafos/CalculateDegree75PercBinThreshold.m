function degree = CalculateDegree75PercBinThreshold(connMat)
%calculates the degree by trial of a 3D connectivity matrix

for trialCond = 1 : size(connMat,3)
            %calculate degree
            %quartile superior 25
            mat = connMat(:,:,trialCond);
            threshold = quantile(mat(:), 0.75);  
            %binarize data
            binmat = mat;
            binmat(binmat < threshold) = 0;
            binmat(binmat ~= 0) = 1; 
            %paraEze(:,:,trialCond1) = binmat1;
            %calculate degree
            degree(trialCond,:) = degrees_und(binmat);
end