addpath './functions'

% Costruzione di alcuni grafici per l'interpretazione dei dati

% Reset workspace
clear all
close all
clc

% caricamento dati
[points, attributes] = loadphysionet('ecg', '00');
[gold, extras] = loadphysionet('atr', '00');

%plot(((1:attributes.totalsamples)/attributes.samplingFrequency)', points(:,1), '-');
hold on

% battiti totali (annotazioni gold standard)
normalBeatsSamples = gold.sample;

% numero di intervalli RR in una finestra
L = 128;

% inizializzazione parametri algoritmo
S = zeros(1, fix(length(normalBeatsSamples)/L)+1);
sampEntropy = zeros(1, fix(length(normalBeatsSamples)/L)+1);

% matrice annotazioni AFIB window per window
afibInWindow = zeros(1, fix(length(normalBeatsSamples)/L)+1);

index = 1;

for i = 1:3
    % traccia il plot di Poincaré
    [x, y, x1, x2, SD1, SD2, S(i)] = poincarePlot(normalBeatsSamples(index:index+L), attributes.samplingFrequency, 1);
    xlim([0,2])
    ylim([0,2])
    % crea il vettore degli intervalli RR dagli output della funzione
    % poincarePlot x e y (sono gli intervalli RR traslati di 1)
    RRs = x; 
    RRs(end) = y(end);
    
    sampEntropy(i) = sampleEntropy(2, 0.2 * std(RRs), RRs);
    
    %clf
    
    % indice dei battiti, di L in L
    index = index + L;
    
    if((S(i) > 0.0085) & (sampEntropy(i) > 1.22))
        disp(i);
    end
end
return
% considero anche l'ultima finestra (storpia)
%[x, y, x1, x2, SD1, SD2, S(i+1)] = poincarePlot(normalBeatsSamples(index+L:end), attributes.samplingFrequency, 0);

for i = 1:fix(length(normalBeatsSamples)/L)
        %line([normalBeatsSamples(i*L-L+1)/attributes.samplingFrequency, normalBeatsSamples(i*L-1)/attributes.samplingFrequency],[S(i),S(i)], 'Color', 'cyan', 'LineWidth', 1);
        %line([normalBeatsSamples(i*L-L+1)/attributes.samplingFrequency, normalBeatsSamples(i*L-1)/attributes.samplingFrequency],[sampEntropy(i),sampEntropy(i)], 'Color', 'magenta', 'LineWidth', 1);
end
%yline(0.01, 'Color', 'cyan');
%yline(1.2, 'Color', 'magenta');

afibInWindow = (S > 0.0085) & (sampEntropy > 1.22);

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
        line([PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[1.25,1.25], 'Color', 'green', 'LineWidth', 10);
    end
    %ann = line([PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[y1,y1]);
    %ann.Marker = 'o';
    %text(PSamples(i-1)/attributes.samplingFrequency, y1, labels(i-1));
end

if(labels(i)=="(AFIB")
        line([PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[1.25,1.25], 'Color', 'green', 'LineWidth', 10);
end

%line([PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[y1,y1]);
%text(PSamples(end)/attributes.samplingFrequency, y1, labels(end));

ylim([-1,4]);

