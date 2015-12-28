function [metricasDensidad] = metricasDensidad(Wcor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function takes the lowest frequencies from the wavelet correlation
%matrix (wavelet filter must be applied first) and automatically generates
%1000 thresholds based on linear degree and density. Values goes from 0 to 
%1 and for every iteration it computes the following metrics:
%
%   dist_promXnodo - Average distance per node;
%   dist_prom_total - Average distance per node as global metric;
%   L - Characteristic Path lenght;
%   L_rand - Characteristic Path lenght based on random matrices with the 
%       same density distribution;
%   Lambda - Characteristic path lenght based on Sporns normalization.
%   C - Clustering Coefficient per node;
%   C_promedio - Average Clustering Coefficient;
%   C_rand - Clustering Coefficient per node based on random matrices with
%       the same density distribution;
%   C_rand_promedio - Average Clustering Coefficient based on random 
%       matrices with the same density distribution;
%   Cgamma - Average Clustering Coefficient based on Sporns normalization.
%   degree - Degree for each node;
%   degree_promedio - Average degree for all nodes;
%   BC - Betweenness Centrality;
%   global_effi - Global Efficiency;
%   local_effi - Local Efficiency;
%   assort - Assortativity;
%   SW_sporns - Small World based on Sporns;
%   SW_sin_normalizar - Small World with no normalization;
%   CC - Closeness Centrality per node;
%   Q - Modularity of the network;
%   P - Participation Coefficient;
%   Z - Within-module degree Z-score;
%   Cm - Comunity coefficient for each node.
%
%INPUT:
%   Wcor - Matrix filtered by wavelet transform (lowest frequencies).
%
%OUTPUT:
%   metricasDensidad - Struct array with the previously described metrics.
%
%
%
%   NOTE: This function needs the Brain Connectivity Toolbox to work.
%
%by H.Desmaras & L.Sedeño - 2014/15
%Rights reserved. Use only with permission.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mat=Wcor;

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

%Inicialización de valores
Cm(1:length(mat),1:1001)=nan;
P(1:length(mat),1:1001)=nan;
Q(1:1001)=nan;
Z(1:length(mat),1:1001)=nan;


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
    

    
    % (A) calcula L (camino promedio - Characteristic path length)
    %y Global Efficiency
	D=distance_bin(logical);    %Distancia(D): Matriz de Caminos más cortos entre un nodo y otro
    dist_promXnodo(:,cont) = mean(D)';     %Distancia promedio de cada nodo
    dist_prom_total(cont) = mean(dist_promXnodo(:,cont)); %Distancia promedio total de la matriz
    
    [L(cont) global_effi(cont)]= charpath(D);
    
    
	% (B) Se calcula Cluster coeficient para cada nodo
	C(:,cont) = clustering_coef_bu(logical)';    %C es un vector
    
    
    % (AyB BIS) Normalización por matrices random
    %Se generan h matrices aleatorias con N nodos y K bordes (Densidad P(k))
    [density(cont),N,K] = density_und(logical);
    
    for rand=1:20   %Crea unas h=20 Matrices random para normalizar 
        bucle=0;
        while (bucle<1000)   %Genera una nueva matriz en caso de NaN
            cij = makerandCIJ_und(N,K);
            bucle=bucle+1;
            if(cij ~= nan)
                break
            end
        end
        %Obtiene L_rand y C_rand para cada h matriz
        D_rand = distance_bin(cij);
        Lh_rand(rand) = charpath(D_rand);
        Ch_rand(:,rand) = clustering_coef_bu(cij)'; 
    end
    
    %Obtiene la media de las h matrices random
    L_rand(cont)=mean(Lh_rand);
    C_rand(:,cont)=mean(Ch_rand,2);     %C es un vector
    
    
    % (C) Se calcula degree y devuelve el resultado como fila
    degree(:,cont) = degrees_und(logical)';

    
    % (D) Se calcula Betweeness Centrality (BC)
	BC(:,cont)=betweenness_bin(logical)';
    
    
    % (E) Local efficiency
	local_effi(:,cont)=efficiency_bin(logical,1)';


	% (F) Calculo la Assortatividad= a measure of correlation
	% between nodal degree and mean degree of its nearest
	% neighbors, obtained by averaging the correlation
	% coefficientes of the degrees oe every connected node pair.
	assort(cont)=assortativity_bin(logical,0);
    
    
    try
    % (G) Modularidad - Participation coefficient - Degree Z-score
    [Q(cont) P(:,cont) Z(:,cont) Cm(:,cont)] = ModZP(logical,10);
    end

    % (H) Calcula Closeness Centrality
    ClosenessNod_rest = ClosenessCentrality( D );
    CC(:,cont)=ClosenessNod_rest';
    
end

    %(A.2) Calcula Lambda
    Lambda = L./L_rand;

    % (B.2) Calcula Gamma = C/Crandom
    C_promedio = mean(C);
    C_rand_promedio = mean(C_rand);
    Cgamma = C_promedio./C_rand_promedio;
    
    % (C.2)Calcula el grado promedio
    degree_promedio = mean(degree);

    % (I) Se calcula Small World (SW)
    SW_sporns = Cgamma./Lambda;
    SW_sin_normalizar = C_promedio./L;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se guardan las medidas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
metricasDensidad.dist_promXnodo = dist_promXnodo;                         %
metricasDensidad.dist_prom_total = dist_prom_total;                       %
metricasDensidad.L = L;                                                   %
metricasDensidad.L_rand = L_rand;                                         %
metricasDensidad.Lambda = Lambda;                                         %
metricasDensidad.C = C;                                                   %
metricasDensidad.C_promedio = C_promedio;                                 %
metricasDensidad.C_rand = C_rand;                                         %
metricasDensidad.C_rand_promedio = C_rand_promedio;                       %
metricasDensidad.Cgamma = Cgamma;                                         %
metricasDensidad.degree = degree;                                         %
metricasDensidad.degree_promedio = degree_promedio;                       %
metricasDensidad.BC = BC;                                                 %
metricasDensidad.global_effi = global_effi;                               %
metricasDensidad.local_effi = local_effi;                                 %
metricasDensidad.assort = assort;                                         %
metricasDensidad.SW_sporns = SW_sporns;                                   %
metricasDensidad.SW_sin_normalizar = SW_sin_normalizar;                   %
metricasDensidad.CC = CC;                                                 %
metricasDensidad.Q = Q;                                                   %
metricasDensidad.P = P;                                                   %
metricasDensidad.Z = Z;                                                   %
metricasDensidad.Cm = Cm;                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            

end

