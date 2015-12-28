function CreateEdgeFileAndConnectionList(mat,Tmax,Tmin,labels,titleName)

chanNr = size(mat,1);

%plot files for BrainNetViewer
threshold = Tmax;

binarizedMatrixTMax = mat;
binarizedMatrixTMax(binarizedMatrixTMax < threshold) = 0;
binarizedMatrixTMax(binarizedMatrixTMax ~= 0) = 1;

% signifMatrixMax = binarizedMatrixTMax.*pmask;
% signifMatrixMax2print = GetWeightedEdgeMatrixForBrainNetViewer(signifMatrixMax,pvalue);
% signifMatNameFile = [titleName 'Max'];
% PrintEdgeFile(signifMatNameFile,signifMatrixMax2print);

%plot files for BrainNetViewer
threshold = Tmin;

binarizedMatrixTMin = mat;
binarizedMatrixTMin(binarizedMatrixTMin > threshold) = 0;
binarizedMatrixTMin(binarizedMatrixTMin ~= 0) = 1;

% signifMatrixMin = binarizedMatrixTMin.*pmask;
% signifMatrixMin2print = GetWeightedEdgeMatrixForBrainNetViewer(signifMatrixMin,pvalue);
% signifMatNameFile = [titleName 'Min'];
% PrintEdgeFile(signifMatNameFile,signifMatrixMin2print);

connectionMatrixMin = binarizedMatrixTMin;
connectionMatrixMax = binarizedMatrixTMax*2;

connectionMatrix = connectionMatrixMax + connectionMatrixMin;
connectionMatrix(logical(eye(size(connectionMatrix)))) = 0;

%PrintNodeFile(electrodeInfoFile,anatomicFile,connectionMatrix,titleName,nodeSpecStruct,'condition');
PrintEdgeFile(titleName,connectionMatrix);

connMatrix2Print = connectionMatrix.*triu(~eye(chanNr));

fileID = fopen([titleName '.txt'],'w');
formatSpec = '%s\r\n';
%formatSpec = '%.1f\t%.1f\t%.1f\t%d\t%d\t%s\r\n';  

for i = 1 : chanNr
    for j = 1 : chanNr
        val = connMatrix2Print(i,j);
        
        if val ~= 0
            text2Print = [labels{i} ' ' labels{j} ' ' num2str(val) ];
            fprintf(fileID,formatSpec,text2Print);
        end
    end
end

fclose(fileID);

