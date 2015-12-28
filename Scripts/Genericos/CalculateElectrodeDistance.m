function electrodeDistances = CalculateElectrodeDistance(electrodes,dosave,fileName)
%Calculates the distance between electrodes and returns a matrix with the values
%INPUT:
%electrodes: struct with x,y,z as column vectors properties indicating the respective coordinates, all of them should have the same size
%dosave: 1 - to save mat in a .mat with name fileName; 0 - does not save -> fileName is irrelevant

%OUTPUT:
%electrodeDistances: matrix of values of distances between electrodes

electrodeNr = size(electrodes.x,1);
electrodeDistances = zeros(electrodeNr,electrodeNr);

for i = 1 : electrodeNr - 1
    
    X1 = electrodes.x(i);
    Y1 = electrodes.y(i);
    Z1 = electrodes.z(i);

    for j = i + 1 : electrodeNr
    
    X2 = electrodes.x(j);
    Y2 = electrodes.y(j);
    Z2 = electrodes.z(j);

    d = sqrt((X1-X2)^2 + (Y1-Y2)^2 + (Z1-Z2)^2);
	electrodeDistances(i,j) = d;
	electrodeDistances(j,i) = d;    
    end
end

if dosave == 1
	completeFileName = [fileName '.mat'];
	str = ['save ' completeFileName ' ' electrodeDistances];
	eval(str)
end