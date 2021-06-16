% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');


bpFilt = designfilt('bandpassiir','FilterOrder',20,'HalfPowerFrequency1',1,'HalfPowerFrequency2',50,'SampleRate',attributes.samplingFrequency);
%fvtool(bpFilt)

filtredSig = filtfilt(bpFilt, points(:,1));
filtredSig(1:6000) = zeros(6000,1);

i=0;
j=0;
iter = 0;
th1a = 0.01:0.01:0.2;
th2a = 0.10:0.01:0.3;
finish = length(th1a)*length(th2a);
oldPercent = -1;
percent = 0;
for th1 = th1a
    i = i+1;
    for th2 = th2a
        j = j+1;
        iter = iter+1;
        annotations = fradenNewman(filtredSig, th1, th2);
        % calcolo contingenza
        [FN(i,j), FP(i,j), TP(i,j), TN(i,j)] = contingency(gold.sample, annotations, attributes.totalsamples);
        score(i,j) = 100*(TP(i,j)+TN(i,j))/(TP(i,j)+TN(i,j)+FP(i,j)+5*FN(i,j));
        
        percent = round(iter/finish*100);
        if(oldPercent ~= percent)
            disp("Percentuale completamento " + percent + "%" + " iterazione " + iter + " di " + finish);
            oldPercent = percent;
        end
    end
    j=0;
end

plotROC(TP(:),FP(:),TN(:),FN(:), 1)