addpath './functions'

% Reset workspace
clear all
close all
clc

[points, attributes] = loadphysionet('ecg', '12');
[gold, extras] = loadphysionet('atr', '12');

% battiti normali
%normalBeatsSamples = gold.sample(find(gold.beat=='N'));
normalBeatsSamples = gold.sample;

% numero di battiti in una finestra
L = 128;

S = zeros(1, fix(length(normalBeatsSamples)/L)+1);
sampEntropy = zeros(1, fix(length(normalBeatsSamples)/L)+1);

afibInWindow = zeros(1, fix(length(normalBeatsSamples)/L)+1);

index = 1;
for i = 1:fix(length(normalBeatsSamples)/L)
    [x, y, x1, x2, SD1, SD2, S(i)] = poincarePlot(normalBeatsSamples(index:index+L), attributes.samplingFrequency, 0);
    
    RRs = x;
    RRs(end) = y(end);
    
    sampEntropy(i) = sampleEntropy(2, 0.2 * std(RRs), RRs);
    
    % indice dei battiti, di L in L
    index = index + L;
end

thS = 0;
thE = 0;

z = 0;

af = 40;
bf = 40;

FN = zeros(af, bf);
FP = zeros(af, bf);
TP = zeros(af, bf);
TN = zeros(af, bf);
Sens = zeros(af, bf);
Spec = zeros(af, bf);
Acc = zeros(af, bf);

final = af*bf;
oldPercent = -1;
for a=1:af
    thS = 0.0045 + a * 0.0005;
    for b=1:bf
        z = z+1;
        percent = round(z/final,2)*100;
        if(percent ~= oldPercent)
            oldPercent = percent;
            disp("Completato al " + round(percent) +"%");
        end
        
        thE = 0.1 + b * 0.04;
        
        %disp("For thS=" + thS + " and thE=" + thE);
        afibInWindow = (S > thS) & (sampEntropy > thE);
        
        annotations = zeros(1, length(gold.sample));
        
        for i = 1:length(afibInWindow)
            if afibInWindow(i)
                annotations(i*L-L+1:i*L) = 1;
            end
        end
        
        [FN(a,b), FP(a,b), TP(a,b), TN(a,b), Sens(a,b), Spec(a,b), Acc(a,b)] = afibContingency(gold, annotations);
    end
end
plotROC(TP,FP,TN,FN,1);