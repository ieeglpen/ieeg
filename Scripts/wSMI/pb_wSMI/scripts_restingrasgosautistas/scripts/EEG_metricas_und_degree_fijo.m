function EEG_metricas()

dir='/home/pablo/disco2/eeg/resting_rasgos_autistas/';

cd(dir)
sublist;
addpath /home/pablo/Documentos/toolboxes/'2011-03-27 BCT'/
addpath(genpath('/home/pablo/Documentos/toolboxes/Community_BGLL_Matlab/'))

sujetos = [sujetos_lula(:,1);sujetos_pablob(:,1);sujetos_joa(:,1)];

banda = 'broadband'
cd(fullfile(dir,'Resultados','SL'))
for suj=1:length(sujetos)
    suj
    aa = load(['SL_',banda,'_',sujetos{suj},'.mat']);
    mat = aa.SL;
    cont=1;
    %% calculates raw measures and saves them
    clear kden lambda1 lambda2 lambda1_rand lambda2_rand BC deg id od modularity

    for i=1:20:128*128
        matriz=triu(mat);
        NLINKS=round(i);
        f=reshape(matriz,1,128*128);
        [f_sort,J] = sort(f,'descend'); % ordena el vector, los primeros n son los que quiero
        index=J(1:NLINKS) ;
        ff=zeros(size(f));
        ff(index)=matriz(index);
        ff = reshape(ff,128,128);

        logical=single(ff>0);

        % calcula degree
        [deg(:,cont)] = degrees_und(logical);

        % calcula porcentaje de conexiones
        [kden(cont),N,K] = density_dir(logical);


        % crea matriz random
        cij = makerandCIJ_dir(N,K);

        % calcula L
        E=distance_bin(logical);
        [lambda1(cont),ecc,radius,diameter] = charpath(E);

        E=distance_bin(cij);
        [lambda1_rand(cont),ecc,radius,diameter] = charpath(E);

        %  calcula C
        lambda2(cont,:)=clustering_coef_bu(logical);
        lambda2_rand(cont,:)=clustering_coef_bu(cij);

        %  calcula C
        BC(:,cont)=betweenness_bin(logical);

        try
            [COMTY ending] = cluster_jl(logical,1,1);
            modularity(cont,:)=COMTY.MOD(length(COMTY.MOD));
            modulos{cont}=COMTY.COM{length(COMTY.MOD)};
        catch
            modularity(cont,:)=0;
            modulos{cont}=0;
        end

        cont=cont+1;
    end % umbral

    % calcula moduladidad
    try
        [COMTY ending] = cluster_jl(mat,1,1);
        modularity_wei=COMTY.MOD(length(COMTY.MOD));
        modulos_wei=COMTY.COM{length(COMTY.MOD)};
    catch
        modularity_wei=0;
        modulos_wei=0;
    end


    metricas.subject(suj).kden = kden;
    metricas.subject(suj).distances = E;
    metricas.subject(suj).L = lambda1;
    metricas.subject(suj).C = lambda2;
    metricas.subject(suj).L_rand = lambda1_rand;
    metricas.subject(suj).C_rand = lambda2_rand;
    metricas.subject(suj).BC = BC;
    metricas.subject(suj).degree = deg;
    metricas.subject(suj).modularity = modularity;
    metricas.subject(suj).modulos = modulos;
    metricas.subject(suj).modularity_wei = modularity_wei;
    metricas.subject(suj).modulos_wei = modulos_wei;
end

cd(fullfile(dir,'Resultados','metricas'));

save(['metricas_',banda,'_degreefijo'],'metricas');
