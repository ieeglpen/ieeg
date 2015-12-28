function [Resultado_FINAL]=stat_metricas_areas(grupo_uno, grupo_dos,areas,estadistico,desvio_out)
%%

%% (0) Defino el estadistico que se va a usar
if nargin==3
    estadistico=1; %default hago prueba T
else
end

%% (1) Busco los outliers en cada area
%(1.1)me fijo si tiene todos los argumentos que necesito
if nargin==4
    desvio_out=0; %default
else
end    
% (1.2)calculo el desvio para cada medida
if desvio_out>0
    %(a) Saco del primer grupo
    for i=1:length(grupo_uno(1,:))
        grupo_uno_out(:,i)=find_outlier(grupo_uno(:,i),desvio_out);
    end
    clear i
    %(b) Saco del segundo grupo
    for i=1:length(grupo_dos(1,:))
        grupo_dos_out(:,i)=find_outlier(grupo_dos(:,i),desvio_out);
    end
    clear i
    
else
    grupo_uno_out=grupo_uno;
    grupo_dos_out=grupo_dos;
end
clear grupo_uno grupo_dos

%% (2) Hago la prueba estadistica que corresponda de acuerdo a lo que haya elegido el usuario
if estadistico==1
        [Resultado.H,Resultado.P,Resultado.CI,Resultado.STATS] = ttest2(grupo_uno_out,grupo_dos_out);
elseif estadistico==2
    for i=1:length(grupo_uno_out(1,:))
        [P, H, STAT]=ranksum(grupo_uno_out(:,i),grupo_dos_out(:,i));
        Resultado.H(1,i)=H;
        Resultado.P(1,i)=P;
        Resultado.STATS.zval(1,i)=STAT.zval;
        Resultado.STATS.ranksum(1,i)=STAT.ranksum;
        clear P H STAT
    end
    clear i
elseif estadistico==3
        for p=1:length(grupo_uno_out(1,:))

        %saco cada uno de los puntos de steps y los pongo en una columna por
        %separado
        aux_per_uno=grupo_uno_out(:,p);
        aux_per_dos=grupo_dos_out(:,p);
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
        %hago la permutacion
        uno_permutacion(1,:,:)=aux_per_uno';        
        dos_permutacion(1,:,:)=aux_per_dos';
        clear aux_per_uno aux_per_dos
        
        Permut{1}=uno_permutacion;
        Permut{2}=dos_permutacion;
        clear uno_permutacion dos_permutacion
        [T, DF, P] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);
        Resultado.STATS.tstat(1,p)=T;
        Resultado.P(1,p)=P;
               
        clear Permut T DF P
        %cierro permutaciones
        end
end

%% (3) Hago la correccion por multiples comparaciones.
%(3.1) Primero me quedo con todos los valores p sacando los NaNs y guardo
%su lugar original
pvals_mult=Resultado.P;
pvals_lugar_multi=1:length(pvals_mult);
nan_pvals=find(isnan(pvals_mult)==1);
pvals_mult(nan_pvals)=[];
pvals_lugar_multi(nan_pvals)=[];
clear nan_pvals

%(6.2) ejecuto la correccion de multiples comparaciones
%lo hago para comparaciones dependientes, un q=0.05 y sin que me haga un
%reporte de resultados
[h crit_p adj_p]=fdr_bh(pvals_mult,.05,'pdep','no');
Resultado.PFDR=adj_p;
clear h crit_p adj_p  pvals_mult pvals_lugar_multi

%% (4) Arranco la tabla
%inicializo tabla
Tabla{1,1}='Areas';
Tabla{1,2}=['pvals'];
if estadistico==1
    Tabla{1,3}='T_test';
elseif estadistico==2
    Tabla{1,3}='Ranksum';
elseif estadistico==3
    Tabla{1,3}='Perm';
end
Tabla{1,4}='P_FDR_corr';
Tabla{1,5}='UNO_mean';
Tabla{1,6}='UNO_SD';
Tabla{1,7}='DOS_mean';
Tabla{1,8}='DOS_SD';

