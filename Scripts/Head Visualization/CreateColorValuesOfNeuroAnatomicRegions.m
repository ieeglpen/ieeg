function colors = CreateColorValuesOfNeuroAnatomicRegions(neuroanatomicRegions)

colorVector = unique(neuroanatomicRegions);

colors = zeros(size(neuroanatomicRegions,1),1);

for i = 1 : size(neuroanatomicRegions,1)
    colors(i) = find(ismember(colorVector,neuroanatomicRegions(i)));
end
