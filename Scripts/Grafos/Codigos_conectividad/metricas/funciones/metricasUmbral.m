function [metricasUmbral] = metricasUmbral(mat)


%load (['Wcor_116_',num2str(contr),'.mat']);
%mat=Wcor.scale3;

%Se saca la diagonal a la matriz
mat=mat.*~eye(size(mat));

%Comienza a recorrer todos los umbrales (1000)
cont=0;

for umbral= 0:0.001:1
	cont=cont+1;
	%Binariza la matrix de acuerdo al umbral
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
    
    
    
            
            % (fin) Se guardan las metricas
            metricasUmbral.dist_promXnodo = dist_promXnodo;
            metricasUmbral.dist_prom_total = dist_prom_total;
            metricasUmbral.L = L;
            metricasUmbral.L_rand = L_rand;
            metricasUmbral.Lambda = Lambda;
            metricasUmbral.C = C;
            metricasUmbral.C_promedio = C_promedio;
            metricasUmbral.C_rand = C_rand;
            metricasUmbral.C_rand_promedio = C_rand_promedio;
            metricasUmbral.Cgamma = Cgamma;
            metricasUmbral.degree = degree;
            metricasUmbral.degree_promedio = degree_promedio;
            metricasUmbral.BC = BC;
            metricasUmbral.global_effi = global_effi;
            metricasUmbral.local_effi = local_effi;
            metricasUmbral.assort = assort;
            metricasUmbral.SW_sporns = SW_sporns;
            metricasUmbral.SW_sin_normalizar = SW_sin_normalizar;
            
            

end

