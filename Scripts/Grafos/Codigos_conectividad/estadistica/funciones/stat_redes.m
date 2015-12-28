function []=stat_redes(matriz_uno,matriz_dos,redes_uno,redes_dos,output_dir,estadistico,promedio,desvio_out)
%%-----------------------------INPUTS:-----------------------------------------
%
%matriz_uno= matriz cuadrada del grupo uno completa. 
%
%matriz_dos= matriz cuadrada del grupo dos completa.
%
%redes_uno= la primer serie de redes que quiero comparar contra la segunda
%serie. Necesita una estructura que tenga las siguientes partes: 
%                   - "redes_uno.label"= aca se coloca el nombre de la red
%                   en formato texto
%                   - "redes_uno.areas"=aca va la localizacion de los nodos
%                   que son parte de la red uno
%                   - "redes_uno.gruponame"=nombre del grupo, solo es necesario en el primer cell array 
%
%redes_dos= la segunda serie de redes que quiero comparar contra la primera
%serie. Necesita una estructura que tenga las siguientes partes: 
%                   - "redes_dos.label"= aca se coloca el nombre de la red
%                   en formato texto
%                   - "redes_dos.areas"=aca va la localizacion de los nodos
%                   que son parte de la red uno
%                   - "redes_dos.gruponame"=nombre del grupo, solo es necesario en el primer cell array
%
%output_dir=direccion en la cual quieren que se guarde la estadistica y los
%resultados, y los graficos
%
%estadistico= se elige que estadistico se quiere utilizar
%                   - 1= prueba t parametrica (default)
%                   - 2= prueba no parametrica
%
%promedio= 
%           - 1= hace promedio aritmetico de los nodos de la red (es el default)
%           - 2= hace un promedio absoluto
%           - 3= hace un promedio pero solo dejando los valores positivos,
%           no es un absoluto sino que ignora los valores negativos
%           - 4= hace un promedio pero solo dejando los valores negativos,
%           no es un absoluto sino que ignora los valores positivos
%
%desvio_out= es un numero que representa a partir de cuantos desvios por
%sobre la media un valores es considerado como outlier.
%
%----------------------- FUNCIONES---------------------------------------
%identity (by hipereolo)
%find_outlier (by hipereolo)
%xticklabel_rotate,%para rotar los xlabels

%% (0) HACER LOS NARGIN
if nargin==5
    estadistico=1;
    promedio=1;
    desvio_out=0;
elseif nargin==6
    estadistico;
    promedio=1;
    desvio_out=0;
elseif nargin==7
    estadistico;
    promedio;
    desvio_out=0;
elseif nargin==8
    estadistico;
    promedio;
    desvio_out;
else
    anuncio='Macho te faltan un par de variables, por lo menos'
end
    
%% (1) INICIALIZO la tabla en la cual voy a guardar los resultados
Tabla{1,1}='AreasVs';
Tabla{1,2}='pvals';
if estadistico==1
    Tabla{1,3}='T_test';
elseif estadistico==2
    Tabla{1,3}='Ranksum';
end
Tabla{1,4}='Controles_Mean';
Tabla{1,5}='Controles_SD';
Tabla{1,6}='Pacientes_Mean';
Tabla{1,7}='Pacientes_SD';

