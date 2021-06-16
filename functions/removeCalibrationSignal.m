function sigout = removeCalibrationSignal(sigin)
    load('storedData/calsig.mat');

    lastwarn('', '');

    [annotations, GammaSigma] = crosscorrelazione(sigin, calsig', 0.85);
    oppositeAnnotations = findpeaks(-GammaSigma, 'MinPeakHeight', 0.85);

    [warnMsg, warnId] = lastwarn();

    % Se c'è un warning (mi aspetto Warning: Invalid MinPeakHeight. There
    % are no data points greater than MinPeakHeight.) allora non ci sono
    % picchi pertanto ritorno il segnale così come è stato fornito.
    if(isempty(warnId))
        removeUntil = max([annotations, oppositeAnnotations]);
        sigout = [zeros(removeUntil, 1); sigin(removeUntil+1:end)];
    else
        sigout = sigin;
        disp("Warning solved");
    end
end

