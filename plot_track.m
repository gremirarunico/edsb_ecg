% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
%close all
clc

trk = '15';

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', trk);
[gold, extras] = loadphysionet('atr', trk);

plotphysionet(points,attributes,gold,extras);