
%% (-0) Agrego toolbox y funciones
restoredefaultpath
clear all
clc
addpath(genpath( 'D:\Lucas\INECO\Metodologia_analisis\Conectividad_fmri\DEM_Australia\Codigos\estadistica\funciones'));%meto el findoutliers
addpath(genpath( 'D:\Lucas\INECO\Toolbox\eeglab12_0_2_6b'));%meto el eeglab por si hay que hacer permutaciones


%% (0) Seteo el script
%donde estan guardadsa las metricsa
seetings.root='D:\Desktop\Prueba_metricas\Datos_ejemplo';
%defino la ruta en la cual voy a guardar los resultado
seetings.output_dir='D:\Desktop\Prueba_metricas\Prueba_resultados\Estadistica';
%defino los grupos que voy a comprar
seetings.GRUPO_uno='FTD';
seetings.GRUPO_dos='ALZ';
%defino las metricas que voy a analizar
seetings.metricas={'C', 'degree', 'BC'};
%defino entre que y que medidas de umbral y/o threshold quiero ver los
%resultados
seetings.umb=[1,201];
%creo una variable en seetings con las etiqueras de las areas y defino que
%areas voy a comparar
cd ('D:\Lucas\INECO\Metodologia_analisis\Conectividad_fmri\DEM_Australia\Atlas\Tzourio\116_original')
load('ROI_MNI_V4_List.mat');
seetings.areas=1:116;
seetings.areas_label={ROI(seetings.areas).Nom_L};
clear ROI
%establezco el desvio que voy a utilizar para establecer los outliers
seetings.desv=2;
%seteo que estadistica quiero usar
seetings.estadistica=1;
%seteo el percentil que voy a utilizar cuando calcule la conectividad de
%los nodos en los cuales encuentre diferencias de metricas (Es solo para aquellas metricas en lsa cuales
%no hicela correccion por FDR, en estsa ultimsa veo el 100%)
seetings.percentil=10;