%% (5) Comienzo a rellenar la tabla
%me fijo cuales son las areas cuya comparacion dio un resultado
%significativo menor a 0.05
aux_pvals=find(Resultado.P<=0.05);

%recorro la variable auxiliar que tiene los valores significativos y voy
%completando la tabla
for i=1:length(aux_pvals)
    %label de areas
    Tabla{i+1,1}=areas{aux_pvals(i)};
    %coloco los pvals
    Tabla{i+1,2}=Resultado.P(aux_pvals(i));
    %coloco los valores T
        if estadistico==2
            Tabla{i+1,3}=Resultado.STATS.zval(1,aux_pvals(i));
        else
            Tabla{i+1,3}=Resultado.STATS.tstat(1,aux_pvals(i));
        end
    %coloco los pvals del FDR
    Tabla{i+1,4}=Resultado.PFDR(1,aux_pvals(i));
    
    %mean y desvio del grupo uno
    aux_mean=nanmean(grupo_uno_out(:,aux_pvals(i)));
    aux_sd=nanstd(grupo_uno_out(:,aux_pvals(i)));
    Tabla{i+1,5}=aux_mean;
    Tabla{i+1,6}=aux_sd;
    clear aux_mean aux_sd
    
    %mean y desvio del grupo dos
    aux_mean=nanmean(grupo_dos_out(:,aux_pvals(i)));
    aux_sd=nanstd(grupo_dos_out(:,aux_pvals(i)));
    Tabla{i+1,7}=aux_mean;
    Tabla{i+1,8}=aux_sd;
    clear aux_mean aux_sd
   
    %cierro el recorrido para completar la tabla
end
clear i aux_pvals

%% (6) Ahora creo una tabla donde estan todas las areas que son mayores en el grupo UNO
%(6.1) Primero saco todas las que son mayores en los controles
Uno_high{1,1}='Areas';
Uno_high{1,2}='pvals';
if estadistico==1
    Uno_high{1,3}='T_test';
elseif estadistico==2
    Uno_high{1,3}='R_test';
elseif estadistico==3
    Uno_high{1,3}='Perm_test';
end
Uno_high{1,4}='P_FDR_corr';


cont=0;
for i=1:length(Tabla(:,1))-1
    if Tabla{i+1,5} > Tabla{i+1,7}
        cont=cont+1;
        Uno_high{cont+1,1}=Tabla{i+1,1};
        Uno_high{cont+1,2}=Tabla{i+1,2};
        Uno_high{cont+1,3}=Tabla{i+1,3};
        Uno_high{cont+1,4}=Tabla{i+1,4};
        else
    end
end
clear cont i

%% (7) Ahora creo una tabla donde estan todas las areas que son mayores en el grupo DOS
%(7.1) Primero saco todas las que son mayores en los controles
Dos_high{1,1}='Areas';
Dos_high{1,2}='pvals';
if estadistico==1
    Dos_high{1,3}='T_test';
elseif estadistico==2
    Dos_high{1,3}='R_test';
elseif estadistico==3
    Dos_high{1,3}='Perm_test';
end
Dos_high{1,4}='P_FDR_corr';


cont=0;
for i=1:length(Tabla(:,1))-1
    if Tabla{i+1,5} < Tabla{i+1,7}
        cont=cont+1;
        Dos_high{cont+1,1}=Tabla{i+1,1};
        Dos_high{cont+1,2}=Tabla{i+1,2};
        Dos_high{cont+1,3}=Tabla{i+1,3};
        Dos_high{cont+1,4}=Tabla{i+1,4};
        else
    end
end
clear i cont

%% (8) Creo una Tabla para los controles que tenga todas aquellas areas en las cuales 
%sean mayores que en los pacientes pero corregidos por el FDR
Uno_high_FDR{1,1}='Areas';
Uno_high_FDR{1,2}='pvalsFDR';
if estadistico==1
    Uno_high_FDR{1,3}='T_test';
elseif estadistico==2
    Uno_high_FDR{1,3}='R_test';
