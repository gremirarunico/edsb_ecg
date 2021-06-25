%Ottimizzazione algoritmo con template basato su metrica di distanza L2
%Si costruisce un template basato su nWindows forme d'onda di una traccia.
%Si applica l'algoritmo di riconoscimento sulla traccia stessa al variare di
%soglia e templateSize. Si tracciano le curve ROC e si determinano i valori 
%ottimi di soglia e dimensione del template.

addpath './functions'

% Reset workspace

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

%segnale filtrato
filtredSig = filterEcg1and50(points(:,1), attributes.samplingFrequency);

% dimensione della finestra del template

sampleStart = 100;
nWindows = 200;
a = 9;
b = 9;
% costruisco il template senza filtraggio aggiuntivo
FN = zeros(a,b);
FP = zeros(a,b);
TP = zeros(a,b);
TN = zeros(a,b);
Sens = zeros(a,b);
Spec = zeros(a,b);
Acc = zeros(a,b);

totalRep = a*b;
oldPercent = -1;
percentCount = 0;
for i=1:7
    templateSize = 3+2*i;% numeri dispari da 5 a 21
    
    templateMatrix = templateDataSelector(filtredSig, gold.sample, sampleStart, nWindows, templateSize);
    templateMatrix = (templateMatrix' ./ max(templateMatrix'))';
    template = mean(templateMatrix);
    
    for j=1:b
        percentCount = percentCount + 1;
        percent = round(percentCount/totalRep*100,2);
        if(oldPercent ~= percent)
            oldPercent = percent;
            disp("Stato simulazione " + percent + "%");
        end
        soglia = -0.5 + 0.05*j;
        % riconoscimento
        [annotations, c] = templateL2Norm(filtredSig, template, soglia);
        
        [FN(i,j), FP(i,j), TP(i,j), TN(i,j), Sens(i,j), Spec(i,j), Acc(i,j)] = contingency(gold.sample, annotations, attributes.totalsamples);
    end
end
plotROC(TP,FP,TN,FN,1);

% Dalla ROC si trova manualmente il punto che garantisce le performance
% migliori. Si trovano i parametri corrispondenti con
% [a,b] = find(round(Sens, cifre) == valore & round(1-Spec, cifre)==valore)