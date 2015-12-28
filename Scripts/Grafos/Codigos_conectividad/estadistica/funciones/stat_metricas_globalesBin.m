function [Resultado_T Resultado_Rank Resultado_Perm]=stat_metricas_globalesBin(grupo_uno,grupo_dos,nombre_metrica,desvio_out)
%ESTA FUNCION SOLO CORRE PARA METRICAS CALCULADAS A PARTIR DE LOS METODOS
%DE UMBRAL Y DENSIDAD
%
%Esta funcion realiza la estadistica para dos grupos. Funciona para metricas globales calculadas con metodos por 
%stepts. Es decir, son metricas calculadas sobre distintas redes del mismo
%sujeto y que brindan una caracteristica global de la red (ejemplos: path lenght, mean clustering, mean degree)
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

%% (1) Hago los promedios paso por paso para las comapraciones con pruebas T y Ranksum
%(1.1)Calculo los pasos que voy a dar que vayan de 50 en 50
pasos=1:50:length(unos);

for te=1:length(pasos)-1;
    
    %hago el promedio para el GRUPO UNO de los pasos
    aux=unos(:,pasos(te):pasos(te+1)-1);
    aux_unos(:,te)=nanmean(aux,2);
    clear aux
    
    %hago el promedio para el GRUPO DOS de los pasos
    aux=dos(:,pasos(te):pasos(te+1)-1);
    aux_dos(:,te)=nanmean(aux,2);
    clear aux
end
clear te

%% (2) Ahora si saco los outliers
%find-outliers
if nargin==3
    desvio_out=0;
else
end    
% (2.2)calculo el desvio para cada medida
if desvio_out>0
    %(1.2.1) Saco del primer grupo
    for i=1:length(aux_unos(1,:))
        unos_out(:,i)=find_outlier(aux_unos(:,i),desvio_out);
    end
    clear i
    %(2.2.2) Saco del segundo grupo
    for i=1:length(aux_dos(1,:))
        dos_out(:,i)=find_outlier(aux_dos(:,i),desvio_out);
    end
    clear i
else
    unos_out=unos;
    dos_out=dos;
end
clear aux_unos aux_dos

%% (3) Calculo los promedios y los desvios que despues voy a guardar
%calculo los promedios y desvios de los grupos para agregar este dato a
%la Tabla que construyo al final
for i=1:length(unos_out(1,:))
    promedio_uno(1,i)=nanmean(unos_out(:,i));
    desvio_uno(1,i)=nanstd(unos_out(:,i));
    promedio_dos(1,i)=nanmean(dos_out(:,i));
    desvio_dos(1,i)=nanstd(dos_out(:,i));
end
clear i

%% (3) Hago la estadistica para la prueba T
for i=1:length(unos_out(1,:))
    
    [Resultado_T(1,i).H,Resultado_T(1,i).P,Resultado_T(1,i).CI,Resultado_T(1,i).STATS] = ttest2(unos_out(:,i),dos_out(:,i));
end
clear i

%% (4) Hago la estdistica para la prueba Ranksum (le tengo que sacar los valores NaN porque sino tira error)
for i=1:length(unos_out(1,:))
    
    unos_out_aux=unos_out(:,i);
    unos_out_aux(isnan(unos_out_aux))=[];
    
    dos_out_aux=dos_out(:,i);
    dos_out_aux(isnan(dos_out_aux))=[];
    
    %agrego estas lineas de "isempty" y el if ya que los ultimos pasos de
    %algunas metricas con el metodo de umbral tiene valores ceros. Esto
    %genera valores nan, que luego extraigo y deja variables vacias Ante
    %estas variables vacias la funcion ranksum tira error. Asi lo que hago
    %es fijarme que, cuando haya variables vacias, no haga la estadistica
    %sino que directamente le ponga valores NaN a los resultados.
    vacio_uno=~isempty(unos_out_aux);
    vacio_dos=~isempty(dos_out_aux);
    
    if vacio_uno>0 && vacio_dos>0 && length(unos_out)>1 && length(dos_out_aux)>1
        [Resultado_Rank(1,i).P,Resultado_Rank(1,i).H,Resultado_Rank(1,i).STATS] = ranksum(unos_out_aux,dos_out_aux);
    else
        Resultado_Rank(1,i).P=NaN;
        Resultado_Rank(1,i).H=NaN;
        Resultado_Rank(1,i).STATS.ranksum=NaN;
    end
    clear unos_out_aux dos_out_aux vacio_uno vacio_dos
end
clear i


%% (5) Hago la permutacion
%(5.1) Primero tengo que sacar los outliers pero ahora de cada step
%find_outliers
%(1.1)me fijo si tiene todos los argumentos que necesito
if nargin==3
    desvio_out=0;
