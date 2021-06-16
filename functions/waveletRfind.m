function locs = waveletRfind(ecgsig, samplingFreq)
% trasformata wt di scala 5
ecgsig = ecgsig*1000;
wt = modwt(ecgsig,5);

% mi setto una matrice vuota della dimensione della wavelet
wtrec = zeros(size(wt));
% seleziono la wavelet di scala 4 e 5
wtrec(4:5,:) = wt(4:5,:);

% antritrasformo con la wavelet sym4
y = imodwt(wtrec,'sym4');

y = abs(y).^2;
[qrspeaks,locs] = findpeaks(y,'MinPeakHeight',0.1, 'MinPeakDistance',fix(0.150*samplingFreq));
end

