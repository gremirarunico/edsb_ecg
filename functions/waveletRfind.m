function locs = waveletRfind(ecgsig, samplingFreq, th, pdistMS, display)

s = 1:length(ecgsig); % vettore campioni
t = s ./ samplingFreq; % vettore dei tempi

% DWT non decimata di livello 4 con sym4 (come madre)
wt = modwt(ecgsig, 4, 'sym4');

wtrec = zeros(size(wt));

% etraggo solo i coefficienti di dettaglio d3 e d4 contenenti il contenuto
% frequenzale dei complessi QRS
%wtrec(3:4, :) = wt(3:4,:);
wtrec(3, :) = wt(3,:);

% antritrasformo con la wavelet sym4
y = imodwt(wtrec,'sym4');

y = abs(y).^2;

avg = mean(y);
if ~exist('th', 'var')
    th = 8*avg;
else
    th = th * avg;
end

if ~exist('pdistMS', 'var')
    pdistMS = 150;
end

[qrspeaks,locs] = findpeaks(y, t,'MinPeakHeight',th, 'MinPeakDistance',pdistMS/1000);
locs = locs * samplingFreq;

if ~exist('display', 'var')
    display = 0;
end

if display
    disp(th);
    figure
    plot(t,y);
    hold on
    plot(t,ecgsig);
end
end

