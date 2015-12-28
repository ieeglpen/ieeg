clear all
close all
clc

load 'resultPLVMaps_ACC_lowgamma2.mat'
accMatrix = result;

%load 'resultPLVMaps_INT_lowgamma2.mat'
intMatrix = result;

[SignifChart, ProbChart, avgNsd] = GraphComparer(accMatrix,intMatrix,0.05);

display('NONE')