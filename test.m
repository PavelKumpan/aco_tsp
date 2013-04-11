clear all;
close all;
clc;

map = load('data/chr25a.dat');

params.colonySize   = 5;
params.maxIter      = 50;
params.q0           = 0.1;
params.beta         = 3;  
params.ro           = 0.3; 
params.phi          = 0.6;
params.alpha        = 2;

tsp(map, params, @plotWorld);