% Filtro passa banda per il segnale ecg, corretta risposta all'impulso
function sigout = filterEcg1and50(sigin, sf)
    bpFilt = designfilt('bandpassiir','FilterOrder',20,...
    'DesignMethod','butter', ...
    'HalfPowerFrequency1',1,'HalfPowerFrequency2',50,...
    'SampleRate',sf);

    %sigout = filtfilt(bpFilt, sigin);
    % aggiunta per eliminare risposta all'impulso
    ignoreSize = 10000; % numero di zeri all'inizio e alla fine
    tempSig = [zeros(ignoreSize, 1); sigin(:); zeros(ignoreSize, 1)];
    filtredTempSig = filtfilt(bpFilt, tempSig);
    sigout = filtredTempSig(ignoreSize+1:end-ignoreSize);
end

