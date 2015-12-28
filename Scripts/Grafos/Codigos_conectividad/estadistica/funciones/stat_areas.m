function [Tabla, Controles, Pacientes]=stat_areas(matriz_uno,matriz_dos,area_uno,area_dos,rois_lista,estadistico,percentil,desvio_out)
%Esta funcion permite calcular una prueba t parametrica o no parametrica a
%un conjunto de areas.
%
%INPUTS
%matriz_uno=una matriz de tres dimensiones, cuyas dos primeras dimensiones
%sean areas y la tercera dimension sea el grupo de sujetos (esta primer variable es la que 
%despues se llama CONTROLES en la Tabla)
%matriz_dos=una matriz de tres dimensiones, cuyas dos primeras dimensiones
%sean areas y la tercera dimension sea el grupo de sujetos (esta primer variable es la que 
%despues se llama PACIENTES en la Tabla)
%area_uno=primer grupo de areas cuya correlacion quiero medir
%area_dos=segundo grupo de areas cuya correlacion quiero medir
%rois_lista=lista de las areas que se usaron para construir el atlas. Tiene
%que ser un vector ordenado de la misma manera que las areas con las cuales
%se construyeron las matrices en matriz_uno y matriz_dos. Tiene que ser un
%vector texto que tiene que tener las mismas dimensiones que las matrices. 
%estadistico=1, prueba ttest2 // estadistico=2, prueba no parametrica Ranksum //
%percentil=elige cual es el valor que deja por arriba a X% de la muestra,
%ejemplo, el percentil 20 elije un valor que deja por arriba al 20% de la
%muestra de valores p
%
%desvio_out=opcional si quiero sacar outliers, indico cuantos desvios por
%arriba y por debajo de la media quiero sacar. 
%
%OUTPUTS=una tabla que tiene en la primer columna cuales son las areas que
%se estan comparando, en la segunda columna los pvals, en la tercera
%columna los valores t, en la tercer columna las medias de los controles y
%en la cuarta columna las medias de los pacientes
%
%ADVERTENCIA=
%Esta funcion necesita que este en el path la funcion identity y la funcion
%find_outliers


%% (0) Ordeno el atlas en funcion de las areas que se van a explorar para 
%tener las etiquetas listas para la tabla
%genero una lista con los nombres de las primeras areas que quiero comparar
%contra
for i=1:length(area_uno)
    lista_uno{1,i}=rois_lista{area_uno(i)};
end
clear i
%genero la lista de las segundas areas
for i=1:length(area_dos)
    lista_dos{1,i}=rois_lista{area_dos(i)};
end
clear i
%creo el atlas para esta comparacion
for i=1:length(lista_uno)
    for r=1:length(lista_dos)
        atlas_label{r,i}=([lista_uno{i},'_vs_',lista_dos{r}]);
    end
end
clear i  lista_uno lista_dos r
%reshapeo el atlas para que quede en un solo vector. Esto lo hago ya que
%despues los valores p los voy a tener en un solo vector y me va a ser mas
%facil asociarlos
atlas=reshape(atlas_label,1,length(area_uno)*length(area_dos));
clear atlas_label

%% (1) De las matrices que ingrese me quedo nada mas que con las areas que necesito
%primero selecciono las areas de la matriz uno
aux=matriz_uno(area_uno,area_dos,:);
clear matriz_uno
matriz_uno=aux;
clear aux

%selecciono las areas de la matriz dos
aux=matriz_dos(area_uno,area_dos,:);
clear matriz_dos
matriz_dos=aux;
clear aux

%% (2) Usando la funcion identity le saco a la matriz de cada sujeto los valores que tiene repetidos y los ceros
%lo hago para cada matriz por separado por si ingresamos alguna con
%distinto numero de sujetos
%matriz_uno
for i=1:length(matriz_uno(1,1,:))
    aux(:,:,i)=identity(matriz_uno(:,:,i));
end
clear matriz_uno
matriz_uno=aux;
clear aux
%matriz_dos
for i=1:length(matriz_dos(1,1,:))
    aux(:,:,i)=identity(matriz_dos(:,:,i));
end
clear matriz_dos
matriz_dos=aux;
clear aux i

