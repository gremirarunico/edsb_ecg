% crosscorrelazione.m
% Metrica di similitudine (cross-correlazione normalizzata) per la
% rilevazione delle forme d'onda 

% Input:
% - signal, campioni del segnale 
% - template, campioni del template medio 
% - threshold, soglia sulla cross-correlazione

% Output:
% - annotations, vettore delle annotazioni contenente l'indice dei campioni
%   corrispondenti a battiti
% - GammaSigma, funzione di cross-correlazione normalizzata

function [annotations, GammaSigma] = crosscorrelazione(signal, template, threshold)

%k=costante relativa al ritardo
lSignal = length(signal);
D = length(template); 
templateMean = mean(template); %valor medio del template

% in ogni finestra di D campioni si calcola la media del segnale
for k = 1:(lSignal - D + 1)
    
    % in ogni finestra viene calcolata la media del segnale
    signalMean = mean(signal(k:k-1+D));
    
    for i=1:D
        Numeratore(i)=(template(i)-templateMean)*(signal(i+k-1)-signalMean);
    end
    NumeratoreTot=sum(Numeratore)/(D-1);
    
    % la std del segnale è calcolata in ogni finestra di D campioni
    DenominatoreTot = std(template) * std(signal(k:k+D-1));
    GammaSigma(k)=NumeratoreTot/DenominatoreTot;
end

% zero padding prima e dopo per allineamento con il segnale  
GammaSigma = [zeros(1, (D-1)/2), GammaSigma, zeros(1, (D-1)/2)];

% plot(GammaSigma);

[peaksValue, annotations] = findpeaks(GammaSigma, 'MinPeakHeight', threshold);
end

