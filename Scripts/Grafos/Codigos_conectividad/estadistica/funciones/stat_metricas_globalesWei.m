function [Resultado_T Resultado_Rank Resultado_Perm]=stat_metricas_globalesWei(grupo_uno,grupo_dos,nombre_metrica,desvio_out)
%ESTA FUNCION SOLO CORRE PARA METRICAS CALCULADAS A PARTIR DE MATRICES
%PESADAS
%
%Esta funcion realiza la estadistica para dos grupos. Funciona para metricas globales calculadas sobre matrices pesadas
%Es decir, son metricas que brindan una caracteristica global de la red (ejemplos: path lenght, mean clustering, mean degree)
%
%--------- INPUTS-------------------
%GRUPO_UNO=matriz del primer grupo que se va a utilizar en la comparacion.
%La primera dimension es cada uno de los sujetos, la segunda dimension es
%cada uno de los steps en los cuales se calculo la metrica. 
%
%GRUPO_DOS=matriz del segundo grupo que se va a utilizar en la comparacion.
%La primera dimension es cada uno de los sujetos, la segunda dimension es
%cada uno de los steps en los cuales se calculo la metrica. 
%
%NOMBRE_METRICA=variable texto que contenga el nombre de la metrica que se
%esta comparando.
%
%DESVIO_OUT=valor que determina cuantos desvios se van a utilizar para
%determinar aquellos valores que sean outliers.
%
%--------- OUTPUT --------------------- 
%El output son tres estructuras, la primera de las pruebas T, la segunda de
%la prueba no paramétrica (RANKSUM) y la última de las permutaciones. Cada
%una de estas estructura contiene los valores p, t, valores p corregidos
%por el metodo de False Discovery Rate, el promedio y desvio de cada grupo,
%los valores crudos de cada grupo y una tabla resumen de los resultados (eso ultimo 
%no se realiza para las permutaciones)
%
%----------ORDEN ARGUMENTOS--------------
%[Resultado_T Resultado_Rank Resultado_Perm]=stat_metricas_globales(grupo_uno,grupo_dos,nombre_metrica,desvio_out)
%
%----------ADVERTENCIA---------------
%necesita las funciones "find_outlier", el "eeglab", "fdr_bh"

%% (0)
unos=grupo_uno;
dos=grupo_dos;

%% (1) Saco los outliers de cada grupo
%find_outliers
%(1.1)me fijo si tiene todos los argumentos que necesito
if nargin==3
    desvio_out=0;
else
end    
% (1.2)calculo el desvio para cada medida
if desvio_out>0
    %(1.2.1) Saco del primer grupo
    for i=1:length(unos(1,:))
        unos_out(:,i)=find_outlier(unos(:,i),desvio_out);
    end
    clear i
    %(1.2.2) Saco del segundo grupo
    for i=1:length(dos(1,:))
        dos_out(:,i)=find_outlier(dos(:,i),desvio_out);
    end
else
    unos_out=unos;
    dos_out=dos;
end
clear unos dos

%% (2) Saco los promedios y los desvios de cada grupo que despues me voy a guardar.
%calculo los promedios y desvios de los grupos para agregar este dato a
%la Tabla que construyo al final
promedio_uno=nanmean(unos_out);
desvio_uno=nanstd(unos_out);
promedio_dos=nanmean(dos_out);
desvio_dos=nanstd(dos_out);

%% (3) Hago la estadistica para la prueba T
%hago prueba T
[Resultado_T.H,Resultado_T.P,Resultado_T.CI,Resultado_T.STATS] = ttest2(unos_out,dos_out);

%% (4) Hago la estadistica para la prueba Ranksum (ojo que tengo que sacar los nans porque sino tira error)
%(estos valores en los que quite los nan tambien los uso para las permutaciones)
unos_out_aux=unos_out;
unos_out_aux(isnan(unos_out_aux))=[];

dos_out_aux=dos_out;
dos_out_aux(isnan(dos_out_aux))=[];

%hago prueba Ranksum
[Resultado_Rank.P,Resultado_Rank.H,Resultado_Rank.STATS] = ranksum(unos_out_aux,dos_out_aux);

%% (5)Hago la estadistica con las permutaciones teniendo en cuenta de que no tengo que colocar valores Nan
%Empiezo a hacer la permutacion
uno_perm(1,:,:)=unos_out_aux';        
dos_perm(1,:,:)=dos_out_aux';
clear unos_out_aux dos_out_aux
Permut{1}=uno_perm;
Permut{2}=dos_perm;
clear uno_perm dos_perm
[Resultado_Perm.T Resultado_Perm.DF Resultado_Perm.P] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);

clear Permut

%% (5) Guardo los promedios, desvios y la base de los sujetos a partir de
%la cual se hizo el analisis. Ademas, agrego el nombre de la metrica y los
%desvios.
%Para las Pruebas T
Resultado_T.meanGoupUno=promedio_uno;
Resultado_T.sdGroupUno=desvio_uno;

Resultado_T.meanGroupDos=promedio_dos;
Resultado_T.sdGroupDos=desvio_dos;

Resultado_T.GroupUno=unos_out;
Resultado_T.GroupDos=dos_out;

Resultado_T.metrica=nombre_metrica;
Resultado_T.desvio=desvio_out;

%Para las Pruebas Rank
Resultado_Rank.meanGoupUno=promedio_uno;
Resultado_Rank.sdGroupUno=desvio_uno;

Resultado_Rank.meanGroupDos=promedio_dos;
Resultado_Rank.sdGroupDos=desvio_dos;

Resultado_Rank.GroupUno=unos_out;
Resultado_Rank.GroupDos=dos_out;

Resultado_Rank.metrica=nombre_metrica;
Resultado_Rank.desvio=desvio_out;

%Para las Pruebas Perm
Resultado_Perm.meanGoupUno=promedio_uno;
Resultado_Perm.sdGroupUno=desvio_uno;

Resultado_Perm.meanGroupDos=promedio_dos;
Resultado_Perm.sdGroupDos=desvio_dos;

Resultado_Perm.GroupUno=unos_out;
Resultado_Perm.GroupDos=dos_out;

Resultado_Perm.metrica=nombre_metrica;
Resultado_Perm.desvio=desvio_out;

end
%% the end
%by hipereolo

