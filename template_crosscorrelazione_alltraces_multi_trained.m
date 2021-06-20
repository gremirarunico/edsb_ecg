% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

%allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "105"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "203"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "30"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];
allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "105"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "203"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];

sampleStart = 100;
nWindows = 200; 
templateSize = 7; %valore ottimizzato 
sogliaGammaSigma = 0.7750; %valore ottimizzato
templateMatrix = multiInputTemplateBuilder(["118"; "105"; "203"; "204"], sampleStart, nWindows, templateSize, 1, 1);
template = mean(templateMatrix);

final = length(allDatasets);
oldPercent = -1;

for i = 1:final
    percent = i/final*100;
    if(percent ~= oldPercent)
        oldPercent = percent;
        disp("Completato al " + round(percent) +"%");
    end
    [points, attributes] = loadphysionet('ecg', convertStringsToChars(allDatasets(i)));
    [gold, extras] = loadphysionet('atr', convertStringsToChars(allDatasets(i)));
    
    filtredSig = filterEcg1and50(points(:,1), attributes.samplingFrequency);
    
    [annotations, c] = crosscorrelazione(filtredSig, template, sogliaGammaSigma);

    [FN(i), FP(i), TP(i), TN(i), Sens(i), Spec(i), Acc(i)] = contingency(gold.sample, annotations, attributes.totalsamples);
end

figure('Name','Performance crosscorrelation on all traces','NumberTitle','off');
title('Performance crosscorrelation on all traces');
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
