addpath(genpath('C:\Users\Becarios\Documents\iEEG\Procesamiento de Señales\Scripts'))
addpath('C:\Users\Becarios\Documents\matlab_toolbox\eeglab11_0_4_3b')

clear all
close all
clc

fileName = 'Paciente8_EFP_2.set';
filePath = 'C:\\Users\\Becarios\\Documents\\iEEG\\Pacientes\\8. Florencia Ignacio\\EFPintra florencia Ignacio\\';

notchHz = [50 100];
notchWidth = 1;
bandpassRange = [1 200];

%Genero el archivo completo de labels
channelList = PrintChannelLabelsFromEEG(fileName,filePath,'Ignacio2');

%%

%paso manual para ver qué canales descartar
[channels2Discard prechannels2Discard jumps nr_jumps]  = GetChannels2DiscardFromEEG(filePath,fileName); %bad channels by scripts + markers
%%
bad_chans2 = []; %bad channels due to epileptic activity + markers
bad_chans1 = [1 2 7 48 67 73 75 78 79 91 92 93 94 95 96 97 98 99 100 101 105 106 120 121 122 125 127];

%
channels2Delete = union(bad_chans1,bad_chans2);

Preprocess(fileName, filePath,'Ignacio2',channels2Delete,notchHz,notchWidth,bandpassRange)

%To run next step it is necessary to have electrode localization
%PreprocessChannelLocation('Hernandez1_LocalizacionElectrodos.txt',channels2Delete,'Hernandez1_Preprocessed');

display('DONE')