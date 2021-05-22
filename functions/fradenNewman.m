function annotations=fradenNewman(signal, th1, th2)
    annotations=[];

    signalLen=length(signal);

    if ~exist('th1', 'var')
        th1=0.4*max(signal);
    else
        disp(th1)
        th1=th1*max(signal);
        disp(th1)
    end

    if ~exist('th2', 'var')
        th2=0.7;
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
end



