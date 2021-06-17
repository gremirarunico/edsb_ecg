%grafici delle tracce in cui è presente artefatto da movimento degli
%elettrodi (105 112 208 24 45 56 62 00)
% Reset workspace
clear all
close all
clc

addpath './functions'

[points00, attributes00] = loadphysionet('ecg', '00');
[points112, attributes112] = loadphysionet('ecg', '112');
[points208, attributes208] = loadphysionet('ecg', '208');
[points24, attributes24] = loadphysionet('ecg', '24');
[points45, attributes45] = loadphysionet('ecg', '45');
[points56, attributes56] = loadphysionet('ecg', '56');
[points62, attributes62] = loadphysionet('ecg', '62');
[points105, attributes105] = loadphysionet('ecg', '105');


tiledlayout(8,1)
nexttile
title('Trace00');
plot(filterEcg1and50(point00(:,1), attributes00.samplingFrequency))
nexttile
title('Trace112');
plot(filterEcg1and50(point112(:,1), attributes00.samplingFrequency))
nexttile
title('Trace208');
plot(filterEcg1and50(point208(:,1), attributes00.samplingFrequency))
nexttile
title('Trace24');
plot(filterEcg1and50(point24(:,1), attributes00.samplingFrequency))
nexttile
title('Trace45');
plot(filterEcg1and50(point45(:,1), attributes00.samplingFrequency))
nexttile
title('Trace56')
plot(filterEcg1and50(point56(:,1), attributes00.samplingFrequency))
nexttile
title('Trace62')
plot(filterEcg1and50(point62(:,1), attributes00.samplingFrequency))
nexttile
title('Trace105')
plot(filterEcg1and50(point105(:,1), attributes00.samplingFrequency))







