% disegna l'inizio dei file per la traccia 00 mostrando il risultato post
% filtraggio con e senza zero padding del segnale ECG mostrando la risposta
% all'impulso del filtro che va a causare problemi all'algoritmo fraden
% newman per via delle ampie oscillazioni iniziali

addpath './functions'

[points, attributes] = loadphysionet('ecg', '00');
[gold, extras] = loadphysionet('atr', '00');
filtredSig = filterEcg1and50instable(points(:,1), attributes.samplingFrequency);

filtredSig2 = filterEcg1and50(points(:,1), attributes.samplingFrequency);
figure('Name','Traccia 00 filtrata con e senza rimozione calibrazione','NumberTitle','off');
hold on

plot(filtredSig);
plot(filtredSig2);
title("Traccia 00 filtrata con e senza zero padding");
legend('Senza zero padding','Con zero padding');
xlim([1, 1000]);