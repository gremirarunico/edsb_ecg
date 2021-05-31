function annotations=fradenNewman(signal, th1, th2, saveFig, f_sample)
annotations=[];

signalLen=length(signal);


% impostazione valori soglie
if ~exist('th1', 'var')
    th1=0.4*max(signal);
else
    th1=th1*max(signal);
end

if ~exist('th2', 'var')
    th2=0.7;
end

if ~exist('f_sample', 'var')
    f_sample = 128;
end

if ~exist('saveFig', 'var')
    saveFig = 0;
end

%Rettificazione del segnale
signalRect=abs(signal);

%"low level clipper"
for i=1:signalLen
    if signalRect(i)<th1
        signalClipped(i)=th1;
    else
        signalClipped(i)=signalRect(i);
    end
end

%Derivazione del primo ordine
signal1d=signalClipped(1,3:signalLen)-signalClipped(1,1:signalLen-2);
%ovviamente questo vettore sarà 2 elementi più corto di quello iniziale.
%Aggiungiamo zero padding all'inizio
signal1d=[0, 0, signal1d];

for i=1:length(signal1d)
    if signal1d(i)>th2
        annotations=[annotations;i];
    end
end

if(saveFig)
    %crea subdirectory per salvataggio plot
    if not(isfolder('FradenNewmanPlots'))
        mkdir FradenNewmanPlots
    end
    
    % cerco path della subdirectory
    W = what('edsb_ecg');
    path = W.path;
    path = strcat(W.path, '/FradenNewmanPlots');
    
    time = (1:signalLen)/f_sample;
    xLimits = [1*3600,1*3600+10]; %fini di visualizzazione
    
    F1 = figure;
    tiledlayout(3,1);
    p1 = nexttile;
    plot(time,signalRect);
    xlim(xLimits);
    hold on;
    yline(th1, 'r', 'LineWidth', 1, 'Label', 'th1');
    xlabel('Time [s]');
    ylabel('Amplitude [V]');
    title('Segnale rettificato');
    
    p2 = nexttile;
    plot(time,signalClipped);
    xlim(xLimits);
    xlabel('Time [s]');
    ylabel('Amplitude [V]');
    title('Segnale cimato inferiormente');
    
    p3 = nexttile;
    plot(time,signal1d);
    xlim(xLimits);
    hold on;
    yline(th2,'r','Linewidth',1, 'Label', 'th2');
    xlabel('Time [s]');
    ylabel('Amplitude [V]');
    title('Derivata prima');
    
    linkaxes([p1,p2,p3],'x');
    
    saveas(F1, fullfile(path, 'figure1'), 'jpeg'); %jpeg figure
    saveas(F1, fullfile(path, 'figure1'), 'fig'); %mat figure
end
end




