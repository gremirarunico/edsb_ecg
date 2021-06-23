% main.m parte principale dello script
addpath './functions'

% Reset workspace
% clear all
% close all
% clc

[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

for i=1:10
    disp(i);
    annotations = waveletRfind(points(:,1), attributes.samplingFrequency, i);
    [FN(i), FP(i), TP(i), TN(i), Sens(i), Spec(i), Acc(i)] = contingency(gold.sample, annotations, attributes.totalsamples);
    
end
plotROC(TP,FP,TN,FN,1);