elseif estadistico==3
    Uno_high_FDRh{1,3}='Perm_test';
end

%(8.1) relleno esta tabla para los controles

aux_pvals_fdr_uno=find([Uno_high{2:end,4}]<=0.05);

if sum(aux_pvals_fdr_uno)>0;
    for i=1:length(aux_pvals_fdr_uno)
        Uno_high_FDR{i+1,1}=Uno_high{aux_pvals_fdr_uno(i)+1,1};
        %coloco los pvals
        Uno_high_FDR{i+1,2}=Uno_high{aux_pvals_fdr_uno(i)+1,4};
        %coloco los valores T
        Uno_high_FDR{i+1,3}=Uno_high{aux_pvals_fdr_uno(i)+1,3};
    end
    clear i
else
end
clear aux_pvals_fdr_uno

%% (8) Creo una Tabla para los PACIENTES o el grupo dos mejor dicho que tenga todas aquellas areas en las cuales 
%sean mayores que en los pacientes pero corregidos por el FDR
Dos_high_FDR{1,1}='Areas';
Dos_high_FDR{1,2}='pvalsFDR';
if estadistico==1
    Dos_high_FDR{1,3}='T_test';
elseif estadistico==2
    Dos_high_FDR{1,3}='R_test';
elseif estadistico==3
    Dos_high_FDRh{1,3}='Perm_test';
end

%(8.1) relleno esta tabla para los controles

aux_pvals_fdr_dos=find([Dos_high{2:end,4}]<=0.05);

if sum(aux_pvals_fdr_dos)>0;
    for i=1:length(aux_pvals_fdr_dos)
        Dos_high_FDR{i+1,1}=Dos_high{aux_pvals_fdr_dos(i)+1,1};
        %coloco los pvals
        Dos_high_FDR{i+1,2}=Dos_high{aux_pvals_fdr_dos(i)+1,4};
        %coloco los valores T
        Dos_high_FDR{i+1,3}=Dos_high{aux_pvals_fdr_dos(i)+1,3};
    end
    clear i
else
end
clear aux_pvals_fdr_dos

%% (9) Creo un vector para el brain net viwer que tenga todos los valores t para cada
%area que sean menores o iguales a 0.05 valores T. Primero lo hago para
%aquellos resultados que son mayores en los CONTROLES

%(9.1)---------- PVALS SIN CORREGIR ------------------
valores_t_uno(1:length(areas(1,:)),1)=0;
aux_pvals_net=find(Resultado.P<=0.05);

if estadistico==2
    valores_t_uno(aux_pvals_net,1)=Resultado.STATS.zval(1,aux_pvals_net);
else
    valores_t_uno(aux_pvals_net,1)=Resultado.STATS.tstat(1,aux_pvals_net);
end

%con esta linea de codigo me fijo si hay valores t negativos, que indiquen
%que la diferencia es a favor del segundo grupo y los elimino
valores_t_uno(find(valores_t_uno<0))=0;
clear aux_pvals_net

%(9.2)----------- PVALS CORREGIDOS POR FDR----------
valores_t_uno_fdr(1:length(areas(1,:)),1)=0;
aux_pvals_net=find(Resultado.PFDR<=0.05);

if estadistico==2
    valores_t_uno_fdr(aux_pvals_net,1)=Resultado.STATS.zval(1,aux_pvals_net);
else
    valores_t_uno_fdr(aux_pvals_net,1)=Resultado.STATS.tstat(1,aux_pvals_net);
end

%con esta linea de codigo me fijo si hay valores t negativos, que indiquen
%que la diferencia es a favor del segundo grupo y los elimino
valores_t_uno_fdr(find(valores_t_uno_fdr<0))=0;
clear aux_pvals_net


%% (10) Creo un vector para el brain net viwer que tenga todos los valores t para cada
%area que sean menores o iguales a 0.05 valores T. Primero lo hago para
%aquellos resultados que son mayores en los PACIENTE O GRUPO DOS MEJOR
%DICHO

