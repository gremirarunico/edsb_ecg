% Filtro passa banda per il segnale ecg, instabile
function sigout = filterEcg1and50instable(sigin, sf)
    bpFilt = designfilt('bandpassiir','FilterOrder',20,...
    'DesignMethod','butter', ...
    'HalfPowerFrequency1',1,'HalfPowerFrequency2',50,...
    'SampleRate',sf);

    sigout = filtfilt(bpFilt, sigin);
    % aggiunta per eliminare risposta all'impulso
end

