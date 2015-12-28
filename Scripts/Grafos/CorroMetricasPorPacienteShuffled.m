function [matAcondicionada] = CorroMetricasPorPacienteShuffled(M,fileName)

metricasPorSuj = struct;

for i = 1 : size(M,3)
    [fileName ' ' num2str(i)]
    
    mat = AcondicionoMatricesPorPaciente(M(:,:,i));
    matAcondicionada(:,:,i) = mat;
    
    %shuffle values
    matPerm = ShuffleMatrix(mat);
    
    %corro funcion metricasAll
    metricas = metricasAll(matPerm);
    metricasPorSuj(i).metricas = metricas;
end

save(fileName,'metricasPorSuj');
