function SetNodesToDefaultValue(path,fileName,chans2Set,val2Set,file2save)

fid = fopen([path fileName '.node'],'r');
nodes = textscan(fid, '%d %d %d %d %d %s');
fclose(fid);

nodes{1,4}(chans2Set,:) = val2Set;
nodes{1,5}(chans2Set,:) = val2Set;

file_nameNode = [file2save '.node'];       
dlmcell(file_nameNode,nodes);