%% (2) Arranco el for para recorrer todas las redes que quiero comparar entre los grupos
%(2.1) La primer parte del for recorre las redes uno
for i=1:length(redes_uno(1,:))
    
    %(2.2) La segunda parte del for recorre las redes dos
    for r=1:length(redes_dos(1,:))
        
        %(2.3) Ahora extraigo para el grupo uno y el grupo dos los nodos
        %que pertenecen a las redes que estoy comparando y hago una media
        %por sujetos. De esa media saco los outliers si es que asi se le
        %indica a la funcion. 
        %grupo_uno
        cont=0;
        for grupo_uno=1:length(matriz_uno(1,1,:))
            cont=cont+1;
            suj_aux=matriz_uno(redes_uno(1,i).areas,redes_dos(1,r).areas,grupo_uno);
            %corro la funcion identity para sacar los valores repetidos de
            %correlacion y los valores 1
            suj_aux=identity(suj_aux);
            %reshapeo la info del sujeto para despues poder hacer el
            %promedio y que tome todos los nodos
            suj_reshape=reshape(suj_aux,1,length(suj_aux(1,:))*length(suj_aux(:,1)));
            %hago el promedio acorde a como se eligio hacer
                if promedio==1
                    sujetos_uno(1,cont)=nanmean(suj_reshape);
                elseif promedio==2
                    sujetos_uno(1,cont)=nanmean(abs(suj_reshape));
                elseif promedio==3
                    sujetos_uno(1,cont)=nanmean(suj_reshape(find(suj_reshape>0)));
                else promedio==4
                    sujetos_uno(1,cont)=nanmean(suj_reshape(find(suj_reshape<0)));
                end
                clear suj_reshape suj_aux
        end
        clear cont
        
        %grupo_dos
        cont=0;
        for grupo_dos=1:length(matriz_dos(1,1,:))
            cont=cont+1;
            suj_aux=matriz_dos(redes_uno(1,i).areas,redes_dos(1,r).areas,grupo_dos);
            %corro la funcion identity para sacar los valores repetidos de
            %correlacion y los valores 1
            suj_aux=identity(suj_aux);
            %reshapeo la info del sujeto para despues poder hacer el
            %promedio y que tome todos los nodos
            suj_reshape=reshape(suj_aux,1,length(suj_aux(1,:))*length(suj_aux(:,1)));
            %hago el promedio acorde a como se eligio hacer
                if promedio==1
                    sujetos_dos(1,cont)=nanmean(suj_reshape);
                elseif promedio==2
                    sujetos_dos(1,cont)=nanmean(abs(suj_reshape));
                elseif promedio==3
                    sujetos_dos(1,cont)=nanmean(suj_reshape(find(suj_reshape>0)));
                else promedio==4
                    sujetos_dos(1,cont)=nanmean(suj_reshape(find(suj_reshape<0)));
                end
                clear suj_reshape suj_aux
        end
        clear cont

                        
        %(2.4) Me fijo si hay outliers en cada uno de los grupos utilizando
        %la funcion find_outliers. Esto lo hace si se le indico a la
        %funcion y para ambos grupos             
        if desvio_out>0
            suj_uno_final=find_outlier(sujetos_uno,desvio_out);
            suj_dos_final=find_outlier(sujetos_dos,desvio_out);
            clear sujetos_uno sujetos_dos
        else
            suj_uno_final=sujetos_uno;
            suj_dos_final=sujetos_dos;
            clear sujetos_uno sujetos_dos
        end
        
        %(2.5) Hago la estadistica. Va a ser una t parametrica o no
        %parametrica de acuerdo a lo que se indique. La t parametrica es la
        %default
        if estadistico==1
                [Resultado.H,Resultado.P,Resultado.CI,Resultado.STATS] = ttest2(suj_uno_final,suj_dos_final);
        elseif estadistico==2
                [Resultado.P,Resultado.H,Resultado.STATS] = ranksum(suj_uno_final,suj_dos_final);
        end
        
        %(2.6) Guardo los datos en la tabla final que despues voy a levantar
        lugar=length(Tabla(:,1))+1;
        Tabla{lugar,1}=[redes_uno(1,i).label,'_Vs_',redes_dos(1,r).label];
        Tabla{lugar,2}=Resultado.P;
        if estadistico==1
            Tabla{lugar,3}=Resultado.STATS.tstat(1,1);
           elseif estadistico==2
            Tabla{lugar,3}=Resultado.STATS(1,1).ranksum;
        end  
        Tabla{lugar,4}=nanmean(suj_uno_final);
        Tabla{lugar,5}=nanstd(suj_uno_final);
        Tabla{lugar,6}=nanmean(suj_dos_final);
        Tabla{lugar,7}=nanstd(suj_dos_final);
        
        %(2.7) Comienzo a armar la matriz con los pvalues de las
        %comparaciones
        matriz_pvals(i,r)=Resultado.P;
        if estadistico==1
           matriz_tvals(i,r)=Resultado.STATS.tstat(1,1);
           elseif estadistico==2
            matriz_tvals(i,r)=Resultado.STATS(1,1).ranksum;
        end  
        matriz_labels{i,r}=[redes_uno(1,i).label,'_Vs_',redes_dos(1,r).label];
       
        %cierro el for que recorre las areas numero dos
        clear lugar suj_uno_final suj_dos_final Resultado
    end
   
    %cierro el for que recorrer las areas numero uno
     
end

%% (3) Creo la carpeta donde voy a guardar los resultados y los graficos
cd(output_dir)
existe=exist ([redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)],'dir');
if existe==0;
    mkdir([redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)]);
else
end
cd ([output_dir,'/',[redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)]])

