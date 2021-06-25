%grafici delle tracce in cui è presente artefatto da movimento degli
%elettrodi (105 112 208 24 45 56 62 00)
% Reset workspace
clear all
close all
clc

addpath './functions'

% [points00, attributes00] = loadphysionet('ecg', '00');
% [points112, attributes112] = loadphysionet('ecg', '112');
% [points24, attributes24] = loadphysionet('ecg', '24');
% [points45, attributes45] = loadphysionet('ecg', '45');
% [points56, attributes56] = loadphysionet('ecg', '56');
% [points62, attributes62] = loadphysionet('ecg', '62');
% [points105, attributes105] = loadphysionet('ecg', '105');
[points62, attributes62] = loadphysionet('ecg', '62');
%[gold, extras] = loadphysionet('atr', '62');
%plotphysionet(points56,attributes56,gold,extras);
plot(filterEcg1and50(points62(:,1), attributes62.samplingFrequency))

% tiledlayout(8,1)
% nexttile
% title('Trace00');
% plot(filterEcg1and50(points00(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace112');
% plot(filterEcg1and50(points112(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace208');
% plot(filterEcg1and50(points208(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace24');
% plot(filterEcg1and50(points24(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace45');
% plot(filterEcg1and50(points45(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace56')
% plot(filterEcg1and50(points56(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace62')
% plot(filterEcg1and50(points62(:,1), attributes00.samplingFrequency))
% nexttile
% title('Trace105')
% plot(filterEcg1and50(points105(:,1), attributes00.samplingFrequency))
% 






