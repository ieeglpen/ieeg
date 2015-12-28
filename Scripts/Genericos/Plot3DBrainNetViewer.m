function Plot3DBrainNetViewer(surfaceFile,nodeFile,edgeFile,configurationMatStruct,baseFileName,outputFileNames,imageExt)
%plot Sagittal, Axial and Coronal views of edge file, using a
%configurationMatStruct with property config(1: Sagittal, 2: Axial, 3: Coronal) and a cell
%array of outputFileNames (these last two must be of equal size)

for i = 1 : size(configurationMatStruct,2)    
    configurationMat = configurationMatStruct(i).config;
    fileName = [baseFileName outputFileNames{i} '.' imageExt];
    BrainNet_MapCfg(surfaceFile,nodeFile,edgeFile,configurationMat,fileName);
end