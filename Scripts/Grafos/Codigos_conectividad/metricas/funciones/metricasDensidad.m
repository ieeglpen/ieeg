function [metricasDensidad] = metricasDensidad(mat)

%load (['Wcor_116_',num2str(contr),'.mat']);
%mat=Wcor.scale3;

%Busca la cantidad de valores no negativos de la matriz y los coloca en un array
positivos=0;
for i=1:size(mat,1)
    for j=1:size(mat,1)
        if(mat(i,j)>=0)
            positivos=positivos+1;
            array(positivos)=mat(i,j);
        end
    end
end

%Se saca la diagonal a la matriz
mat=mat.*~eye(size(mat));
%Elimina la cantidad de zeros tomada en cuenta en la diagonal
positivos=positivos-length(diag(mat));

%Ordena el array y obtiene la cantidad de celdas correspondientes a una
%milésima, que será la cantidad de celdas que se saltará por umbral
array=sort(array);
pos_array=0;


for cont = 1:1001
    if(pos_array<positivos)
    pos_array=round((positivos-pos_array)/(1001-cont))+pos_array;
    else pos_array=positivos; 
    end
    
    if pos_array == 0
        pos_array = 1;
    end
    %Obtiene el valor correspondiente a la nueva celda umbral
    umbral = array(pos_array);%*cont-pos_array+1);
    
	%Binariza la matrix de acuerdo a la densidad
	logical=double(mat>umbral);
    

    
    % (a) calcula L (camino promedio - Characteristic path length)
	E=distance_bin(logical);    %Distancia(E): Matriz de Caminos más cortos entre un nodo y otro
    dist_promXnodo(:,cont) = mean(E)';     %Distancia promedio de cada nodo
    dist_prom_total(cont) = mean(dist_promXnodo(:,cont)); %Distancia promedio total de la matriz
    
    L(cont) = charpath(E);
    
    % (a bis) Calcula Lambda = L/Lrandom
    %Se genera una matriz aleatoria con N nodos y K bordes
    [density(cont),N,K] = density_und(logical);
    
    bucle=0;
    while (bucle<100)
        cij = makerandCIJ_und(N,K);
        bucle=bucle+1;
        if(cij ~= nan)
            break
        end
    end
    E_rand = distance_bin(cij);
    L_rand(cont) = charpath(E_rand);
    
        
	% (b) Se calcula Cluster coeficient para cada nodo
	C(:,cont) = clustering_coef_bu(logical)';    %C es un vector

    
    % (b bis) Calcula Gamma = C/Crandom
	C_rand(:,cont) = clustering_coef_bu(cij)'; 
    
    
    % (c) Se calcula degree y devuelve el resultado como fila
    degree(:,cont) = degrees_und(logical)';

    
    % (d) Se calcula Betweeness Centrality (BC)
	BC(:,cont)=betweenness_bin(logical)';


	% (e) Global efficiency: average inverse shortest path lenght
	global_effi(cont)=efficiency_bin(logical);
    
    
    % (f) Local efficiency
	local_effi(:,cont)=efficiency_bin(logical,1)';


	% (h) Calculo la Assortatividad= a measure of correlation
	% between nodal degree and mean degree of its nearest
	% neighbors, obtained by averaging the correlation
	% coefficientes of the degrees oe every connected node pair.
	assort(cont)=assortativity_bin(logical,0);

    
end

    %(a.2) Calcula Lambda
    Lambda = L./L_rand;

    % (b.2) Calcula Gamma = C/Crandom
    C_promedio = mean(C);
    C_rand_promedio = mean(C_rand);
    Cgamma = C_promedio./C_rand_promedio;
    
    % (c.2)Calcula el grado promedio
    degree_promedio = mean(degree);

    % (i) Se calcula Small World (SW)
    SW_sporns = Cgamma./Lambda;
    SW_sin_normalizar = C_promedio./L;
    
    
    
            
            % Se guardan las metricas
            metricasDensidad.dist_promXnodo = dist_promXnodo;
            metricasDensidad.dist_prom_total = dist_prom_total;
            metricasDensidad.L = L;
            metricasDensidad.L_rand = L_rand;
            metricasDensidad.Lambda = Lambda;
            metricasDensidad.C = C;
            metricasDensidad.C_promedio = C_promedio;
            metricasDensidad.C_rand = C_rand;
            metricasDensidad.C_rand_promedio = C_rand_promedio;
            metricasDensidad.Cgamma = Cgamma;
            metricasDensidad.degree = degree;
            metricasDensidad.degree_promedio = degree_promedio;
            metricasDensidad.BC = BC;
            metricasDensidad.global_effi = global_effi;
            metricasDensidad.local_effi = local_effi;
            metricasDensidad.assort = assort;
            metricasDensidad.SW_sporns = SW_sporns;
            metricasDensidad.SW_sin_normalizar = SW_sin_normalizar;
            

end

