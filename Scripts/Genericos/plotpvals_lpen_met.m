function [] = plotpvals_lpen_met(elec,thre,pvals,times,color,order,smooth,line)
%PLOTPVALS Quick and dirty function to plot p values in a ERP like format
%created by Yamil Vidal Dos Santos. 20/04/2011
% Usage:
% plotpvals(elec,thre,pvals,times,color)
%elec=elegis el canal del cual queres ver los pvals, en el caso de ser un
%roi es 1
%
%thre= es tu nivel de significancia, tendrias que usar 0.05 por default. 
%
%pvals=aca tenes que poner el vector con todos tus valores p que surgieron
%del analisis estadistico que hayas hecho (en teoria permutaciones que es el unico que te da
%resultados punto por punto).
%
%times=tu variable tiempo
%
%color=el color que queres que tenga la linea de tus pvals
%
%order=permite ordenar como plotea los valores debajo del 0.05
%
%smooth=especifica cuantos pvalues continuos quier considerar para el
%grafico, si esta en cero (default) considera todos, si esta en 1 solo
%cuando hay mas de uno continuo, lo mismo con 2 y asi sucesivamente
%
%line=especifica el line style

%% (-0) Le Saco 0.001 al valor de corte por si llega a ocurrir que hay una diferencia que es clavada 0.05. Sino se produce un desfazaje
%entre los puntos finales y del comienzo
thre=thre-0.001;

%% (0) Seteo donde pone las lineas
if order==1
    corte=thre+0.005;
elseif order==2
    corte=thre+0.006;
elseif order==3
    corte=thre+0.007;
end

%% (1) Arranco con la funcion, pongo los valores pvals en una nueva variable y los ploteo
a=pvals(elec,:,:);
%a(a>thre) = corte;
b=a';

%% (1.bis) Meto un if que chequea si hay alguno pvalor, sino llena todo de valores no significativos
existe_pvals=find(b<=thre);
%meto unos en los lugares en los que había Nans porque esto no lee como son
%los nans
b(isnan(b))=1;

if sum(existe_pvals)>0
        %% (2) Dejo solo los pvalores que se mantienen durante mas tiempo que 30 milisengundos
        %(2.1 )calculo los comienzos de la significancia
        if b(1)<=thre
            comienzos(1)=1;
            cont=1;
            for l=2:length(b)-1
                if b(l)>thre && b(l+1)<thre 
                    cont=cont+1;
                    comienzos(cont)=l+1;
                else
                end
            end
            clear cont l
        else
            cont=0;
            for l=1:length(b)-1
                if b(l)>thre && b(l+1)<thre 
                    cont=cont+1;
                    comienzos(cont)=l+1;
                else
                end
            end
            clear l cont
        end

        %(2.2)calculo los finales de la significancia
        finales=0;
        cont=0;
        for l=1:length(b)-1

            if b(l)<thre && b(l+1)>thre
                cont=cont+1;
                finales(cont)=l;
            else
                %finales=[];
            end
        end
        clear l cont
        %me fijo si hay algun pvals al final
        if b(end)<thre 
            finales(1,length(finales(1,:))+1)=length(b);
            %me fijo si hay ceros generados por no existir ningun final
            %antes
            finales(find(finales==0))=[];
        else
        end
        
        %if para resolver el caso de que haya comienzo pero no haya final
        %de pvalus
        if comienzos(end)> finales(end) 
            finales=length(b);
        else
        end
        
        
        %(2.3) hago la diferencia entre los finales y los comienzos para ver cuanto duran
        %lo hago segun cuanto se busca smoothear los valores p, es decir cuantos
        %valores p continuos se quieren ver
        if nargin>6
            smooth;
        else
            smooth=0;
        end

        dif=finales-comienzos;

        if smooth==0
            lugares_pvals=find(dif>=0);%aca me guardo todos aquellos lugares en los cuales pasan mas de 30 segundos
        else
            lugares_pvals=find(dif>smooth);%aca me guardo todos aquellos lugares en los cuales pasan mas de 30 segundos
        end

        %(2.4) uso los lugares que calcules en "lugares_pvals" para sacar los
        %valores significativos y llenar el resto con los valores de mentira
        aux(1:length(b))=corte;

        for i=1:length(lugares_pvals)
            aux(comienzos(lugares_pvals(i)):finales((lugares_pvals(i))))=pvals(comienzos(lugares_pvals(i)):finales((lugares_pvals(i))));

        end
        clear b
        b=aux';
       
else
    aux_b(1:length(b))=corte;
    clear b
    b=aux_b;
    clear aux_b
    %cierro if
end


%% (3) Seteo las lineas para el ploteo y lo hago
if nargin>7
    line;
else
    line='-';
end

plot(times,b,'Color',color,'LineWidth',2,'LineStyle',line)

%% (4) add horizontal line to show significance
hold on
plot([times(1),times(end)],[thre,thre],'HandleVisibility','off','Color',[0.603 0.603 0.603],'LineWidth',2,'LineStyle','-')

%% (5) Seteo el minimo y maximo del eje y del grafico
min=0;
max=thre+0.01;
ylim([min max])

set(gca,'YDir','reverse');


set(gca,'Ytick',[])
set(gca,'YTick',[0 thre ])
%set(gca,'XTick',[round(times(1)):100:roundn(times(end),2)])

end