%% (1) Comienzo a recorrer cada una de lsa metricas
for met=1:length(seetings.metricas)
        %% (2) Cargo el grupo uno
        cd ([seetings.root,'/',seetings.GRUPO_uno])
        folders=dir;
        folders_final=folders(3:length(folders(:,1)),:);
        clear folders

        %(1.2) Comienzo el for para recorrer los sujetos del GRUPO UNO
        for suj=1:length(folders_final(:,1))

            cd ([seetings.root,'/',seetings.GRUPO_uno,'/',folders_final(suj,1).name,'/metricas']);
            load (['metricas_',folders_final(suj,1).name(1,end-2:end),'.mat']);
            
            %---------------WIEGHTED--------------------------------------
            %armo las variables para despues hacer la comparacion de las
            %matrices Pesadas
            guno.Pesadas(suj,:)=eval(['metricas.Pesadas.',seetings.metricas{met}]);
            
            %--------------BINARIZADAS UMBRAL------------------------------------
            %armo las variables para hacer la comparacion de las matrices
            %binarizadas por UMBRALES
            aux=eval(['metricas.Umbral.',seetings.metricas{met}])';
            aux_bin=aux(seetings.umb(1):seetings.umb(2),:);
            clear aux
            aux_bin_mean=nanmean(aux_bin,1);
            clear aux_bin
            guno.Umbral(suj,:)=aux_bin_mean;
            clear aux_bin_mean
            
            %--------------BINARIZADAS DENSIDAD------------------------------------
            %armo las variables para hacer la comparacion de las matrices
            %binarizadas por DENSIDAD
            aux=eval(['metricas.Densidad.',seetings.metricas{met}])';
            aux_bin=aux(seetings.umb(1):seetings.umb(2),:);
            clear aux
            aux_bin_mean=nanmean(aux_bin,1);
            clear aux_bin
            guno.Densidad(suj,:)=aux_bin_mean;
            clear aux_bin_mean
            
           clear metricas 
           %cierro el rejunte de cada sujeto 
           
           %-------------- ADEMAS, guardo las matrices que voy a usar
           %despues---------------------------------------------------------
           cd ([seetings.root,'/',seetings.GRUPO_uno,'/',folders_final(suj,1).name,'/matriz']);
           load(['Wcor_116_',folders_final(suj,1).name(1,end-2:end),'.mat'])
           guno.matriz(seetings.areas,seetings.areas,suj)=Wcor.scale3;
           clear Wcor
           
        end
        clear folders_final suj
        
        %% (3) Cargo el grupo DOS
        cd ([seetings.root,'/',seetings.GRUPO_dos])
        folders=dir;
        folders_final=folders(3:length(folders(:,1)),:);
        clear folders

        %(1.2) Comienzo el for para recorrer los sujetos del GRUPO DOS
        for suj=1:length(folders_final(:,1))

            cd ([seetings.root,'/',seetings.GRUPO_dos,'/',folders_final(suj,1).name,'/metricas']);
            load (['metricas_',folders_final(suj,1).name(1,end-2:end),'.mat']);
            
            %---------------WIEGHTED--------------------------------------
            %armo las variables para despues hacer la comparacion de las
            %matrices Pesadas
            gdos.Pesadas(suj,:)=eval(['metricas.Pesadas.',seetings.metricas{met}]);
            
            %--------------BINARIZADAS UMBRAL------------------------------------
            %armo las variables para hacer la comparacion de las matrices
            %binarizadas por UMBRALES
            aux=eval(['metricas.Umbral.',seetings.metricas{met}])';
            aux_bin=aux(seetings.umb(1):seetings.umb(2),:);
            clear aux
            aux_bin_mean=nanmean(aux_bin,1);
            clear aux_bin
            gdos.Umbral(suj,:)=aux_bin_mean;
            clear aux_bin_mean
            
            %--------------BINARIZADAS DENSIDAD------------------------------------
            %armo las variables para hacer la comparacion de las matrices
            %binarizadas por DENSIDAD
            aux=eval(['metricas.Densidad.',seetings.metricas{met}])';
            aux_bin=aux(seetings.umb(1):seetings.umb(2),:);
            clear aux
            aux_bin_mean=nanmean(aux_bin,1);
            clear aux_bin
            gdos.Densidad(suj,:)=aux_bin_mean;
            clear aux_bin_mean
            
           clear metricas 
           %cierro el rejunte de cada sujeto 
           
           %-------------- ADEMAS, guardo las matrices que voy a usar
           %despues---------------------------------------------------------
           cd ([seetings.root,'/',seetings.GRUPO_dos,'/',folders_final(suj,1).name,'/matriz']);
           load(['Wcor_116_',folders_final(suj,1).name(1,end-2:end),'.mat'])
           gdos.matriz(seetings.areas,seetings.areas,suj)=Wcor.scale3;
           clear Wcor
           
        end
        clear folders_final suj
        
        %% (3) Hago la estadistica para cada metodo
        
        %-------- PARA el metodo de PESADAS----------------
        [Res_Pesadas]=stat_metricas_areas(guno.Pesadas(:,seetings.areas), gdos.Pesadas(:,seetings.areas),seetings.areas_label,seetings.estadistica,seetings.desv);
        
        %-------- PARA el metodo de UMBRAL----------------
        [Res_Umbral]=stat_metricas_areas(guno.Umbral(:,seetings.areas), gdos.Umbral(:,seetings.areas),seetings.areas_label,seetings.estadistica,seetings.desv);
        
        %-------- PARA el metodo de DENSIDAD----------------
        [Res_Densidad]=stat_metricas_areas(guno.Densidad(:,seetings.areas), gdos.Densidad(:,seetings.areas),seetings.areas_label,seetings.estadistica,seetings.desv);
        
        
        %% (4) Aca calculo, solo de los nodos de cada metodo, cuales son las conexiones significativas con todo el resto.
        %% (4.1)--------Empiezo por las metricas PESADAS-------
        %Lo primero que tengo que hacer es generar un vector en el cual
        %tenga cuales son los nodos que presentan diferencias
        %significativas
        
        %(4.1.1) ---- Primero para el primer GRUPO
        %genero una matriz con todas las conexiones
        %sin correccion de FDR.
        who_pos_conect_uno=find(Res_Pesadas.BrainNetData.GrupoUno>0);
               
        [Conect_Pesadas.Resultados, Conect_Pesadas.GrupoUno, Conect_Pesadas.GrupoDos]=stat_areas_fdr(guno.matriz,gdos.matriz,who_pos_conect_uno',seetings.areas,seetings.areas_label,seetings.estadistica,seetings.percentil,seetings.desv);
        %Genero/le agrego a la matriz que calcula los valores T para el
        %primer grupo, teniendo en cuenta las correlaciones positivas
        aux_matriz_t_pesadas(seetings.areas,seetings.areas)=0;
        for i=1:length(Conect_Pesadas.GrupoUno.GroupOne_highPos(:,3))-1
            aux_matriz_t_pesadas(cell2mat(Conect_Pesadas.GrupoUno.GroupOne_highPos(i+1,7)))=cell2mat(Conect_Pesadas.GrupoUno.GroupOne_highPos(i+1,3));
        end
        
        matriz_aux=transpose(aux_matriz_t_pesadas);
        final_matriz_t_pesadas=aux_matriz_t_pesadas+matriz_aux;
        clear matriz_aux aux_matriz_t_pesadas
        Res_Pesadas.BrainNetData.matriz_t_pos_GrupoUno=final_matriz_t_pesadas;
        
        %me hago una lista de cuales son los nodos que NO dan diferencias
        %significativas en la metrica pero que estan conectados con
        %aquellos que tienen diferencias significativas. Los guardo en una
        %variable que despues voy a reemplazar en la parte de los modulos
        all_nodes=nanmean(final_matriz_t_pesadas,2);
        nodes_positive_con=find(Res_Pesadas.BrainNetData.GrupoUno>0);
        all_nodes(nodes_positive_con)=0;
        all_nodes(find(all_nodes>0))=1;
        Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoUno=all_nodes;
        clear all_nodes nodes_positive_con
        
        %genero la variable que voy a utilizar en el BrainNet para
        %determinar el tamaño del nodo. Para eso sumo dos variables
        Res_Pesadas.BrainNetData.pval_nopvals_t_posUno_nodes=Res_Pesadas.BrainNetData.GrupoUno+Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoUno;
        clear who_pos_conect_uno final_matriz_t_pesadas
        
        %Guardo los resultados de la conectividad
        Res_Pesadas.Estadistica_Conect=Conect_Pesadas;
        clear Conect_Pesadas        
        
        
        %(4.1.2) Sigo haciendolo para los Controles pero ahora lo hago
        %sobre las metricas corregidas por FDR. Busco el 100% de las
        %correlaciones significativas pero solo me quedo con las corregidas
        %por FDR
        who_pos_conect_uno_FDR=find(Res_Pesadas.BrainNetData.GrupoUnoFDR>0);
        
        if sum(who_pos_conect_uno_FDR)>0
               
                [Conect_Pesadas.Resultados, Conect_Pesadas.GrupoUno, Conect_Pesadas.GrupoDos]=stat_areas_fdr(guno.matriz,gdos.matriz,who_pos_conect_uno_FDR',seetings.areas,seetings.areas_label,seetings.estadistica,100,seetings.desv);
                %De los resultado que obtengo genero una lista con los valores que
                %se mantiene significativos despues de aplicar el FDR. 
                fdr_grupoUno_pos=find([Conect_Pesadas.GrupoUno.GroupOne_highPos{2:end,4}]<=0.05);

                %Genero/le agrego a la matriz que calcula los valores T para el
                %primer grupo, teniendo en cuenta las correlaciones positivas
                aux_matriz_t_pesadas(seetings.areas,seetings.areas)=0;
                for i=1:length(fdr_grupoUno_pos)
                    aux_matriz_t_pesadas(cell2mat(Conect_Pesadas.GrupoUno.GroupOne_highPos(fdr_grupoUno_pos(i)+1,7)))=cell2mat(Conect_Pesadas.GrupoUno.GroupOne_highPos(fdr_grupoUno_pos(i)+1,3));
                end

                matriz_aux=transpose(aux_matriz_t_pesadas);
                final_matriz_t_pesadas=aux_matriz_t_pesadas+matriz_aux;
                clear matriz_aux aux_matriz_t_pesadas
                Res_Pesadas.BrainNetData.matriz_t_pos_GrupoUnoFDR=final_matriz_t_pesadas;

                %me hago una lista de cuales son los nodos que NO dan diferencias
                %significativas en la metrica pero que estan conectados con
                %aquellos que tienen diferencias significativas. Los guardo en una
                %variable que despues voy a reemplazar en la parte de los modulos
                all_nodes=nanmean(final_matriz_t_pesadas,2);
                nodes_positive_con=find(Res_Pesadas.BrainNetData.GrupoUnoFDR>0);
                all_nodes(nodes_positive_con)=0;
                all_nodes(find(all_nodes>0))=1;
                Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoUnoFDR=all_nodes;
                clear all_nodes nodes_positive_con

                %genero la variable que voy a utilizar en el BrainNet para
                %determinar el tamaño del nodo. Para eso sumo dos variables
                Res_Pesadas.BrainNetData.pval_nopvals_t_posUno_nodesFDR=Res_Pesadas.BrainNetData.GrupoUnoFDR+Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoUnoFDR;
                clear  final_matriz_t_pesadas

                %Guardo los resultados de la conectividad
                Res_Pesadas.Estadistica_ConectFDR=Conect_Pesadas;
                clear Conect_Pesadas fdr_grupoUno_pos  
        else
        end
        
        %(4.1.3) ----  SEGUNDO GRUPO --------------------
        
        %Genero/le agrego a la matriz que calcula los valores T para el
        %primer grupo, teniendo en cuenta las correlaciones positivas
        aux_matriz_t_pesadas(seetings.areas,seetings.areas)=0;
        for i=1:length(Res_Pesadas.Estadistica_Conect.GrupoDos.GrupoDos_highPos(:,3))-1
            aux_matriz_t_pesadas(cell2mat(Res_Pesadas.Estadistica_Conect.GrupoDos.GrupoDos_highPos(i+1,7)))=cell2mat(Res_Pesadas.Estadistica_Conect.GrupoDos.GrupoDos_highPos(i+1,3));
        end
        
        matriz_aux=transpose(aux_matriz_t_pesadas);
        final_matriz_t_pesadas=aux_matriz_t_pesadas+matriz_aux;
        clear matriz_aux aux_matriz_t_pesadas
        Res_Pesadas.BrainNetData.matriz_t_pos_GrupoDos=final_matriz_t_pesadas;
        
        %me hago una lista de cuales son los nodos que NO dan diferencias
        %significativas en la metrica pero que estan conectados con
        %aquellos que tienen diferencias significativas. Los guardo en una
        %variable que despues voy a reemplazar en la parte de los modulos
        all_nodes=nanmean(final_matriz_t_pesadas,2);
        nodes_positive_con=find(Res_Pesadas.BrainNetData.GrupoDos<0);
        all_nodes(nodes_positive_con)=0;
        all_nodes(find(all_nodes<0))=1;
        Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoDos=all_nodes;
        clear all_nodes nodes_positive_con
        
        %genero la variable que voy a utilizar en el BrainNet para
        %determinar el tamaño del nodo. Para eso sumo dos variables
        Res_Pesadas.BrainNetData.pval_nopvals_t_posDos_nodes=Res_Pesadas.BrainNetData.GrupoDos+Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoDos;
        clear who_pos_conect_uno final_matriz_t_pesadas
        
        
        
        %(4.1.2) Sigo haciendolo para los el SEGUNDO GRUPO pero ahora lo hago
        %sobre las metricas corregidas por FDR. Busco el 100% de las
        %correlaciones significativas pero solo me quedo con las corregidas
        %por FDR
        %De los resultado que obtengo genero una lista con los valores que
        %se mantiene significativos despues de aplicar el FDR. 
        
        if sum(who_pos_conect_uno_FDR)>0
        
            fdr_grupoDos_pos=find([Res_Pesadas.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos{2:end,4}]<=0.05);

            %Genero/le agrego a la matriz que calcula los valores T para el
            %primer grupo, teniendo en cuenta las correlaciones positivas
            aux_matriz_t_pesadas(seetings.areas,seetings.areas)=0;
            for i=1:length(fdr_grupoDos_pos)
                aux_matriz_t_pesadas(cell2mat(Res_Pesadas.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos(fdr_grupoDos_pos(i)+1,7)))=cell2mat(Res_Pesadas.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos(fdr_grupoDos_pos(i)+1,3));
            end

            matriz_aux=transpose(aux_matriz_t_pesadas);
            final_matriz_t_pesadas=aux_matriz_t_pesadas+matriz_aux;
            clear matriz_aux aux_matriz_t_pesadas
            Res_Pesadas.BrainNetData.matriz_t_pos_GrupoDosFDR=final_matriz_t_pesadas;

            %me hago una lista de cuales son los nodos que NO dan diferencias
            %significativas en la metrica pero que estan conectados con
            %aquellos que tienen diferencias significativas. Los guardo en una
            %variable que despues voy a reemplazar en la parte de los modulos
            all_nodes=nanmean(final_matriz_t_pesadas,2);
            nodes_positive_con=find(Res_Pesadas.BrainNetData.GrupoDosFDR<0);
            all_nodes(nodes_positive_con)=0;
            all_nodes(find(all_nodes<0))=1;
            Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoDosFDR=all_nodes;
            clear all_nodes nodes_positive_con

            %genero la variable que voy a utilizar en el BrainNet para
            %determinar el tamaño del nodo. Para eso sumo dos variables
            Res_Pesadas.BrainNetData.pval_nopvals_t_posDos_nodesFDR=Res_Pesadas.BrainNetData.GrupoDosFDR+Res_Pesadas.BrainNetData.NopvalsModulos_t_pos_GrupoDosFDR;
            clear who_pos_conect_uno_FDR final_matriz_t_pesadas fdr_grupoDos_pos i
        else
        end
        clear who_pos_conect_uno_FDR
        
        
        %% (5.1)--------Empiezo por las metricas DENSIDAD-------
        %Lo primero que tengo que hacer es generar un vector en el cual
        %tenga cuales son los nodos que presentan diferencias
        %significativas
        
        %(5.1.1) ---- Primero para el primer GRUPO
        %genero una matriz con todas las conexiones
        %sin correccion de FDR.
        who_pos_conect_uno=find(Res_Densidad.BrainNetData.GrupoUno>0);
               
        [Conect_Densidad.Resultados, Conect_Densidad.GrupoUno, Conect_Densidad.GrupoDos]=stat_areas_fdr(guno.matriz,gdos.matriz,who_pos_conect_uno',seetings.areas,seetings.areas_label,seetings.estadistica,seetings.percentil,seetings.desv);
        %Genero/le agrego a la matriz que calcula los valores T para el
        %primer grupo, teniendo en cuenta las correlaciones positivas
        aux_matriz_t_densidad(seetings.areas,seetings.areas)=0;
        for i=1:length(Conect_Densidad.GrupoUno.GroupOne_highPos(:,3))-1
            aux_matriz_t_densidad(cell2mat(Conect_Densidad.GrupoUno.GroupOne_highPos(i+1,7)))=cell2mat(Conect_Densidad.GrupoUno.GroupOne_highPos(i+1,3));
        end
        
        matriz_aux=transpose(aux_matriz_t_densidad);
        final_matriz_t_densidad=aux_matriz_t_densidad+matriz_aux;
        clear matriz_aux aux_matriz_t_densidad
        Res_Densidad.BrainNetData.matriz_t_pos_GrupoUno=final_matriz_t_densidad;
        
        %me hago una lista de cuales son los nodos que NO dan diferencias
        %significativas en la metrica pero que estan conectados con
        %aquellos que tienen diferencias significativas. Los guardo en una
        %variable que despues voy a reemplazar en la parte de los modulos
        all_nodes=nanmean(final_matriz_t_densidad,2);
        nodes_positive_con=find(Res_Densidad.BrainNetData.GrupoUno>0);
        all_nodes(nodes_positive_con)=0;
        all_nodes(find(all_nodes>0))=1;
        Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoUno=all_nodes;
        clear all_nodes nodes_positive_con
        
        %genero la variable que voy a utilizar en el BrainNet para
        %determinar el tamaño del nodo. Para eso sumo dos variables
        Res_Densidad.BrainNetData.pval_nopvals_t_posUno_nodes=Res_Densidad.BrainNetData.GrupoUno+Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoUno;
        clear who_pos_conect_uno final_matriz_t_densidad
        
        %Guardo los resultados de la conectividad
        Res_Densidad.Estadistica_Conect=Conect_Densidad;
        clear Conect_Densidad      
        
        
        %(5.1.2) Sigo haciendolo para los Controles pero ahora lo hago
        %sobre las metricas corregidas por FDR. Busco el 100% de las
        %correlaciones significativas pero solo me quedo con las corregidas
        %por FDR
        who_pos_conect_uno_FDR=find(Res_Densidad.BrainNetData.GrupoUnoFDR>0);
        
        if sum(who_pos_conect_uno_FDR)>0

               
                [Conect_Densidad.Resultados, Conect_Densidad.GrupoUno, Conect_Densidad.GrupoDos]=stat_areas_fdr(guno.matriz,gdos.matriz,who_pos_conect_uno_FDR',seetings.areas,seetings.areas_label,seetings.estadistica,100,seetings.desv);
                %De los resultado que obtengo genero una lista con los valores que
                %se mantiene significativos despues de aplicar el FDR. 
                fdr_grupoUno_pos=find([Conect_Densidad.GrupoUno.GroupOne_highPos{2:end,4}]<=0.05);

                %Genero/le agrego a la matriz que calcula los valores T para el
                %primer grupo, teniendo en cuenta las correlaciones positivas
                aux_matriz_t_densidad(seetings.areas,seetings.areas)=0;
                for i=1:length(fdr_grupoUno_pos)
                    aux_matriz_t_densidad(cell2mat(Conect_Densidad.GrupoUno.GroupOne_highPos(fdr_grupoUno_pos(i)+1,7)))=cell2mat(Conect_Densidad.GrupoUno.GroupOne_highPos(fdr_grupoUno_pos(i)+1,3));
                end

                matriz_aux=transpose(aux_matriz_t_densidad);
                final_matriz_t_densidad=aux_matriz_t_densidad+matriz_aux;
                clear matriz_aux aux_matriz_t_densidad
                Res_Densidad.BrainNetData.matriz_t_pos_GrupoUnoFDR=final_matriz_t_densidad;

                %me hago una lista de cuales son los nodos que NO dan diferencias
                %significativas en la metrica pero que estan conectados con
                %aquellos que tienen diferencias significativas. Los guardo en una
                %variable que despues voy a reemplazar en la parte de los modulos
                all_nodes=nanmean(final_matriz_t_densidad,2);
                nodes_positive_con=find(Res_Densidad.BrainNetData.GrupoUnoFDR>0);
                all_nodes(nodes_positive_con)=0;
                all_nodes(find(all_nodes>0))=1;
                Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoUnoFDR=all_nodes;
                clear all_nodes nodes_positive_con

                %genero la variable que voy a utilizar en el BrainNet para
                %determinar el tamaño del nodo. Para eso sumo dos variables
                Res_Densidad.BrainNetData.pval_nopvals_t_posUno_nodesFDR=Res_Densidad.BrainNetData.GrupoUnoFDR+Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoUnoFDR;
                clear  final_matriz_t_densidad

                %Guardo los resultados de la conectividad
                Res_Densidad.Estadistica_ConectFDR=Conect_Densidad;
                clear Conect_Densidad fdr_grupoUno_pos   
        else
        end
        
        %(5.1.3) ----  SEGUNDO GRUPO --------------------
        
        %Genero/le agrego a la matriz que calcula los valores T para el
        %primer grupo, teniendo en cuenta las correlaciones positivas
        aux_matriz_t_densidad(seetings.areas,seetings.areas)=0;
        for i=1:length(Res_Densidad.Estadistica_Conect.GrupoDos.GrupoDos_highPos(:,3))-1
            aux_matriz_t_densidad(cell2mat(Res_Densidad.Estadistica_Conect.GrupoDos.GrupoDos_highPos(i+1,7)))=cell2mat(Res_Densidad.Estadistica_Conect.GrupoDos.GrupoDos_highPos(i+1,3));
        end
        
        matriz_aux=transpose(aux_matriz_t_densidad);
        final_matriz_t_densidad=aux_matriz_t_densidad+matriz_aux;
        clear matriz_aux aux_matriz_t_densidad
        Res_Densidad.BrainNetData.matriz_t_pos_GrupoDos=final_matriz_t_densidad;
        
        %me hago una lista de cuales son los nodos que NO dan diferencias
        %significativas en la metrica pero que estan conectados con
        %aquellos que tienen diferencias significativas. Los guardo en una
        %variable que despues voy a reemplazar en la parte de los modulos
        all_nodes=nanmean(final_matriz_t_densidad,2);
        nodes_positive_con=find(Res_Densidad.BrainNetData.GrupoDos<0);
        all_nodes(nodes_positive_con)=0;
        all_nodes(find(all_nodes<0))=1;
        Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoDos=all_nodes;
        clear all_nodes nodes_positive_con
        
        %genero la variable que voy a utilizar en el BrainNet para
        %determinar el tamaño del nodo. Para eso sumo dos variables
        Res_Densidad.BrainNetData.pval_nopvals_t_posDos_nodes=Res_Densidad.BrainNetData.GrupoDos+Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoDos;
        clear who_pos_conect_uno final_matriz_t_densidad
        
        
        
        %(5.1.2) Sigo haciendolo para los el SEGUNDO GRUPO pero ahora lo hago
        %sobre las metricas corregidas por FDR. Busco el 100% de las
        %correlaciones significativas pero solo me quedo con las corregidas
        %por FDR
        %De los resultado que obtengo genero una lista con los valores que
        %se mantiene significativos despues de aplicar el FDR. 
        
        if sum(who_pos_conect_uno_FDR)>0

                fdr_grupoDos_pos=find([Res_Densidad.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos{2:end,4}]<=0.05);

                %Genero/le agrego a la matriz que calcula los valores T para el
                %primer grupo, teniendo en cuenta las correlaciones positivas
                aux_matriz_t_densidad(seetings.areas,seetings.areas)=0;
                for i=1:length(fdr_grupoDos_pos)
                    aux_matriz_t_densidad(cell2mat(Res_Densidad.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos(fdr_grupoDos_pos(i)+1,7)))=cell2mat(Res_Densidad.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos(fdr_grupoDos_pos(i)+1,3));
                end

                matriz_aux=transpose(aux_matriz_t_densidad);
                final_matriz_t_densidad=aux_matriz_t_densidad+matriz_aux;
                clear matriz_aux aux_matriz_t_densidad
                Res_Densidad.BrainNetData.matriz_t_pos_GrupoDosFDR=final_matriz_t_densidad;

                %me hago una lista de cuales son los nodos que NO dan diferencias
                %significativas en la metrica pero que estan conectados con
                %aquellos que tienen diferencias significativas. Los guardo en una
                %variable que despues voy a reemplazar en la parte de los modulos
                all_nodes=nanmean(final_matriz_t_densidad,2);
                nodes_positive_con=find(Res_Densidad.BrainNetData.GrupoDosFDR<0);
                all_nodes(nodes_positive_con)=0;
                all_nodes(find(all_nodes<0))=1;
                Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoDosFDR=all_nodes;
                clear all_nodes nodes_positive_con

                %genero la variable que voy a utilizar en el BrainNet para
                %determinar el tamaño del nodo. Para eso sumo dos variables
                Res_Densidad.BrainNetData.pval_nopvals_t_posDos_nodesFDR=Res_Densidad.BrainNetData.GrupoDosFDR+Res_Densidad.BrainNetData.NopvalsModulos_t_pos_GrupoDosFDR;
                clear who_pos_conect_uno_FDR final_matriz_t_densidad fdr_grupoDos_pos i
        else
        end
        clear who_pos_conect_uno_FDR
        
        
         %% (5.1)--------Empiezo por las metricas UMBRAL-------
        %Lo primero que tengo que hacer es generar un vector en el cual
        %tenga cuales son los nodos que presentan diferencias
        %significativas
        
        %(5.1.1) ---- Primero para el primer GRUPO
        %genero una matriz con todas las conexiones
        %sin correccion de FDR.
        who_pos_conect_uno=find(Res_Umbral.BrainNetData.GrupoUno>0);
               
        [Conect_Umbral.Resultados, Conect_Umbral.GrupoUno, Conect_Umbral.GrupoDos]=stat_areas_fdr(guno.matriz,gdos.matriz,who_pos_conect_uno',seetings.areas,seetings.areas_label,seetings.estadistica,seetings.percentil,seetings.desv);
        %Genero/le agrego a la matriz que calcula los valores T para el
        %primer grupo, teniendo en cuenta las correlaciones positivas
        aux_matriz_t_umbral(seetings.areas,seetings.areas)=0;
        for i=1:length(Conect_Umbral.GrupoUno.GroupOne_highPos(:,3))-1
            aux_matriz_t_umbral(cell2mat(Conect_Umbral.GrupoUno.GroupOne_highPos(i+1,7)))=cell2mat(Conect_Umbral.GrupoUno.GroupOne_highPos(i+1,3));
        end
        
        matriz_aux=transpose(aux_matriz_t_umbral);
        final_matriz_t_umbral=aux_matriz_t_umbral+matriz_aux;
        clear matriz_aux aux_matriz_t_umbral
        Res_Umbral.BrainNetData.matriz_t_pos_GrupoUno=final_matriz_t_umbral;
        
        %me hago una lista de cuales son los nodos que NO dan diferencias
        %significativas en la metrica pero que estan conectados con
        %aquellos que tienen diferencias significativas. Los guardo en una
        %variable que despues voy a reemplazar en la parte de los modulos
        all_nodes=nanmean(final_matriz_t_umbral,2);
        nodes_positive_con=find(Res_Umbral.BrainNetData.GrupoUno>0);
        all_nodes(nodes_positive_con)=0;
        all_nodes(find(all_nodes>0))=1;
        Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoUno=all_nodes;
        clear all_nodes nodes_positive_con
        
        %genero la variable que voy a utilizar en el BrainNet para
        %determinar el tamaño del nodo. Para eso sumo dos variables
        Res_Umbral.BrainNetData.pval_nopvals_t_posUno_nodes=Res_Umbral.BrainNetData.GrupoUno+Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoUno;
        clear who_pos_conect_uno final_matriz_t_umbral
        
        %Guardo los resultados de la conectividad
        Res_Umbral.Estadistica_Conect=Conect_Umbral;
        clear Conect_Umbral      
        
        
        %(5.1.2) Sigo haciendolo para los Controles pero ahora lo hago
        %sobre las metricas corregidas por FDR. Busco el 100% de las
        %correlaciones significativas pero solo me quedo con las corregidas
        %por FDR
        who_pos_conect_uno_FDR=find(Res_Umbral.BrainNetData.GrupoUnoFDR>0);

        if sum(who_pos_conect_uno_FDR)>0
              
                [Conect_Umbral.Resultados, Conect_Umbral.GrupoUno, Conect_Umbral.GrupoDos]=stat_areas_fdr(guno.matriz,gdos.matriz,who_pos_conect_uno_FDR',seetings.areas,seetings.areas_label,seetings.estadistica,100,seetings.desv);
                %De los resultado que obtengo genero una lista con los valores que
                %se mantiene significativos despues de aplicar el FDR. 
                fdr_grupoUno_pos=find([Conect_Umbral.GrupoUno.GroupOne_highPos{2:end,4}]<=0.05);

                %Genero/le agrego a la matriz que calcula los valores T para el
                %primer grupo, teniendo en cuenta las correlaciones positivas
                aux_matriz_t_umbral(seetings.areas,seetings.areas)=0;
                for i=1:length(fdr_grupoUno_pos)
                    aux_matriz_t_umbral(cell2mat(Conect_Umbral.GrupoUno.GroupOne_highPos(fdr_grupoUno_pos(i)+1,7)))=cell2mat(Conect_Umbral.GrupoUno.GroupOne_highPos(fdr_grupoUno_pos(i)+1,3));
                end

                matriz_aux=transpose(aux_matriz_t_umbral);
                final_matriz_t_umbral=aux_matriz_t_umbral+matriz_aux;
                clear matriz_aux aux_matriz_t_umbral
                Res_Umbral.BrainNetData.matriz_t_pos_GrupoUnoFDR=final_matriz_t_umbral;

                %me hago una lista de cuales son los nodos que NO dan diferencias
                %significativas en la metrica pero que estan conectados con
                %aquellos que tienen diferencias significativas. Los guardo en una
                %variable que despues voy a reemplazar en la parte de los modulos
                all_nodes=nanmean(final_matriz_t_umbral,2);
                nodes_positive_con=find(Res_Umbral.BrainNetData.GrupoUnoFDR>0);
                all_nodes(nodes_positive_con)=0;
                all_nodes(find(all_nodes>0))=1;
                Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoUnoFDR=all_nodes;
                clear all_nodes nodes_positive_con

                %genero la variable que voy a utilizar en el BrainNet para
                %determinar el tamaño del nodo. Para eso sumo dos variables
                Res_Umbral.BrainNetData.pval_nopvals_t_posUno_nodesFDR=Res_Umbral.BrainNetData.GrupoUnoFDR+Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoUnoFDR;
                clear  final_matriz_t_umbral

                %Guardo los resultados de la conectividad
                Res_Umbral.Estadistica_ConectFDR=Conect_Umbral;
                clear Conect_Umbral fdr_grupoUno_pos   
        else
        end
        
        %(5.1.3) ----  SEGUNDO GRUPO --------------------
        
        %Genero/le agrego a la matriz que calcula los valores T para el
        %primer grupo, teniendo en cuenta las correlaciones positivas
        aux_matriz_t_umbral(seetings.areas,seetings.areas)=0;
        for i=1:length(Res_Umbral.Estadistica_Conect.GrupoDos.GrupoDos_highPos(:,3))-1
            aux_matriz_t_umbral(cell2mat(Res_Umbral.Estadistica_Conect.GrupoDos.GrupoDos_highPos(i+1,7)))=cell2mat(Res_Umbral.Estadistica_Conect.GrupoDos.GrupoDos_highPos(i+1,3));
        end
        
        matriz_aux=transpose(aux_matriz_t_umbral);
        final_matriz_t_umbral=aux_matriz_t_umbral+matriz_aux;
        clear matriz_aux aux_matriz_t_umbral
        Res_Umbral.BrainNetData.matriz_t_pos_GrupoDos=final_matriz_t_umbral;
        
        %me hago una lista de cuales son los nodos que NO dan diferencias
        %significativas en la metrica pero que estan conectados con
        %aquellos que tienen diferencias significativas. Los guardo en una
        %variable que despues voy a reemplazar en la parte de los modulos
        all_nodes=nanmean(final_matriz_t_umbral,2);
        nodes_positive_con=find(Res_Umbral.BrainNetData.GrupoDos<0);
        all_nodes(nodes_positive_con)=0;
        all_nodes(find(all_nodes<0))=1;
        Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoDos=all_nodes;
        clear all_nodes nodes_positive_con
        
        %genero la variable que voy a utilizar en el BrainNet para
        %determinar el tamaño del nodo. Para eso sumo dos variables
        Res_Umbral.BrainNetData.pval_nopvals_t_posDos_nodes=Res_Umbral.BrainNetData.GrupoDos+Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoDos;
        clear who_pos_conect_uno final_matriz_t_umbral
        
        
        
        %(5.1.2) Sigo haciendolo para los el SEGUNDO GRUPO pero ahora lo hago
        %sobre las metricas corregidas por FDR. Busco el 100% de las
        %correlaciones significativas pero solo me quedo con las corregidas
        %por FDR
        %De los resultado que obtengo genero una lista con los valores que
        %se mantiene significativos despues de aplicar el FDR. 
        if sum(who_pos_conect_uno_FDR)>0
        
                fdr_grupoDos_pos=find([Res_Umbral.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos{2:end,4}]<=0.05);

                %Genero/le agrego a la matriz que calcula los valores T para el
                %primer grupo, teniendo en cuenta las correlaciones positivas
                aux_matriz_t_umbral(seetings.areas,seetings.areas)=0;
                for i=1:length(fdr_grupoDos_pos)
                    aux_matriz_t_umbral(cell2mat(Res_Umbral.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos(fdr_grupoDos_pos(i)+1,7)))=cell2mat(Res_Umbral.Estadistica_ConectFDR.GrupoDos.GrupoDos_highPos(fdr_grupoDos_pos(i)+1,3));
                end

                matriz_aux=transpose(aux_matriz_t_umbral);
                final_matriz_t_umbral=aux_matriz_t_umbral+matriz_aux;
                clear matriz_aux aux_matriz_t_umbral
                Res_Umbral.BrainNetData.matriz_t_pos_GrupoDosFDR=final_matriz_t_umbral;

                %me hago una lista de cuales son los nodos que NO dan diferencias
                %significativas en la metrica pero que estan conectados con
                %aquellos que tienen diferencias significativas. Los guardo en una
                %variable que despues voy a reemplazar en la parte de los modulos
                all_nodes=nanmean(final_matriz_t_umbral,2);
                nodes_positive_con=find(Res_Umbral.BrainNetData.GrupoDosFDR<0);
                all_nodes(nodes_positive_con)=0;
                all_nodes(find(all_nodes<0))=1;
                Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoDosFDR=all_nodes;
                clear all_nodes nodes_positive_con

                %genero la variable que voy a utilizar en el BrainNet para
                %determinar el tamaño del nodo. Para eso sumo dos variables
                Res_Umbral.BrainNetData.pval_nopvals_t_posDos_nodesFDR=Res_Umbral.BrainNetData.GrupoDosFDR+Res_Umbral.BrainNetData.NopvalsModulos_t_pos_GrupoDosFDR;
                clear who_pos_conect_uno_FDR final_matriz_t_umbral fdr_grupoDos_pos
        else
        end
        clear who_pos_conect_uno_FDR
        
                
        %% (5) Guardo los resultados               
        %me fijo si existe la carpeta de la comparacion y, de no existir,
        %la creo
        cd(seetings.output_dir)
        existe=exist([seetings.GRUPO_uno(1:3),'vs',seetings.GRUPO_dos(1:3)],'dir');
        if existe==0 ;
            mkdir([seetings.GRUPO_uno(1:3),'vs',seetings.GRUPO_dos(1:3)]);
        else
        end
        cd([seetings.GRUPO_uno(1:3),'vs',seetings.GRUPO_dos(1:3)])
        clear existe
        
        save ([seetings.metricas{met},'_',seetings.GRUPO_uno(1:3),'vs',seetings.GRUPO_dos(1:3)],'Res_Densidad','Res_Pesadas','Res_Umbral')
       
%cierro el for con el cual recorro las metricas
clear Res_Densidad Res_Pesadas Res_Umbral gdos guno
end

