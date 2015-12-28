function  [CumRho, CumPhi,  CumMatdif, EjeX, EjeF,ParElec]  = SynchAnalizer(path2files, EEG, MatSig, Fs, Frange, Trange, WinSig, BinFreq, Step)

global condition
global fn

%path2files2=[path2files,'\',EEG.subject, condition, '_ALL'];
path2files2=[path2files,'\', '_ALL'];


%sel=[path2files,'\',EEG.subject, condition, '_SEL']
%sel2=[strcat('C:\Users\Andrés\Desktop\MRC_CBU_Experiments\SET\InteroceptionUDP\set\Study\ResultsSynchrony\-500-600'),'\',EEG.subject, condition, '_SEL'];
%sel2=[strcat('C:\Users\Eugenia\Documents\INECO\Actual\Sincronia de Fase'),'\',EEG.subject, condition, '_SEL'];
%sel2=[strcat('C:\Users\Eugenia\Documents\INECO\Actual\Sincronia de Fase'),'\', '_SEL'];

 Ntrials = size(MatSig,3);

 %Ntrials = 6 
 
 % Calculando fase trial final.
 [Rho, Phi0, EjeX, EjeF] = spectrograme( MatSig(:,:,Ntrials), Fs, Frange, Trange, WinSig, BinFreq, Step);
% OUTPUT :
%
%    Rho    = Matrix of signal amplitudes. 
%             1D electrodes, 2D time-points/step, 3D frequencies.
%    Phi    = Matrix of phase information. (as unitary complex vectors) 
%             1D electrodes, 2D time-points/step, 3D frequencies.
%    EjeX   = Time axis for plotting (in ms)
%    EjeF   = Frequency axis for plotting (in Hz)
 
 for T = 1:Ntrials
     
     Mt = MatSig(:,:,T);
          
     [Rho, Phi, EjeX, EjeF] = spectrograme( Mt, Fs, Frange, Trange, WinSig, BinFreq, Step);
          
     % [matdif, ParElec] = difphaser3(matphase, step)
     % Computes the phase diferences between all the electrode pairs, provided
     % in a matrix of phase info. 
     [Matdif, ParElec] = difphaser3(Phi, 1);
     
     [Matdif, MatDifShuffle, ParElec] = difphaser3NSH(Phi, Phi0, 1);
     
     if T==1
         CumRho = Rho;
         CumPhi = Phi;
         Phi0 = Phi;
         CumMatdif = Matdif;
         CumShuffle = MatDifShuffle;
     else
         CumRho = CumRho + Rho;
         CumPhi = CumPhi + Phi;
         CumMatdif = CumMatdif + Matdif;
         CumShuffle = MatDifShuffle + CumShuffle;
         Phi0 = Phi;
     end
     
 end
 
         CumRho = CumRho/Ntrials;
         CumPhi = CumPhi/Ntrials;
         CumMatdif = CumMatdif/Ntrials;
         CumShuffle = CumShuffle/Ntrials;
         
%  figure;
%  elec=mean(CumMatdif,1);
%  pcolor(EjeX,EjeF,squeeze(double((abs(elec))))');
%  caxis([0 0.7])
%  shading flat; colorbar;
%  print( gcf, '-djpeg', path2files2 );
%  
%  % save(path2files2);
%  save(path2files2, 'CumMatdif','CumRho','EjeX','EjeF','ParElec');
 %save(sel2, 'CumMatdif', 'CumShuffle', 'CumRho','EjeX','EjeF');