else
end    
% (5.2)calculo el desvio para cada medida
if desvio_out>0
    %(5.2.1) Saco del primer grupo
    for i=1:length(unos(1,:))
        unos_perm(:,i)=find_outlier(unos(:,i),desvio_out);
    end
    clear i
    %(5.2.2) Saco del segundo grupo
    for i=1:length(dos(1,:))
        dos_perm(:,i)=find_outlier(dos(:,i),desvio_out);
    end
else
    unos_perm=unos;
    dos_perm=dos;
end
clear unos dos

%(5.3)Hago un for para hacer cada uno de los puntos porque la funcio statcond de
%eeglab no se banca que haya NANs que surgen de cuando saco los valores
%otulires. 

for p=1:length(unos_perm)
    
    %saco cada uno de los puntos de steps y los pongo en una columna por
    %separado
    aux_per_uno=unos_perm(:,p);
    aux_per_dos=dos_perm(:,p);
    %saco todos los nans que pueden llegar a haber en cada gurpo y los
    %reemplazo por una celda vacia
    %grupo uno
    if sum(isnan(aux_per_uno))>0     
        aux_per_uno(isnan(aux_per_uno))=[];
    else
    end
    %grupo dos
    if sum(isnan(aux_per_dos))>0     
        aux_per_dos(isnan(aux_per_dos))=[];
    else
    end
    
    
    %agrego estas lineas de "isempty" y el if ya que los ultimos pasos de
    %algunas metricas con el metodo de umbral tiene valores ceros. Esto
    %genera valores nan, que luego extraigo y deja variables vacias Ante
    %estas variables vacias la funcion ranksum tira error. Asi lo que hago
    %es fijarme que, cuando haya variables vacias, no haga la estadistica
    %sino que directamente le ponga valores NaN a los resultados.
    vacio_uno=~isempty(aux_per_uno);
    vacio_dos=~isempty(aux_per_dos);
    
    if vacio_uno>0 && vacio_dos>0 && length(aux_per_uno)>1 && length(aux_per_dos)>1
            %Empiezo a hacer la permutacion
           
            uno_permutacion(1,:,:)=aux_per_uno';        
            
            dos_permutacion(1,:,:)=aux_per_dos';
            
            clear aux_per_uno aux_per_dos
            Permut{1}=uno_permutacion;
            Permut{2}=dos_permutacion;
            clear uno_permutacion dos_permutacion
            [Resultado_Perm.T(1,p), Resultado_Perm.DF(1,p), Resultado_Perm.P(1,p)] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);
            clear Permut
    else
           Resultado_Perm.T(1,p)=NaN; 
           Resultado_Perm.DF(1,p)=NaN; 
           Resultado_Perm.P(1,p)=NaN;
    end
 
    %cierro el for de las permutaciones
    clear vacio_uno vacio_dos
end

%% (6) Hago la correccion de FDR para cada uno de los metodos. Esta informacion se le agrego a cada una de las 
%estructuras que despues voy a utilizar para generar las Tablas
%Correspondientes
%(6.1) Para la Prueba T
t_valores_p=[Resultado_T.P];
%saco los valores NaN para que no los tenga en cuenta el FDR
lugares_nan=isnan(t_valores_p);
lugares_valor=~isnan(t_valores_p);
t_valores_p(lugares_nan)=[];
%calculo las p corregidas
[h crit_p t_valores_pCorr]=fdr_bh(t_valores_p,.05,'pdep','no');
clear h crit_p
t_valores_aux(lugares_valor)=t_valores_pCorr;
t_valores_aux(lugares_nan)=NaN;
clear t_valores_pCorr
t_valores_pCorr=t_valores_aux;
clear t_valores_aux
clear lugares_nan lugares_valor


%(6.2) Para la Prueba RankSum
r_valores_p=[Resultado_Rank.P];
%saco los valores NaN para que no los tenga en cuenta el FDR
lugares_nan=isnan(r_valores_p);
lugares_valor=~isnan(r_valores_p);
r_valores_p(lugares_nan)=[];
%calculo las p corregidas
[h crit_p r_valores_pCorr]=fdr_bh(r_valores_p,.05,'pdep','no');
clear h crit_p
r_valores_aux(lugares_valor)=r_valores_pCorr;
r_valores_aux(lugares_nan)=NaN;
clear r_valores_pCorr
r_valores_pCorr=r_valores_aux;
clear r_valores_aux
clear lugares_nan lugares_valor

%(6.3) Para la Prueba de Permutaciones
perm_valores_p=Resultado_Perm.P;
lugares_nan=isnan(perm_valores_p);
lugares_valor=~isnan(perm_valores_p);
perm_valores_p(lugares_nan)=[];
[h crit_p perm_valores_pCorr]=fdr_bh(perm_valores_p,.05,'pdep','no');
clear h crit_p
perm_valores_aux(lugares_valor)=perm_valores_pCorr;
perm_valores_aux(lugares_nan)=NaN;
clear perm_valores_pCorr
perm_valores_pCorr=perm_valores_aux;
clear perm_valores_aux
clear lugares_nan lugares_valor