%(10.1)---------- PVALS SIN CORREGIR ------------------
valores_t_dos(1:length(areas(1,:)),1)=0;
aux_pvals_net=find(Resultado.P<=0.05);

if estadistico==2
    valores_t_dos(aux_pvals_net,1)=Resultado.STATS.zval(1,aux_pvals_net);
else
    valores_t_dos(aux_pvals_net,1)=Resultado.STATS.tstat(1,aux_pvals_net);
end

%con esta linea de codigo me fijo si hay valores t negativos, que indiquen
%que la diferencia es a favor del segundo grupo y los elimino
valores_t_dos(find(valores_t_dos>0))=0;
clear aux_pvals_net

%(9.2)----------- PVALS CORREGIDOS POR FDR----------
valores_t_dos_fdr(1:length(areas(1,:)),1)=0;
aux_pvals_net=find(Resultado.PFDR<=0.05);

if estadistico==2
    valores_t_dos_fdr(aux_pvals_net,1)=Resultado.STATS.zval(1,aux_pvals_net);
else
    valores_t_dos_fdr(aux_pvals_net,1)=Resultado.STATS.tstat(1,aux_pvals_net);
end

%con esta linea de codigo me fijo si hay valores t negativos, que indiquen
%que la diferencia es a favor del segundo grupo y los elimino
valores_t_dos_fdr(find(valores_t_dos_fdr>0))=0;
clear aux_pvals_net

%% (11) Creo un vector para el brain net viwer que tenga todos los valores t sin importar el grupo ni la direccion
%(10.1)---------- PVALS SIN CORREGIR ------------------
valores_t(1:length(areas(1,:)),1)=0;
aux_pvals_net=find(Resultado.P<=0.05);

if estadistico==2
    valores_t(aux_pvals_net,1)=Resultado.STATS.zval(1,aux_pvals_net);
else
    valores_t(aux_pvals_net,1)=Resultado.STATS.tstat(1,aux_pvals_net);
end
clear aux_pvals_net

%(9.2)----------- PVALS CORREGIDOS POR FDR----------
valores_t_fdr(1:length(areas(1,:)),1)=0;
aux_pvals_net=find(Resultado.PFDR<=0.05);

if estadistico==2
    valores_t_fdr(aux_pvals_net,1)=Resultado.STATS.zval(1,aux_pvals_net);
else
    valores_t_fdr(aux_pvals_net,1)=Resultado.STATS.tstat(1,aux_pvals_net);
end

clear aux_pvals_net



%% (12) Meto todo en una variable que va a ser el output
Resultado_FINAL.Tablas.Tabla_General=Tabla;
Resultado_FINAL.Tablas.Tabla_PosGrupoUno=Uno_high;
Resultado_FINAL.Tablas.Tabla_PosGrupoUnoFDR=Uno_high_FDR;
Resultado_FINAL.Tablas.Tabla_PosGrupoDos=Dos_high;
Resultado_FINAL.Tablas.Tabla_PosGrupoDosFDR=Dos_high_FDR;
clear Tabla Uno_high Uno_high_FDR Dos_high Dos_high_FDR

Resultado_FINAL.Estadistica=Resultado;
Resultado_FINAL.Estadistica.desvio=desvio_out;
clear Resultado desvio_out

Resultado_FINAL.RawData.GrupoUno=grupo_uno_out;
Resultado_FINAL.RawData.GrupoDos=grupo_dos_out;
clear grupo_uno_out grupo_dos_out

Resultado_FINAL.BrainNetData.GrupoUno=valores_t_uno;
Resultado_FINAL.BrainNetData.GrupoUnoFDR=valores_t_uno_fdr;
Resultado_FINAL.BrainNetData.GrupoDos=valores_t_dos;
Resultado_FINAL.BrainNetData.GrupoDosFDR=valores_t_dos_fdr;
Resultado_FINAL.BrainNetData.All=valores_t;
Resultado_FINAL.BrainNetData.All_FDR=valores_t_fdr;
clear valores_t_uno valores_t_uno_fdr valores_t_dos valores_t_dos_fdr


end
%% by hipereolo, noviembre 2014

