% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

k = 0;
for i=1:20
    for j=1:15
        k = k+1;
        k/20/15*100
        soglia = 0.015 + 0.005 * i;
        interval = j*10;
        annotations = waveletRfind(points(:,1), attributes.samplingFrequency, soglia, j);
        [FN(i, j), FP(i, j), TP(i, j), TN(i, j), Sens(i, j), Spec(i, j), Acc(i, j)] = contingency(gold.sample, annotations, attributes.totalsamples);
    end
end
plotROC(TP,FP,TN,FN,1);