%% (7) Guardo toda la info en una Tabla para cada comparacion que despues voy a guardar
%en su estructura

%(4.1) Prueba T
%Inicializo la tabla
Tabla_t{1,1}='Pasos';
Tabla_t{1,2}='P_value';
Tabla_t{1,3}='P_corrFDR';
Tabla_t{1,4}='T_value';
Tabla_t{1,5}='Mean_C';
Tabla_t{1,6}='SD_C';
Tabla_t{1,7}='Mean_P';
Tabla_t{1,8}='SD_P';
%Guardo en la Tabla los valores de t
for i=1:length(Resultado_T(1,:))
    
    Tabla_t{i+1,1}=[num2str(pasos(i)),'_',num2str(pasos(i+1))];
    Tabla_t{i+1,2}=Resultado_T(1,i).P;
    Tabla_t{i+1,3}=t_valores_pCorr(1,i);
    Tabla_t{i+1,4}=Resultado_T(1,i).STATS.tstat;
    Tabla_t{i+1,5}=promedio_uno(1,i);
    Tabla_t{i+1,6}=desvio_uno(1,i);
    Tabla_t{i+1,7}=promedio_dos(1,i);
    Tabla_t{i+1,8}=desvio_dos(1,i);
    
end
clear i
%guardo la tabla en la estructura "Resultado_T" en cada uno de los pasos
for i=1:length(Resultado_T)
    Resultado_T(1,i).Tabla=Tabla_t;
    Resultado_T(1,i).GrupoUno=unos_out;
    Resultado_T(1,i).GrupoDos=dos_out;
    Resultado_T(1,i).Metrica=nombre_metrica;
    Resultado_T(1,i).desvio=desvio_out;
    
end
clear i

clear Tabla_t t_valores_p t_valores_pCorr

%(4.2)Tabla para Ranksum
%Inicializo la Tabla
Tabla_R{1,1}='Pasos';
Tabla_R{1,2}='P_value';
Tabla_R{1,3}='P_corrFDR';
Tabla_R{1,4}='R_value';
Tabla_R{1,5}='Mean_C';
Tabla_R{1,6}='SD_C';
Tabla_R{1,7}='Mean_P';
Tabla_R{1,8}='SD_P';
%Guardo en la Tabla los valores de Ranksum
for i=1:length(Resultado_Rank(1,:))
    
    Tabla_R{i+1,1}=[num2str(pasos(i)),'_',num2str(pasos(i+1))];
    Tabla_R{i+1,2}=Resultado_Rank(1,i).P;
    Tabla_R{i+1,3}=r_valores_pCorr(1,i);
    Tabla_R{i+1,4}=Resultado_Rank(1,i).STATS.ranksum;
    Tabla_R{i+1,5}=promedio_uno(1,i);
    Tabla_R{i+1,6}=desvio_uno(1,i);
    Tabla_R{i+1,7}=promedio_dos(1,i);
    Tabla_R{i+1,8}=desvio_dos(1,i);
    
end
%guardo la tabla en la estructura "Resultado_Rank" en cada uno de los pasos
for i=1:length(Resultado_Rank)
    Resultado_Rank(1,i).Tabla=Tabla_R;
    Resultado_Rank(1,i).GrupoUno=unos_out;
    Resultado_Rank(1,i).GrupoDos=dos_out;
    Resultado_Rank(1,i).Metrica=nombre_metrica;
    Resultado_Rank(1,i).desvio=desvio_out;
end
clear i

clear Tabla_R r_valores_p r_valores_pCorr pasos 

%(4.3)No hago una tabla para las permutacioens porque vamos a ver los graficos
%pero guardo una variable con el promedio y otra con el desvio para cada
%grupo y, ademas, guardo la variable que tiene las p corregidas
Resultado_Perm.PcorFDR=perm_valores_pCorr;
Resultado_Perm.GrupoUno=unos_perm;
Resultado_Perm.GrupoDos=dos_perm;

for i=1:length(unos_perm)
    
    Resultado_Perm.promedio_GrupUno(1,i)=nanmean(unos_perm(:,i));
    Resultado_Perm.desvio_GrupUno(1,i)=nanstd(unos_perm(:,i));
    Resultado_Perm.promedio_GrupDos(1,i)=nanmean(dos_perm(:,i));
    Resultado_Perm.desvio_GrupDos(1,i)=nanmean(dos_perm(:,i));
    
end
clear i
clear perm_valores_pCorr
Resultado_Perm.Metrica=nombre_metrica;
Resultado_Perm.desvio=desvio_out;


end
%% the end
%by hipereolo

