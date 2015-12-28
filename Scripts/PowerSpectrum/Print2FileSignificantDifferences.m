function Print2FileSignificantDifferences(signifStruct,conditions,timesout,windowMs,significantWindow,charCond1,charCond2,charBoth,labels,fileName)
%INPUTS
%signifStruct, una estructura que contiene por canal la lista de
%condiciones
%conditions, lista de conditions
%fileName, nombre (prefijo) del archivo que se va a guardar
%labels de cada canal

%estos valores indican el comienzo de cada ventana
%no incluye el primer valor 
interPointDuration = timesout(end)-timesout(end-1); % la duracion en ms entre par de puntos
pointsPerWindow = round(windowMs/interPointDuration); %la cantidad de puntos en una ventana
intervals = round(size(timesout,2)/pointsPerWindow)
totalPoints = size(timesout,2);

significantPoints = round(significantWindow/interPointDuration); %cantidad de puntos significativos
windowIndexes = [pointsPerWindow:pointsPerWindow:totalPoints];

if size(windowIndexes,2) == intervals
    windowIndexes(end) = totalPoints;
else
    windowIndexes = [windowIndexes totalPoints];
end
windowIndexesMov = [1 windowIndexes(1:end-1)];

%creo el header de los valores temporales 
headerCellArray = cell(1,intervals+1);
headerCellArray{1} = 'Canal';

for m = 1 : intervals
    header = [num2str(round(timesout(windowIndexesMov(m)))) '-' num2str(round(timesout(windowIndexes(m))))];
    headerCellArray{m+1} = header;
end

N = significantPoints; %cantidad de valores consecutivos

chanNr = size(signifStruct,2);
conditionNr = size(conditions,2);
windowNr = size(windowIndexes,2);

for j = 1 : conditionNr
    actualCondition = conditions{j}
    %
    fileName2print = [fileName '_' actualCondition '.csv'];
    fileID = fopen(fileName2print,'w'); %todo generar el nombre del archivo correcto
    
    [strHeader,errMsg] = vec2str(headerCellArray,[],[],0);    
    fprintf(fileID,'%s\n',strHeader);
        
    for i = 1 : chanNr        
        %actualCondStruct
        actualStruct = signifStruct(i);
        str2eval = ['actualCondStruct = actualStruct.' actualCondition ';'];
        eval(str2eval)
        
        indexes = actualCondStruct.indexes;
        t = actualCondStruct.t;
                
        res2print = cell(1,windowNr+1);        
        res2print{1} = labels{i};
                       
        for k = 1 : windowNr
            
            windowChar = [];
            
            if k == 1
                indexes4Window = indexes(indexes < round(windowIndexes(k+1)/2)); %incluye la mitad del siguiente
            elseif k == windowNr
                indexes4Window = indexes(indexes < round(windowIndexes(k)) & indexes > windowIndexes(k-1));            
            else                
                indexes4Window = indexes(indexes < round(windowIndexes(k+1)/2) & indexes > windowIndexes(k-1));
            end
            
            signVals = sign(t(indexes4Window));
            
            %condition1
            cond1Signif = indexes4Window(signVals > 0); 
            if ~isempty(cond1Signif)
                cond1res = DoesVectorContainNConsecutiveNrs(cond1Signif,N);                
                if cond1res == 1
                    windowChar = charCond1;
                end
            end

            %condition2
            cond2Signif = indexes4Window(signVals < 0);   
            if ~isempty(cond2Signif)
                cond2res = DoesVectorContainNConsecutiveNrs(cond2Signif,N); 
                if cond2res == 1
                    if ~isempty(windowChar)
                        windowChar = charBoth;
                    else
                        windowChar = charCond2;
                    end
                end
            end    
            
            if isempty(windowChar)
                windowChar = ' ';
            end
            
            res2print{k+1} = windowChar;            
        end
        
        %imprimo la nueva fila
        %convierto el cell array a str
        [str,errMsg] = vec2str(res2print,[],[],0);
        str = strrep(str,char(39),''); 
        fprintf(fileID,'%s\n',str);
    end
    fclose(fileID);
end