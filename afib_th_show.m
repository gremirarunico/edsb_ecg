% Grafica le soglie S e E e i valori trovati per ciascuna finestra per
% valutare la decisione dell'algoritmo, rispetivamente in ciano e fucsia.
% In alto in verde è mostrata la fibrillazione atriale trovata dal medico,
% in rosso quella dell'algorimo.
% Inoltre sono mostrate tutte le annotazioni del medico per esteso (leggere
% il label corrispettivo).

addpath './functions'

% Reset workspace
clear all
close all
clc

[points, attributes] = loadphysionet('ecg', '58');
[gold, extras] = loadphysionet('atr', '58');

% si considerano tutti i battiti
normalBeatsSamples = gold.sample;

% numero di intervalli RR in una finestra
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
% considero anche l'ultima finestra (storpia)
%[x, y, x1, x2, SD1, SD2, S(i+1)] = poincarePlot(normalBeatsSamples(index+L:end), attributes.samplingFrequency, 0);

for i = 1:fix(length(normalBeatsSamples)/L)
        line([normalBeatsSamples(i*L-L+1)/attributes.samplingFrequency, normalBeatsSamples(i*L-1)/attributes.samplingFrequency],[S(i),S(i)], 'Color', 'cyan', 'LineWidth', 1);
        line([normalBeatsSamples(i*L-L+1)/attributes.samplingFrequency, normalBeatsSamples(i*L-1)/attributes.samplingFrequency],[sampEntropy(i),sampEntropy(i)], 'Color', 'magenta', 'LineWidth', 1);
end
yline(0.01, 'Color', 'cyan');
yline(1.2, 'Color', 'magenta');

afibInWindow = (S > 0.01) & (sampEntropy > 1.2);

annotations = zeros(1, length(gold.sample));

y1 = 1;
for i = 1:length(afibInWindow)
    if afibInWindow(i)
        line([normalBeatsSamples(i*L-L+1)/attributes.samplingFrequency, normalBeatsSamples(i*L-1)/attributes.samplingFrequency],[y1,y1], 'Color', 'red', 'LineWidth', 10);
        annotations(i*L-L+1:i*L) = 1;
    end
end

[FN, FP, TP, TN, Sens, Spec, Acc] = afibContingency(gold, annotations)


% trovo l'indice di inizio o fine gruppo battiti (segnato con +)
pIndex = find(gold.beat=='+');
% di questi mi trovo l'indice del campione nella matrice dei battiti
PSamples = gold.sample(pIndex);
% e quale annotazione fosse
labels = gold.aux(pIndex);

% scelgo la y sulla quale stampare le annotazioni di gruppo
y1 = 2;
y2 = max(points(:,2));
for i = 2:length(pIndex)
    if(labels(i-1)=="(AFIB")
        line([PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[3,3], 'Color', 'green', 'LineWidth', 10);
    end
    ann = line([PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[y1,y1]);
    ann.Marker = 'o';
    text(PSamples(i-1)/attributes.samplingFrequency, y1, labels(i-1));
end

if(labels(i)=="(AFIB")
        line([PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[3,3], 'Color', 'green', 'LineWidth', 10);
end
line([PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[y1,y1]);
text(PSamples(end)/attributes.samplingFrequency, y1, labels(end));

ylim([-3,3]);