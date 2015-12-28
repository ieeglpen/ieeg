function measureMat = CalculateGraphMeasure75PercBinThreshold(graphMeasure,connMat)

for trialCond = 1 : size(connMat,3)
            %calculate degree
            %quartile superior 25
            mat = connMat(:,:,trialCond);
            threshold = quantile(mat(:), 0.75);  
            %binarize data
            binmat = mat;
            binmat(binmat < threshold) = 0;
            binmat(binmat ~= 0) = 1;             
            %calculate graph Measure
            switch graphMeasure
                case 'degree'
                    measureMat(trialCond,:) = degrees_und(binmat);
                case 'betweenness'
                    measureMat(trialCond,:) = betweenness_bin(binmat);
                case 'clustering'
                    measureMat(trialCond,:) = clustering_coef_bu(binmat);
                case 'pathlength'
                    D=distance_bin(binmat);
                    lambda=charpath(D);
                    measureMat(trialCond,1) = lambda;
%                 case 'closenesscentrality'
%                     measureMat(trialCond) = 1;
%                 case 'smallworld'              
%                     measureMat(trialCond) = 1;
            end
end