% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

% ottengo i dati da phisionet
[points, attributes] = loadphysionet('ecg', '118');
[gold, extras] = loadphysionet('atr', '118');

% plot physion
plotphysionet(points,attributes,gold,extras);

% costruisco il template
templateSize = 11;
templateMatrix = multiInputTemplateBuilder(['118'; '200'], 100, 2000, 11);
%templateMatrix = templateDataSelector(points(:,1), gold.sample, 100, 2000, 11);
%templateMatrix = templateDataSelector(points(:,1), gold.sample, 100, 200, templateSize);
template = mean(templateMatrix);

% algoritmo di riconoscimento
%[annotations, c] = crosscorrelazione(points(:,1), mean(templateMatrix), 0.9);
%[annotations, c] = templateL2Norm(points(:,1), template, -0.015);
annotations = fradenNewman(points(:,1), 0.001, 0.2);

% calcolo contingenza
[FN, FP, TP, TN] = contingency(gold.sample, annotations, attributes.totalsamples)

% calcolo rapporto segnale rumore
SNR = moody(points(:,1), gold.sample, attributes.samplingFrequency)

% confronto riconoscimento algoritmo vs medico
%plot(((1:attributes.totalsamples)/attributes.samplingFrequency), c, '-');
%plotComparison(points(:,1), attributes, gold, annotations, c);
plotComparison(points(:,1), attributes, gold, annotations);

% disegno del template
figure;
hold on
for i = 1:size(templateMatrix, 1)
    plot(templateMatrix(i,:));
end
plot(mean(templateMatrix), 'k', 'LineWidth',5);
plot(mean(templateMatrix)+3*sqrt(var(templateMatrix)), 'r', 'LineWidth',5);
plot(mean(templateMatrix)-3*sqrt(var(templateMatrix)), 'r', 'LineWidth',5);
xline(templateSize/2+1);

