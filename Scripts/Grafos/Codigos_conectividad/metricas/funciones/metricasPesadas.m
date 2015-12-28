function [metricasPesadas] = metricasPesadas(mat)


%load (['Wcor_116_',num2str(contr),'.mat']);
%mat=Wcor.scale3;
% connect_length_mat=mat; %Por método de normalización inversa

%Se saca la diagonal a la matriz
mat=mat.*~eye(size(mat));
%Se utilizarán los valores positivos de la matriz
negativos = mat<0;
mat(negativos) = 0;

%Obtengo la connection-length matrix
% %Método de inversión de valores de 0 a 1, invertidos en 1 a 0
% no_positivos = mat<=0;
% connect_length_mat(no_positivos) = 1;
% connect_length_mat=1-connect_length_mat;
%Método de la inversa de la distancia
connect_length_mat = mat;
nozero = connect_length_mat~=0;
connect_length_mat(nozero) = 1./connect_length_mat(nozero);


    % (a) calcula L (camino promedio - Characteristic path length)
	E=distance_wei(connect_length_mat);    %Distancia(E): Matriz de Caminos más cortos entre un nodo y otro
    dist_promXnodo = mean(E);     %Distancia promedio de cada nodo
    dist_prom_total = mean(dist_promXnodo); %Distancia promedio total de la matriz
    
    L = charpath(E);
    
    % (a bis) Calcula Lambda = L/Lrandom
    %Se genera una matriz aleatoria con N nodos y K bordes
    [density,N,K] = density_und(mat);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Genero una matriz aleatoria pesada(función makerandCIJ_und modificada)
        ind = triu(~eye(N));                %   
        i = find(ind);                      %
        rp = randperm(length(i));           %
        irp = i(rp);                        %
                                            %
        cij = zeros(N);                     %
        cij(irp(1:K)) = 2*rand(K,1)-1;      %
        cij = cij+cij';                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    E_rand = distance_wei(cij);
    L_rand = charpath(E_rand);
    
    %(a.2) Calcula Lambda
    Lambda = L/L_rand;


    % (b) Se calcula Cluster coeficient para cada nodo
	C = clustering_coef_wu(mat)';    %C es un vector

    
    % (b bis) Calcula Cluester coeficiency para la matriz aleatoria
	C_rand = clustering_coef_wu(cij)'; 

    % (b.2) Calcula Gamma = C/Crandom
    C_promedio = mean(C);
    C_rand_promedio = mean(C_rand);
    Cgamma = C_promedio/C_rand_promedio;
    
    
    % (c) Se calcula degree y devuelve el resultado como fila
    degree = degrees_und(mat);
    % (c.2)Calcula el grado promedio
    degree_promedio = mean(degree);

    
    % (d) Se calcula Betweeness Centrality (BC)
	BC=betweenness_wei(connect_length_mat)';


	% (e) Global efficiency: average inverse shortest path lenght
	global_effi=efficiency_wei(mat);
    
    
    % (f) Local efficiency
	local_effi=efficiency_wei(mat,1)';


	% (h) Calculo la Assortatividad= a measure of correlation
	% between nodal degree and mean degree of its nearest
	% neighbors, obtained by averaging the correlation
	% coefficientes of the degrees oe every connected node pair.
	assort=assortativity_wei(mat,0);

    
    % (i) Se calcula Small World (SW)
    SW_sporns = Cgamma/Lambda;
    SW_sin_normalizar = C_promedio/L;
    
    
    
            
            % (fin) Se guardan las metricas
            metricasPesadas.dist_promXnodo = dist_promXnodo;
            metricasPesadas.dist_prom_total = dist_prom_total;
            metricasPesadas.L = L;
            metricasPesadas.L_rand = L_rand;
            metricasPesadas.Lambda = Lambda;
            metricasPesadas.C = C;
            metricasPesadas.C_promedio = C_promedio;
            metricasPesadas.C_rand = C_rand;
            metricasPesadas.C_rand_promedio = C_rand_promedio;
            metricasPesadas.Cgamma = Cgamma;
            metricasPesadas.degree = degree;
            metricasPesadas.degree_promedio = degree_promedio;
            metricasPesadas.BC = BC;
            metricasPesadas.global_effi = global_effi;
            metricasPesadas.local_effi = local_effi;
            metricasPesadas.assort = assort;
            metricasPesadas.SW_sporns = SW_sporns;
            metricasPesadas.SW_sin_normalizar = SW_sin_normalizar;
            

end

