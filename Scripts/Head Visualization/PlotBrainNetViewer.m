function PlotBrainNetViewer(path2BrainNetAux,nodeFile,edgeFiles,outputFiles)
%path2BrainNetAux: path to files of configuration

surfaceFileName = [path2BrainNetAux 'BrainMesh_ICBM152.nv'];

%condition mats -> configuration files
normalConfigStruct(1).config = [path2BrainNetAux 'wSMISagittal.mat'];
normalConfigStruct(2).config = [path2BrainNetAux 'wSMIAxial.mat'];
normalConfigStruct(3).config = [path2BrainNetAux 'wSMICoronal.mat'];

% rawConfigStruct(1).config = [path2BrainNetAux 'wSMISagittalRaw.mat'];
% rawConfigStruct(2).config = [path2BrainNetAux 'wSMIAxialRaw.mat'];
% rawConfigStruct(3).config = [path2BrainNetAux 'wSMICoronalRaw.mat'];

autoConfigStruct(1).config = [path2BrainNetAux 'wSMISagittalAuto.mat'];
autoConfigStruct(2).config = [path2BrainNetAux 'wSMIAxialAuto.mat'];
autoConfigStruct(3).config = [path2BrainNetAux 'wSMICoronalAuto.mat'];

normaloutputFileNames = {'_Sagittal','_Axial','_Coronal'};
autooutputFileNames = {'_Auto_Sagittal','_Auto_Axial','_Auto_Coronal'};

nodeFileName = [path2BrainNetAux nodeFile];

imageExtension = 'png';

for i = 1 : size(edgeFiles,2)
    
    edgeFileName = edgeFiles{i};
    outputFileName = outputFiles{i}; 
    
    %plot Normal
    Plot3DBrainNetViewer(surfaceFileName,nodeFileName,edgeFileName,normalConfigStruct,outputFileName,normaloutputFileNames,imageExtension);

    %plot Auto
    Plot3DBrainNetViewer(surfaceFileName,nodeFileName,edgeFileName,autoConfigStruct,outputFileName,autooutputFileNames,imageExtension);
end

display('DONE')