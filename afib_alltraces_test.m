addpath './functions'

% Reset workspace
clear all
close all
clc

allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "105"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "203"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];

%allDatasets = ["17"; "18"; "30"];

final = length(allDatasets);
oldPercent = -1;

for i = 1:final
    percent = round(i/final,2)*100;
    if(percent ~= oldPercent)
        oldPercent = percent;
        disp("Completato al " + round(percent) +"%");
    end
    [points, attributes] = loadphysionet('ecg', convertStringsToChars(allDatasets(i)));
    [gold, extras] = loadphysionet('atr', convertStringsToChars(allDatasets(i)));
    
    
    % battiti normali
    %normalBeatsSamples = gold.sample(find(gold.beat=='N'));
    normalBeatsSamples = gold.sample;
    
    % numero di battiti in una finestra
    L = 128;
    thS = 0.01;%0.01
    thE = 1.2;%1.2
    
    S = zeros(1, fix(length(normalBeatsSamples)/L)+1);
    sampEntropy = zeros(1, fix(length(normalBeatsSamples)/L)+1);
    
    afibInWindow = zeros(1, fix(length(normalBeatsSamples)/L)+1);
    
    
    index = 1;
    for j = 1:fix(length(normalBeatsSamples)/L)
        [x, y, x1, x2, SD1, SD2, S(j)] = poincarePlot(normalBeatsSamples(index:index+L-1), attributes.samplingFrequency, 0);
        
        RRs = x;
        RRs(end) = y(end);
        
        % algo del cinese
        sampEntropy(j) = sampleEntropy(2, 0.2 * std(RRs), RRs);
        
        % indice dei battiti, di L in L
        index = index + L;
    end
    % considero anche l'ultima finestra (storpia)
    %[x, y, x1, x2, SD1, SD2, S(i+1)] = poincarePlot(normalBeatsSamples(index+L:end), attributes.samplingFrequency, 0);
    
    afibInWindow = (S > thS) & (sampEntropy > thE);
    
    annotations = zeros(1, length(gold.sample));
    
    for j = 1:length(afibInWindow)
        if afibInWindow(j)
            annotations(j*L-L+1:j*L) = 1;
        end
    end
    
    [FN(i), FP(i), TP(i), TN(i), Sens(i), Spec(i), Acc(i)] = afibContingency(gold, annotations);
end

figure('Name','Performance wavelet on all traces','NumberTitle','off');
title('Performance wavelet on all traces');
plots = tiledlayout(3,1);
p1 = nexttile(plots);
p2 = nexttile(plots);
p3 = nexttile(plots);

plot(p1, Spec);
text(p1, 1:length(Spec), Spec, allDatasets);

plot(p2, Sens);
text(p2, 1:length(Sens), Sens, allDatasets);

plot(p3, Acc);
text(p3, 1:length(Acc), Acc, allDatasets);

xlabel(p1, 'N trace');
ylabel(p1, 'Spec');

xlabel(p2, 'N trace');
ylabel(p2, 'Sens');

xlabel(p3, 'N trace');
ylabel(p3, 'Accuracy');

