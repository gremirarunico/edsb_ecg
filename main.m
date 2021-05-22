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

% 
x1 = points(:,1);
samplingFreq = attributes.samplingFrequency;
t = [0 : 1/samplingFreq : attributes.totalsamples/samplingFreq]';
ann = gold.sample;
ecg1 = zeros(size(t,1), 1);
ecg1(1:1:size(x1,1)) = x1;
x = ecg1;


 for i=1:14
     th1=0.05*i*max(x);
     [r_s]= AlgoritmoFradenNewman(t,x,ann, th1);
     [TP(i),FP(i),TN(i),FN(i),Sens(i),Spec(i),Acc(i)]=evaluationECGsignal(ann,x,t,samplingFreq,'118', th1)
 end
 [r_s]= AlgoritmoFradenNewman(t,x,ann);
  [TP,FP,TN,FN,Sens,Spec,Acc]=evaluationECGsignal(ann,x,t,samplingFreq,'118',th1)
minFN = min(FN);


% % 
