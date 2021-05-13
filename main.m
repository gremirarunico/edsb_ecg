% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

%
[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

plotphysionet(points,attributes,gold,extras);