%% (3) Reshapeo las matrices y las doy vuelta para que en la primera dimension me queden los sujetos
%y en la segunda dimension las areas a partir de las cuales voy a hacer la
%comparacion
%matriz_uno
aux=reshape(matriz_uno,length(area_uno)*length(area_dos),length(matriz_uno(1,1,:)));
aux=aux';
unos=aux;
clear aux;
%matriz_dos
aux=reshape(matriz_dos,length(area_uno)*length(area_dos),length(matriz_dos(1,1,:)));
aux=aux';
dos=aux;
clear aux;

%% (4) Saco de las matrices reshapeadas los outliers de cada comparacion utilizando la funcion
%find_outliers
%(4.1)me fijo si tiene todos los argumentos que necesito
if nargin==7
    desvio_out=0;
else
end    
% (4.2)calculo el desvio para cada medida
if desvio_out>0
    %(4.1) Saco del primer grupo
    for i=1:length(unos(1,:))
        unos_out(:,i)=find_outlier(unos(:,i),desvio_out);
    end
    %(4.2) Saco del segundo grupo
    for i=1:length(dos(1,:))
        dos_out(:,i)=find_outlier(dos(:,i),desvio_out);
    end
else
    unos_out=unos;
    dos_out=dos;
end

%% (5) Hago la prueba estadistica que corresponda de acuerdo a lo que haya elegido el usuario
if estadistico==1
    [Resultado.H,Resultado.P,Resultado.CI,Resultado.STATS] = ttest2(unos_out,dos_out);
elseif estadistico==2
    for i=1:length(unos)
        [Resultado.P(1,i),Resultado.H(1,i),Resultado.STATS(1,i)] = ranksum(unos_out(:,i),dos_out(:,i));
    end
end


%% (6) Calculo cual es el valor p que me deja en el percentil elegido por el usuario
%calculo el thres pvals en funcion de todos los valores p obtenidos
aux_pvals=Resultado.P(find(Resultado.P<=0.05));
%percentil elige cual es el valor que deja por arriba a X% de la muestra,
%ejemplo, el percentil 20 elije un valor que deja por arriba al 20% de la
%muestra de valores p
thres_pval= prctile(aux_pvals,percentil);
clear aux_pvals
lugares_pvals=find(Resultado.P<=thres_pval);

%% (7) Arranco la tabla
%inicializo tabla
Tabla{1,1}='AreasVs';
Tabla{1,2}=['pvals_',num2str(percentil)];
if estadistico==1
    Tabla{1,3}='T_test';
elseif estadistico==2
    Tabla{1,3}='Ranksum';
end
Tabla{1,4}='Controles';
Tabla{1,5}='Pacientes';
%guardo datos en tabla
cont=1;
for i=lugares_pvals
    cont=cont+1;
    Tabla{cont,1}=atlas(i);
    Tabla{cont,2}=Resultado.P(i);
    if estadistico==1
       Tabla{cont,3}=Resultado.STATS.tstat(1,i);
    elseif estadistico==2
        Tabla{cont,3}=Resultado.STATS(1,i).ranksum;
    end      
    Tabla{cont,4}=nanmean(unos_out(:,i));
    Tabla{cont,5}=nanmean(dos_out(:,i));       
end

%% (7) Reconstruyo una matriz con las etiquetas vs teniendo en cuenta TODAS las areas ingresadas
%del atlas para ver en que ubicacion se encuentran 
for i=1:length(rois_lista)
    lista_uno{1,i}=rois_lista{i};
end
clear i
%genero la lista de las segundas areas
for i=1:length(rois_lista)
    lista_dos{1,i}=rois_lista{i};
end
clear i
%creo el atlas para esta comparacion
for i=1:length(lista_uno)
    for r=1:length(lista_dos)
        atlas_label{r,i}=([lista_uno{i},'_vs_',lista_dos{r}]);
    end
end
clear i  lista_uno lista_dos r

%% (8) Ahora me tomo el trabajo de buscar todas las areas que encontre significativas
%y me guardo en que area de la matriz esta
Tabla{1,6}='Lugares_atlas';

for i=1:length(Tabla)-1
  
    Tabla{i+1,6}=find(strcmp(Tabla{i+1,1}, atlas_label));

