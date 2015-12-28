function slidyText = GetSlidySlideText(slideTitle,contents,style)
%contents cell matrix of content in table

slidyText = [' <div class="slide">\n'...
                '<center>\n'...
                ['<h3>' slideTitle '</h3>\n']...
                '<div style="width:100%%;">\n'];
            
tableText = '<table>\n';

columns = size(contents,2);
rows = size(contents,1);

for i = 1 : rows
    rowText = '<tr>\n';
    for j = 1 : columns  
        
        style2print = '';
        
        if ~isempty(style)
            style2print = style;
        end
        
        rowText = [ rowText '<td>\n'...
            ['<img style="' style '" src = "' contents{i,j} '" />\n']...
            '</td>\n'];        
    end
    rowText = [rowText '</tr>\n'];
    tableText = [tableText rowText];
end
tableText = [tableText '</table>\n'];

slidyText = [ slidyText tableText '</center>'...
                '</div>\n'];
