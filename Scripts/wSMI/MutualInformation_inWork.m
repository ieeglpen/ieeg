function MutualInformation(path,fileName)

direc = path;
file = fullfile(direc,'Results','ST',[fileName,'_CSD.mat']);
fileout= fullfile(direc,'Results','SMI',[fileName,'_CSD.mat']);

load(file)

taus = 1:size(count,2); %% corresponds to the amount of taus

for tau = taus
   
   wSMI.trMEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   wSMI.MEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   wSMI.MEDIAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   wSMI.IQR{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 
   wSMI.std{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 

   SMI.trMEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   SMI.MEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   SMI.MEDIA{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   SMI.IQR{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 
   SMI.std{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 

   R_wSMI.trMEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   R_wSMI.MEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   R_wSMI.MEDIAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   R_wSMI.IQR{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 
   R_wSMI.std{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 

   R_SMI.trMEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   R_SMI.MEAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   R_SMI.MEDIAN{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1);       
   R_SMI.IQR{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 
   R_SMI.std{tau} = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,1); 

   AUX1 = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,size(sym{tau},3));       
   AUX2 = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,size(sym{tau},3));       
   AUX3 = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,size(sym{tau},3));       
   AUX4 = zeros(size(sym{tau},1)*(size(sym{tau},1)-1)/2,size(sym{tau},3));       

    %%% PE calculation

    disp('MI calculation')
   
    for trial = 1:size(sym{tau},3)
       disp([file ' - tau:' num2str(2^(tau-1)) ', trial ' num2str(trial) ' of ' num2str(size(sym{tau},3))])
       [AUX1(:,trial),AUX2(:,trial),AUX3(:,trial),AUX4(:,trial)] = MI_SMI_and_wSMI(sym{tau}(:,:,trial),count{tau}(:,:,trial),3);
    end
   
   wSMI.trMEAN{tau} = trimmean(AUX2,90,'round',2);       
   wSMI.MEAN{tau}   = nanmean(AUX2,2);       
   wSMI.MEDIAN{tau} = nanmedian(AUX2,2);       
   wSMI.IQR{tau} = iqr(AUX2,2);       
   wSMI.std{tau} = std(AUX2,[],2);       
   wSMI.Trials{tau} = AUX2;       

   SMI.trMEAN{tau} = trimmean(AUX1,90,'round',2);       
   SMI.MEAN{tau}   = nanmean(AUX1,2);       
   SMI.MEDIAN{tau} = nanmedian(AUX1,2);       
   SMI.IQR{tau} = iqr(AUX1,2);       
   SMI.std{tau} = std(AUX1,[],2);       
   SMI.Trials{tau} = AUX1;       

   R_wSMI.trMEAN{tau} = trimmean(AUX4,90,'round',2);       
   R_wSMI.MEAN{tau}   = nanmean(AUX4,2);       
   R_wSMI.MEDIAN{tau} = nanmedian(AUX4,2);       
   R_wSMI.IQR{tau} = iqr(AUX4,2);       
   R_wSMI.std{tau} = std(AUX4,[],2);       
   R_wSMI.Trials{tau} = AUX4;       

   R_SMI.trMEAN{tau} = trimmean(AUX3,90,'round',2);       
   R_SMI.MEAN{tau}   = nanmean(AUX3,2);       
   R_SMI.MEDIAN{tau} = nanmedian(AUX3,2);       
   R_SMI.IQR{tau} = iqr(AUX3,2);       
   R_SMI.std{tau} = std(AUX3,[],2);       
   R_SMI.Trials{tau} = AUX3;       

end
 
   
save(fileout,'SMI','wSMI','R_SMI','R_wSMI')





   
