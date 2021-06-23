% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

[points, attributes] = loadphysionet('ecg', '22');
[gold, extras] = loadphysionet('atr', '22');
signal = points(:,1);
% 
% signal(signal>2.5) = 2.5;
% signal(signal<-2.5) = -2.5;
% 
% 
% annotations = waveletRfind(signal, attributes.attributes.samplingFrequencyuency);
% [FN, FP, TP, TN, Sens, Spec, Acc] = contingency(gold.sample, annotations, attributes.totalsamples);


s = 1:length(signal); % vettore campioni
t = s ./ attributes.samplingFrequency; % vettore dei tempi

% DWT non decimata di livello 4 con sym4 (come madre)
wt = modwt(signal, 4, 'sym4');

wtrec = zeros(size(wt));

% etraggo solo i coefficienti di dettaglio d3 e d4 contenenti il contenuto
% frequenzale dei complessi QRS
wtrec(3:4, :) = wt(3:4,:);

% antritrasformo con la wavelet sym4
y = imodwt(wtrec,'sym4');

y = abs(y).^2;

if ~exist('th', 'var')
    avg = mean(y);
    th = 8*avg;
end

if ~exist('pdistMS', 'var')
    pdistMS = 150;
end

[qrspeaks,locs] = findpeaks(y, t,'MinPeakHeight',th, 'MinPeakDistance',pdistMS/1000);
locs = locs * attributes.samplingFrequency;