%% (4) Hago los graficos: uno para los valores t, otro para los valores p, 
%otro con todo aquello que esta por arriba de pvals 0.05
%(4.1)grafico para valores t
h=figure('Visible','Off');
imagesc(matriz_tvals)
colorbar
caxis ([-2.5 2.5]);
%cambio el tamaño del grafico
x0=10;y0=10;width=750;height=600;
set(gcf,'units','points','position',[x0,y0,width,height]);
%pongo ejes
set(gca, 'YTick',1:length(redes_uno(1,:)), 'YTickLabel',{redes_uno.label})
set(gca, 'XTick',1:length(redes_dos(1,:)), 'XTickLabel',{redes_dos.label})
xticklabel_rotate([],60,[]);
title (['Tvals ',redes_uno(1,1).gruponame,' Vs ',redes_dos(1,1).gruponame],'FontSize',14,'FontWeight','bold')
saveas(h,['Tvals_',redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)],'jpg')
%min=min(reshape(matriz_tvals,1,length(matriz_tvals(:,1))*length(matriz_tvals(1,:))));
close all
%(4.2)grafico para pvals
f=figure('Visible','Off');
imagesc(matriz_pvals)
colorbar
caxis ([0 0.05]);
%cambio el tamaño del grafico
x0=10;y0=10;width=750;height=600;
set(gcf,'units','points','position',[x0,y0,width,height]);
%pongo ejes
set(gca, 'YTick',1:length(redes_uno(1,:)), 'YTickLabel',{redes_uno.label})
set(gca, 'XTick',1:length(redes_dos(1,:)), 'XTickLabel',{redes_dos.label})
xticklabel_rotate([],60,[]);
title (['Pvals ',redes_uno(1,1).gruponame,' Vs ',redes_dos(1,1).gruponame],'FontSize',14,'FontWeight','bold')
saveas(f,['Pvals_',redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)],'jpg')
close all
%min=min(reshape(matriz_tvals,1,length(matriz_tvals(:,1))*length(matriz_tvals(1,:))));
%(4.3)grafico para pvals pero en valores 0 y 1
%1=indica diferencia significativa
%0=indica que no hay diferencia significativa
g=figure('Visible','Off');
matriz_pvals_umbral(1:length(matriz_pvals(:,1)),1:length(matriz_pvals(1,:)))=0;
umbral=find(matriz_pvals<0.04999);
matriz_pvals_umbral(umbral)=1;
imagesc(matriz_pvals_umbral)
colorbar
caxis ([0 1]);
%cambio el tamaño del grafico
x0=10;y0=10;width=750;height=600;
set(gcf,'units','points','position',[x0,y0,width,height]);
%pongo ejes
set(gca, 'YTick',1:length(redes_uno(1,:)), 'YTickLabel',{redes_uno.label})
set(gca, 'XTick',1:length(redes_dos(1,:)), 'XTickLabel',{redes_dos.label})
xticklabel_rotate([],60,[]);
title (['PvalsUmb ',redes_uno(1,1).gruponame,' Vs ',redes_dos(1,1).gruponame],'FontSize',14,'FontWeight','bold')
saveas(g,['PvalsUmb_',redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)],'jpg')
close all
clear matriz_pvals_umbral
%(4.4)grafico para pvals pero ploteando direcciones de las diferencias
%1=indica diferencia significativa mayor en pacientes
%-1=indica diferencia significativa mayor en controles
k=figure('Visible','Off');
matriz_direct(1:length(matriz_pvals(:,1)),1:length(matriz_pvals(1,:)))=0;
umbral=find(matriz_pvals<0.04999);
matriz_direct(umbral)=matriz_tvals(umbral);
matriz_direct(find(matriz_direct>1))=1;
matriz_direct(find(matriz_direct<-1))=-1;
imagesc(matriz_direct)
colorbar
caxis ([-1 1]);
%cambio el tamaño del grafico
x0=10;y0=10;width=750;height=600;
set(gcf,'units','points','position',[x0,y0,width,height]);
%pongo ejes
set(gca, 'YTick',1:length(redes_uno(1,:)), 'YTickLabel',{redes_uno.label},'fontsize',10)


set(gca, 'XTick',1:length(redes_dos(1,:)), 'XTickLabel',{redes_dos.label},'fontsize',8)%%%modifque
xticklabel_rotate([],25,[]); %%% modifique


title (['Direccion Dif ',redes_uno(1,1).gruponame,' Vs ',redes_dos(1,1).gruponame,'  +GRUPO UNO:+1 // +GRUPO DOS:-1 '],'FontSize',14,'FontWeight','bold')

saveas(k,['Direccion_Dif_',redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)],'epsc')
close all
clear matriz_pvals_umbral
%% (5) Guardo los resultados (basicamente la Tabla)
save ([redes_uno(1,1).gruponame(1:3),'_Vs_',redes_dos(1,1).gruponame(1:3)],'matriz_labels','matriz_pvals','matriz_tvals','desvio_out','Tabla')
       
        
end

%by hipereolo 2014
        
