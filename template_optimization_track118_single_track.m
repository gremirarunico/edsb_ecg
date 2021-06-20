% template_optimization.m ottimizzazione dell'algoritmo con template
addpath './functions'

% Reset workspace
clear all
close all
clc

allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "105"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "203"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "30"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

%segnale filtrato
filtredSig = filterEcg1and50(points(:,1), attributes.samplingFrequency);

% dimensione della finestra del template

sampleStart = 100;
nWindows = 200;

% costruisco il template senza filtraggio aggiuntivo
FN = zeros(9,11);
FP = zeros(9,11);
TP = zeros(9,11);
TN = zeros(9,11);
Sens = zeros(9,11);
Spec = zeros(9,11);
Acc = zeros(9,11);
FNf = zeros(9,11);
FPf = zeros(9,11);
TPf = zeros(9,11);
TNf = zeros(9,11);
Sensf = zeros(9,11);
Specf = zeros(9,11);
Accf = zeros(9,11);

totalRep = 13*11;
oldPercent = -1;
percentCount = 0;
for i=1:13
    templateSize = 3+2*i;% numeri dispari da 5 a 21
    templateMatrix = templateDataSelector(points(:,1), gold.sample, sampleStart, nWindows, templateSize);
    template = mean(templateMatrix);
    
    % costruisco il template senza filtraggio aggiuntivo
    templateMatrixFiltred = templateDataSelector(filtredSig, gold.sample, sampleStart, nWindows, templateSize);
    templateFiltred = mean(templateMatrixFiltred);
    for j=1:11
        percentCount = percentCount + 1;
        percent = round(percentCount/totalRep*100,2);
        if(oldPercent ~= percent)
            oldPercent = percent;
            disp("Stato simulazione " + percent + "%");
        end
        sogliaGammaSigma = 0.565 + 0.035*j;
        % riconoscimento
        [annotations, c] = crosscorrelazione(points(:,1), template, sogliaGammaSigma);
        [annotationsFiltred, cf] = crosscorrelazione(filtredSig, templateFiltred, sogliaGammaSigma);
        
        % calcolo contingenza (quelli con *f sono del segnale filtrato)
        [FN(i,j), FP(i,j), TP(i,j), TN(i,j), Sens(i,j), Spec(i,j), Acc(i,j)] = contingency(gold.sample, annotations, attributes.totalsamples);
        [FNf(i,j), FPf(i,j), TPf(i,j), TNf(i,j), Sensf(i,j), Specf(i,j), Accf(i,j)] = contingency(gold.sample, annotationsFiltred, attributes.totalsamples);
    end
end

% plotTemplate(templateMatrix, 'Template senza filtraggio');
% plotComparison(points(:,1), attributes, gold,annotations, c, 'Template senza filtraggio');
% plotTemplate(templateMatrixFiltred, 'Template con filtraggio');
% plotComparison(filtredSig, attributes, gold,annotationsFiltred, cf, 'Template con filtraggio');