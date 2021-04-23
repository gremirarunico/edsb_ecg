% main.m parte principale dello script

% Reset workspace
clear all
close all
clc

%
[points, attributes] = loadphysionet('ecg', '207');
[gold, extras] = loadphysionet('atr', '207');