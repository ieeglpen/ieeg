function MutualInformation(path,fileName,sym)

direc = path;
file = fullfile(direc,'Results','ST',[fileName,'_CSD.mat']);
fileout= fullfile(direc,'Results','SMI',[fileName,'_CSD.mat']);
do_MI_final(file,fileout,sym);