end

%% (9) Ahora creo las tres tablas para los controles separandolos de los pacientes
%(9.1) Primero saco todas las que son mayores en los controles
Cont_high{1,1}='AreasVs';
Cont_high{1,2}='pvals';
Cont_high{1,3}='T_test';
Cont_high{1,4}='Rho_Cont';
Cont_high{1,5}='Rho_Pac';
Cont_high{1,6}='Lugares_atlas';

cont=0;
for i=1:length(Tabla)-1
    if Tabla{i+1,4} > Tabla{i+1,5}
        cont=cont+1;
        Cont_high{cont+1,1}=Tabla{i+1,1};
        Cont_high{cont+1,2}=Tabla{i+1,2};
        Cont_high{cont+1,3}=Tabla{i+1,3};
        Cont_high{cont+1,4}=Tabla{i+1,4};
        Cont_high{cont+1,5}=Tabla{i+1,5};
        Cont_high{cont+1,6}=Tabla{i+1,6};
    else
    end
end
%(9.2) Ahora me quedo solo con las comparaciones positivas
Cont_highPos{1,1}='AreasVs';
Cont_highPos{1,2}='pvals';
Cont_highPos{1,3}='T_test';
Cont_highPos{1,4}='Rho_Cont';
Cont_highPos{1,5}='Rho_Pac';
Cont_highPos{1,6}='Lugares_atlas';
cont=0;
for i=1:length(Cont_high)-1
    
    if Cont_high{i+1,4}<0 && Cont_high{i+1,5}<0
    else
        cont=cont+1;
        Cont_highPos{cont+1,1}=Cont_high{i+1,1};
        Cont_highPos{cont+1,2}=Cont_high{i+1,2};
        Cont_highPos{cont+1,3}=Cont_high{i+1,3};
        Cont_highPos{cont+1,4}=Cont_high{i+1,4};
        Cont_highPos{cont+1,5}=Cont_high{i+1,5};
        Cont_highPos{cont+1,6}=Cont_high{i+1,6};
    end
end
%(9.3) Ahora me quedo solo con las negativas
Cont_highNeg{1,1}='AreasVs';
Cont_highNeg{1,2}='pvals';
Cont_highNeg{1,3}='T_test';
Cont_highNeg{1,4}='Rho_Cont';
Cont_highNeg{1,5}='Rho_Pac';
Cont_highNeg{1,6}='Lugares_atlas';
cont=0;
for i=1:length(Cont_high)-1
    
    if Cont_high{i+1,4}<0 && Cont_high{i+1,5}<0
        cont=cont+1;
        Cont_highNeg{cont+1,1}=Cont_high{i+1,1};
        Cont_highNeg{cont+1,2}=Cont_high{i+1,2};
        Cont_highNeg{cont+1,3}=Cont_high{i+1,3};
        Cont_highNeg{cont+1,4}=Cont_high{i+1,4};
        Cont_highNeg{cont+1,5}=Cont_high{i+1,5};
        Cont_highNeg{cont+1,6}=Cont_high{i+1,6};
    else
    end
end

Controles.GroupOne_high=Cont_high;
Controles.GroupOne_highPos=Cont_highPos;
Controles.GroupOne_highNeg=Cont_highNeg;
if desvio_out>0
    Controles.outliers=unos_out;
    Controles.desvio_Out=num2str(desvio_out);
else
    Controles.rawdata=unos;
end
    
clear Cont_high Cont_highPos Cont_highNeg unos_out unos

%% (11) Creo la matriz para los sujetos poniendo TODO el atlas para CONTROLES
%empiezo por highPOS
matriz(1:length(rois_lista),1:length(rois_lista))=0;
matriz([Controles.GroupOne_highPos{2:end,6}])=1;
matriz_aux=transpose(matriz);
Controles.matGUHighPos=matriz_aux+matriz;
clear matriz matriz_aux
%empiezo con los highNeg
matriz(1:length(rois_lista),1:length(rois_lista))=0;
matriz([Controles.GroupOne_highNeg{2:end,6}])=1;
matriz_aux=transpose(matriz);
Controles.matGULessNEG=matriz_aux+matriz;
clear matriz matriz_aux

