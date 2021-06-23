
addpath './functions'

% Reset workspace
clear all
close all
clc

[points, attributes] = loadphysionet('ecg', '22');
[gold, extras] = loadphysionet('atr', '22');

ecgsig = points(:,1);
ecgsig = ecgsig(1001200:1003050);

s = 1:length(ecgsig); % vettore campioni
t = s ./ attributes.samplingFrequency; % vettore dei tempi

% DWT non decimata di livello 4 con sym4 (come madre)
wt = modwt(ecgsig, 'sym4', 6);

% divisione in dettagli e approssimazione
% d1 = zeros(size(wt));
% d2 = zeros(size(wt));
% d3 = zeros(size(wt));
% d4 = zeros(size(wt));
% a4 = zeros(size(wt));
 
% d1(1,:) = wt(1,:);
% d2(2,:) = wt(2,:);
% d3(3,:) = wt(3,:);
% d4(4,:) = wt(4,:);
% d5(5,:) = wt(5,:);
% a5(6,:) = wt(6,:);

d1 = wt(1,:);
d2 = wt(2,:);
d3 = wt(3,:);
d4 = wt(4,:);
d5 = wt(5,:);
d6 = wt(6,:);
d7 = wt(7,:);


% d1 = imodwt(d1, 'sym4');
% d2 = imodwt(d2,'sym4');
% d3 = imodwt(d3, 'sym4');
% d4 = imodwt(d4, 'sym4');
% d5 = imodwt(d5, 'sym4');
% a5 = imodwt(a5, 'sym4');

F1 = figure;
%F1.Units = 'normalized';
tiledlayout(8,1);

p1 = nexttile; %plot ECG
plot(ecgsig, 'r');
ylabel('ECG');
title('Segnale ecg');

p0 = nexttile;
plot(d7); %plot d4
ylabel('d7');

p2 = nexttile;
plot(d6); %plot approximation
ylabel('d6');

p3 = nexttile;
plot(d5); %plot approximation
ylabel('d5');

p4 = nexttile;
plot(d4); %plot d4
ylabel('d4');

p5 = nexttile;
plot(d3); %plot d3
ylabel('d3');

p6 = nexttile;
plot(d2); %plot d2
ylabel('d2');

p7 = nexttile;
plot(d1); %plot d4
ylabel('d1');


linkaxes([p1,p2,p3,p4,p5,p6,p7, p0],'x')
axis tight

figure
recwt = zeros(size(wt));
recwt3(3,:) = wt(3,:);
recwt4(4,:) = wt(4,:);
recwt34(3:4,:) = wt(3:4,:);
recECG3 = imodwt(recwt3, 'sym4');
recECG4 = imodwt(recwt4, 'sym4');
recECG34 = imodwt(recwt34, 'sym4');

F2 = figure;
%F1.Units = 'normalized';
tiledlayout(4,1);

pp2 = nexttile; %plot ECG
plot(ecgsig, 'r');
ylabel('ECG');
title('Segnale ecg');

pp3 = nexttile; %plot ECG
plot(recECG3);
ylabel('recECG3');
title('Segnale ecg ricostruito con coefficienti di livello 3');

pp4 = nexttile; %plot ECG
plot(recECG4);
ylabel('recECG4');
title('Segnale ecg ricostruito con coefficienti di livello 4');

pp5 = nexttile; %plot ECG
plot(recECG34);
ylabel('recECG34');
title('Segnale ecg ricostruito con coefficienti di livello 3 e 4');

linkaxes([pp2,pp3, pp4, pp5],'x')
axis tight
