addpath './functions'

% Ottimizzazione dei parametri thS e thE dell'algoritmo di rilevamento di
% fibrillazione atriale su singola traccia

% Reset workspace
clear all
close all
clc

%caricamento dati
[points, attributes] = loadphysionet('ecg', '105');
[gold, extras] = loadphysionet('atr', '105');

% battiti totali (annotazioni gold standard)
normalBeatsSamples = gold.sample;

% numero di intervalli RR in una finestra
L = 128;

%inizializzazione parametri dell'algoritmo
S = zeros(1, fix(length(normalBeatsSamples)/L)+1);
sampEntropy = zeros(1, fix(length(normalBeatsSamples)/L)+1);

%inizializzazione matrice annotazioni AFIB finestra per finestra
afibInWindow = zeros(1, fix(length(normalBeatsSamples)/L)+1);

%calcolo dei parametri S e sample Entropy in ogni finestra
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

% inizializzazione matrici per la tabella di contingenza
FN = zeros(af, bf);
FP = zeros(af, bf);
TP = zeros(af, bf);
TN = zeros(af, bf);
Sens = zeros(af, bf);
Spec = zeros(af, bf);
Acc = zeros(af, bf);

final = af*bf;
oldPercent = -1;

% Costruzione delle curve ROC al variare di thS e thE
for a=1:af
    thS = 0.0045 + a * 0.0005; %soglia su S
    for b=1:bf
        z = z+1;
        percent = round(z/final,2)*100;
        if(percent ~= oldPercent)
            oldPercent = percent;
            disp("Completato al " + round(percent) +"%");
        end
        
        thE = 0.1 + b * 0.04; %soglia su sample Entropy
        
        % afibInWindow contiene un 1 in ogni finestra in cui S>thS,
        % sampEntropy > thE
        afibInWindow = (S > thS) & (sampEntropy > thE);
        
        annotations = zeros(1, length(gold.sample));
        
        % annotations contiene un 1 per ogni battito di una finestra che è
        % stata classificata come AFIB
        
        for i = 1:length(afibInWindow)
            if afibInWindow(i)
                annotations(i*L-L+1:i*L) = 1;
            end
        end
        
        [FN(a,b), FP(a,b), TP(a,b), TN(a,b), Sens(a,b), Spec(a,b), Acc(a,b)] = afibContingency(gold, annotations);
    end
end
plotROC(TP,FP,TN,FN,1); % grafica la curva ROC

% Manualmente troviamo il punto corrispondente alle soglie che ottimizzano
% le performance dell'algoritmo. La ricerca delle soglie si effettua
% tramite la funzione find da Command Window
% [a,b] = find(round(Sens,cifre)==valore & round(1-Spec, cifre)==valore)