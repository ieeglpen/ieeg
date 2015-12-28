%% Este script hace el calculo de las metricas para cada uno de los grupos
%

%% (0) Setear el script
restoredefaultpath
clear all
home
%agrego el toolbox BCTuptadte
addpath(genpath( 'D:\Lucas\INECO\Toolbox\BCTuptdate'));%
%agrego las funciones que calculas las metricas
addpath(genpath( 'D:\Desktop\Prueba_metricas\Codigos\3_metricas\funciones'));%
root='D:\Desktop\Prueba_metricas\Datos_ejemplo _sinmet';
grupos={'ALZ','CONTROLES','FTD'};

%% (1) RECORRO EL NOMBRE DE LOS GRUPOS
%(1.1) Comienzo el for
for i=[1 3]%:length(grupos)
    
    %(1.2) Me paro en donde se encuentra el grupo
    cd ([root,'/',grupos{i}]);
    
    %(1.3) Leo todos los nombres de las carpetas que se encuentra en esa
    %direccion
    folders=dir;
    folders_final=folders(3:length(folders(:,1)),:);
    clear folders
    
    %(1.4) Comienzo el for para recorrer los sujetos
    for suj=1:length(folders_final(:,1))
        %cargo las matriz del sujeto
        cd ([root,'/',grupos{i},'/',folders_final(suj,1).name,'/matriz']);
        load (['Wcor_116_',folders_final(suj,1).name(1,end-2:end),'.mat']);
        %pongo la Wcor en una variable mat que es la que le voy a dar a la
        %funcion metricasAll
        mat=Wcor.scale3;
        clear Wcor
        
        %corro funcion metricasAll
        metricas=metricasAll(mat);
        
        %me paro en donde quiero guardar los resultados
        cd ([root,'/',grupos{i},'/',folders_final(suj,1).name]);
            existe=exist ('metricas','dir');
            if existe==0;
                mkdir('metricas');
            else
            end
            cd ([root,'/',grupos{i},'/',folders_final(suj,1).name,'/metricas'])
            save(['metricas_',folders_final(suj,1).name(1,end-2:end)],'metricas');
       
       %cierro el for que recorre los sujetos
       clear existe mat suj metricas
    end
    
    %cierro el for que recorre los grupos
    clear folders_final
end
clear i
        
        
        



