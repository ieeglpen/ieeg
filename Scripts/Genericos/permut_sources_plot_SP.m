%%%%% plot sources time and pvalue of permutation
%%%%% Se necesitan dos funciones: plot_std_met_sources y plotpvals_lpen_met 

clear all
restoredefaultpath
addpath(genpath('C:\Users\INECO\Documents\MATLAB\eeglab'))

%%%% rutas
dir = 'C:\Users\INECO\Documents\MATLAB\Simon y Pedro';
dirperm = 'C:\Users\INECO\Documents\MATLAB\Simon y Pedro\Permutation_sources';
dirdata = 'C:\Users\INECO\Documents\MATLAB\Simon y Pedro\sources_bs';
dirsave = 'C:\Users\INECO\Documents\MATLAB\Simon y Pedro\Plots_sources';

%%%% colores
green = [0 .5 0];       
red = [1 0 0];         
purple = [.5 0 .5];     
blue = [0 0 1];         
olive = [.5 .5 0];   
orange = [1 .5 0];       
fuxia = [1 0 1];

%%%%%%% parametros time souces %%%%%%%%%%%%%%%
group = {'ctrl_','asd_','adhd_'};
groupname = {'Ctrl','Asd','Adhd'};
source = {'acc_'};   %% 
cond = {'Ssus_'}; 
hemisf = {'l', 'r'};
hemisferio = {'left_','right_'};
zscored = {'z_'};
color1 = purple;     %%%% control
color2 = olive;      %%%% asd
color3 = orange;     %%%% adhd

%%%%%%% parametros permutation souces %%%%%%%%%%%%%%%
groupperm = {'ctrlVSasd', 'ctrlVSadhd', 'asdVSadhd' };
grouppermname = {'Ctrl/vs/Asd', 'Ctrl/vs/Adhd', 'Asd/vs/Adhd' };
color1perm = red;       %%%% ctrlVSasd
color2perm = blue;      %%%% ctrlVSadhd
color3perm = green;     %%%% asdVSadhd

%%%%% plotting time sources  %%%%%%%%%
 cd (dir);
 time= {'time'}; 
 load ([time{1} '.mat']);
 
% for s=1:2     %sources
    
%     for c=1:2    % conditions 
        
        for hem=1:2     %hemisferios
 
          %%%% parametros figuras
          h=figure;
          subplot(2,1,1);
          
          %%%%% plot time sources
          cd (dirdata);
          load ([zscored{1} group{1,1} source{1} cond{1} hemisf{hem} '.mat']);
          var1 = Value';
          cd (dir);
          h1 = plot_std_met_sources(var1,time,color1); 
          hold on
         
          cd (dirdata);
          load ([zscored{1} group{1,2} source{1} cond{1} hemisf{hem} '.mat']);
          var2 = Value';
          cd (dir);
          h2 = plot_std_met_sources(var2,time,color2); 
          hold on
         
          cd (dirdata);
          load ([zscored{1} group{1,3} source{1} cond{1} hemisf{hem} '.mat']);
          var3 = Value';
          cd (dir);
          h3 = plot_std_met_sources(var3,time,color3); 

          legend([h1 h2 h3],{groupname{1,1},groupname{1,2},groupname{1,3}}, 'Location','northwest');

         %%%%% plotting pvalues of permutation %%%%
         subplot(2,1,2);
         cd (dirperm);
         load ([zscored{1} cond{1} hemisf{hem} source{1} groupperm{1,1} '.mat']);
         cd (dir);
         plotpvals_lpen_met(1,0.05,pvals,time,color1perm,1,0,'-');
         hold on
         clear pvals t df
        
         cd (dirperm);
         load ([zscored{1} cond{1} hemisf{hem} source{1} groupperm{1,2} '.mat']);
         cd (dir);
         plotpvals_lpen_met(1,0.05,pvals,time,color2perm,1,0,'-');
         hold on
         clear pvals t df
        
         cd (dirperm);
         load ([zscored{1} cond{1} hemisf{hem} source{1} groupperm{1,3} '.mat']);
         cd (dir);
         plotpvals_lpen_met(1,0.05,pvals,time,color3perm,1,0,'-'); 
        
         legend(grouppermname{1,1},grouppermname{1,2},grouppermname{1,3}, 'Location','northwest');

         cd (dirsave);

         saveas(h,[zscored{1} hemisferio{hem} source{1} cond{1} ],'tiff');   %sourceperm{1}
         
        end
%     end
% end

cd (dir);

display ('DONE');

