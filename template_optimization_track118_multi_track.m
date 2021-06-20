% template_optimization.m ottimizzazione dell'algoritmo con template
addpath './functions'

% Reset workspace
clear all
close all
clc

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

%segnale filtrato
filtredSig = filterEcg1and50(points(:,1), attributes.samplingFrequency);

% dimensione della finestra del template
sampleStart = 100;
nWindows = 200;

% costruisco il template senza filtraggio aggiuntivo
FN = zeros(13,11);
FP = zeros(13,11);
TP = zeros(13,11);
TN = zeros(13,11);
Sens = zeros(13,11);
Spec = zeros(13,11);
Acc = zeros(13,11);
FNf = zeros(13,11);
FPf = zeros(13,11);
TPf = zeros(13,11);
TNf = zeros(13,11);
Sensf = zeros(13,11);
Specf = zeros(13,11);
Accf = zeros(13,11);

totalRep = 13*11;
oldPercent = -1;
percentCount = 0;
for i=1:13
    templateSize = 3+2*i;% numeri dispari da 5 a 21
    templateMatrix = multiInputTemplateBuilder(["118"; "105"; "203"; "204"], sampleStart, nWindows, templateSize, 1, 1);
    template = mean(templateMatrix);
    
    for j=1:11
        percentCount = percentCount + 1;
        percent = round(percentCount/totalRep*100,2);
        if(oldPercent ~= percent)
            oldPercent = percent;
            disp("Stato simulazione " + percent + "%");
        end
        sogliaGammaSigma = 0.565 + 0.035*j;
        % riconoscimento
        [annotations, c] = crosscorrelazione(filtredSig, template, sogliaGammaSigma);
        
        % calcolo contingenza (quelli con *f sono del segnale filtrato)
        [FN(i,j), FP(i,j), TP(i,j), TN(i,j), Sens(i,j), Spec(i,j), Acc(i,j)] = contingency(gold.sample, annotations, attributes.totalsamples);
    end
end
%plotROC(TP,FP,TN,FN,newPlot)
% plotTemplate(templateMatrix, 'Template senza filtraggio');
% plotComparison(points(:,1), attributes, gold,annotations, c, 'Template senza filtraggio');
% plotTemplate(templateMatrixFiltred, 'Template con filtraggio');
% plotComparison(filtredSig, attributes, gold,annotationsFiltred, cf, 'Template con filtraggio');