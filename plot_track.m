% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
%close all
clc

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '12');
[gold, extras] = loadphysionet('atr', '12');

plotphysionet(points,attributes,gold,extras);