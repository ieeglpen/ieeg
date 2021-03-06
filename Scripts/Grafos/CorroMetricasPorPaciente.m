function [matAcondicionada] = CorroMetricasPorPaciente(M,fileName)

metricasPorSuj = struct;

for i = 1 : size(M,3)
    [fileName ' ' num2str(i)]
    
    mat = AcondicionoMatricesPorPaciente(M(:,:,i));
    matAcondicionada(:,:,i) = mat;
    %corro funcion metricasAll
    metricas = metricasAll(mat);
    metricasPorSuj(i).metricas = metricas;
     
end

save(fileName,'metricasPorSuj');
