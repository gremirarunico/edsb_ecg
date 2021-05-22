function [annotations, GammaSigma] = crosscorrelazione(signal, template, threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%k=costante relativa al ritardo
lSignal = length(signal);
D = length(template);
templateMean = mean(template);

for k = 1:(lSignal - D + 1)
    signalMean = mean(signal(k:k+D-1));
    
    for i=1:D
        Numeratore(i)=(template(i)-templateMean)*(signal(i+k-1)-signalMean);
        %Denominatore_fatt1(i)= (template(i)-mean(template))^2;
        %Denominatore_fatt2(i)= ((signal(i+k-1)-mean(signal(k:k+D-1))))^2;
    end
    NumeratoreTot=sum(Numeratore)/(D-1);
    %Denominatore_fatt1_tot=sum(Denominatore_fatt1);
    %Denominatore_fatt2_tot=sum(Denominatore_fatt2);
    %DenominatoreTot=Denominatore_fatt1_tot*Denominatore_fatt2_tot;
    %Denominatore=sqrt(DenominatoreTot);
    DenominatoreTot = std(template) * std(signal(k:k+D-1));
    GammaSigma(k)=NumeratoreTot/DenominatoreTot;
end

GammaSigma = [zeros(1, (D-1)/2), GammaSigma, zeros(1, (D-1)/2)];

[peaksValue, annotations] = findpeaks(GammaSigma, 'MinPeakHeight', threshold);
end