%% (12) Ahora creo las tres tablas para los PACIENTES separandolos de los pacientes
%(12.1) Primero saco todas las que son mayores en los controles
Pac_high{1,1}='AreasVs';
Pac_high{1,2}='pvals';
Pac_high{1,3}='T_test';
Pac_high{1,4}='Rho_Cont';
Pac_high{1,5}='Rho_Pac';
Pac_high{1,6}='Lugares_atlas';

cont=0;
for i=1:length(Tabla)-1
    if Tabla{i+1,4} < Tabla{i+1,5}
        cont=cont+1;
        Pac_high{cont+1,1}=Tabla{i+1,1};
        Pac_high{cont+1,2}=Tabla{i+1,2};
        Pac_high{cont+1,3}=Tabla{i+1,3};
        Pac_high{cont+1,4}=Tabla{i+1,4};
        Pac_high{cont+1,5}=Tabla{i+1,5};
        Pac_high{cont+1,6}=Tabla{i+1,6};
    else
    end
end
%(12.2) Ahora me quedo solo con las comparaciones positivas
Pac_highPos{1,1}='AreasVs';
Pac_highPos{1,2}='pvals';
Pac_highPos{1,3}='T_test';
Pac_highPos{1,4}='Rho_Cont';
Pac_highPos{1,5}='Rho_Pac';
Pac_highPos{1,6}='Lugares_atlas';
cont=0;
for i=1:length(Pac_high)-1
    
    if Pac_high{i+1,4}<0 && Pac_high{i+1,5}<0
    else
        cont=cont+1;
        Pac_highPos{cont+1,1}=Pac_high{i+1,1};
        Pac_highPos{cont+1,2}=Pac_high{i+1,2};
        Pac_highPos{cont+1,3}=Pac_high{i+1,3};
        Pac_highPos{cont+1,4}=Pac_high{i+1,4};
        Pac_highPos{cont+1,5}=Pac_high{i+1,5};
        Pac_highPos{cont+1,6}=Pac_high{i+1,6};
    end
end
%(12.3) Ahora me quedo solo con las negativas
Pac_highNeg{1,1}='AreasVs';
Pac_highNeg{1,2}='pvals';
Pac_highNeg{1,3}='T_test';
Pac_highNeg{1,4}='Rho_Cont';
Pac_highNeg{1,5}='Rho_Pac';
Pac_highNeg{1,6}='Lugares_atlas';
cont=0;
for i=1:length(Pac_high)-1
    
    if Pac_high{i+1,4}<0 && Pac_high{i+1,5}<0
        cont=cont+1;
        Pac_highNeg{cont+1,1}=Pac_high{i+1,1};
        Pac_highNeg{cont+1,2}=Pac_high{i+1,2};
        Pac_highNeg{cont+1,3}=Pac_high{i+1,3};
        Pac_highNeg{cont+1,4}=Pac_high{i+1,4};
        Pac_highNeg{cont+1,5}=Pac_high{i+1,5};
        Pac_highNeg{cont+1,6}=Pac_high{i+1,6};
    else
    end
end

Pacientes.GrupoDos_high=Pac_high;
Pacientes.GrupoDos_highPos=Pac_highPos;
Pacientes.GrupoDos_highNeg=Pac_highNeg;
if desvio_out>0
    Pacientes.outliers=dos_out;
    Pacientes.desvio_Out=num2str(desvio_out);
else
    Pacientes.rawdata=dos;
end
clear Pac_high Pac_highPos Pac_highNeg

%% (13) La matriz para los sujetos poniendo TODO el atlas para los PACIENTES
%empiezo por highPOS
matriz(1:length(rois_lista),1:length(rois_lista))=0;
matriz([Pacientes.GrupoDos_highPos{2:end,6}])=1;
matriz_aux=transpose(matriz);
Pacientes.matGUHighPos=matriz_aux+matriz;
clear matriz matriz_aux
%empiezo con los highNeg
matriz(1:length(rois_lista),1:length(rois_lista))=0;
matriz([Pacientes.GrupoDos_highNeg{2:end,6}])=1;
matriz_aux=transpose(matriz);
Pacientes.matGULessNEG=matriz_aux+matriz;

end
%% by hipereolo 2014