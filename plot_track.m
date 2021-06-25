% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
%close all
clc

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '16539');
[gold, extras] = loadphysionet('atr', '16539');

plotphysionet(points,attributes,gold,extras);