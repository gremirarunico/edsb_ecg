% Algoritmo di Moody per il calcolo del rapporto segnale rumore

function SNR = moody(signal, annotation, sampFreq)
% identificazione potenza del segnale 

window = 0.025;
samplesWindow = round(sampFreq*window);

S= zeros(length(annotation), 1); %matrice colonna delle distanze picco picco del segnale
for k= 1: length(annotation)
    windowCurrentIndex = annotation(k) - samplesWindow: annotation(k)+ samplesWindow;
    currentSamples= signal( windowCurrentIndex);
    S(k) = max(currentSamples) - min(currentSamples);
end
% scartiamo il 5% dei valori più grandi ed il 5% dei valori più piccoli
S=sort(S,'ascend');
S= S(round(0.05*length(S)): end-round(0.05*length(S)));
meanS= mean(S);

% Rumore N
RMSdiff = [];
i= 0;
for k=sampFreq : sampFreq : length(signal)
    i= i+1;
    signalWindow = signal(k-sampFreq+1 : k);
    meanAmplitude = mean(signalWindow);
    RMSdiff(i)=  sqrt( (sum( (signalWindow-meanAmplitude).^2) ) /sampFreq);
end
RMSdiff=sort(RMSdiff,'ascend');
RMSdiff= RMSdiff(round(0.05*length(RMSdiff)): end-round(0.05*length(RMSdiff)));
meanRMSdiff= mean(RMSdiff);

N = (mean(RMSdiff))^2;
SNR=10*log10(meanS/N);    

end
