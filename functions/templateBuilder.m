% templateBuilder.m
% Costruisce il template calcolando media e varianza, fornisce il range di
% confidenza considerando un valore pari nSigma * std
function [meanData, topBorder, bottomBorder] = templateBuilder(dataTemplate, nSigma)
    meanData = mean(dataTemplate);
    sigma = sqrt(var(dataTemplate));
    topBorder = meanData + nSigma * sigma;
    bottomBorder = meanData - nSigma * sigma;
end

