function electrodeNr = GetElectrodeNrForElectrodeList(electrodeList,preprocessed_electrodelocalisation,case_sensitivity)
%Obtains from file of electrodes the numbering of an electrode list by name
%INPUT:
%electrodeList: cellArray containing electrode Names
%preprocessed_electrodelocalisation: Electrode Localisation and Numbering 
%case_sensitivity: 0 for case SENSITIVE and 1 for case INSENSITIVE
%OUTPUT cell array of electrodeList and electrodesNrs

electrodes = importdata(preprocessed_electrodelocalisation);

electrodeNr = cell(size(electrodeList,1),2);
electrodesNumbering = electrodes.textdata(:,2);

if case_sensitivity == 1
    %convert case to upper to make script case INSENSITIVE
    electrodesNumbering = upper(electrodesNumbering);
    electrodeList = upper(electrodeList);
end


for i = 1 : size(electrodeList,1)
    index = find(strcmp(electrodesNumbering, electrodeList(i,1)));
    
    if isempty(index)
        index = 'N/A';
    end
    
    electrodeNr{i,1} = index;
    electrodeNr{i,2} = electrodeList(i,1);
end

