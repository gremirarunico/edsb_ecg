% templateDataSelector.m

% funzione di selezione dati per i template
% samples: campioni in ingresso singolo soggetto, singola traccia
% beatIndex: lista battiti gold standard della traccia
% startIndex: indice di inizio del primo battito da considerare
% nWindows: numero di finestre da prelevare
% windowLength: larghezza in campioni della finestra (in numero di
% campioni) deve essere dispari.
% @return matrice dei campioni finestrati per il template: in ogni riga una finestra

function dataTemplate = templateDataSelector(samples, beatIndex, startIndex, nWindows, windowLength)
    % se i campioni della finestra sono pari ne aggiungo uno (finestra
    % simmetrica)
    if mod(windowLength,2) == 0
        windowLength = windowLength + 1;
        disp("Numero di campioni inserito corretto a " + windowLength);
    end
    
    % indici del sample centrale della finestra da considerare
    windowCentersIndex = beatIndex(startIndex : (startIndex - 1) + nWindows);
    
    % inizializzo uscita, matrice nWindows x windowLength
    dataTemplate = zeros(nWindows, windowLength);
    for i = 1:nWindows
        biggerWindowLength = windowLength + 2;
        biggerDataTemplate = samples(windowCentersIndex(i)-(biggerWindowLength-1)/2 : windowCentersIndex(i)+(biggerWindowLength-1)/2);
        l = biggerDataTemplate(fix(biggerWindowLength/2));
        c = biggerDataTemplate(fix(biggerWindowLength/2)+1);
        r = biggerDataTemplate(fix(biggerWindowLength/2)+2);
        if(l>c)
            dataTemplate(i,:) = biggerDataTemplate(1:end-2);
        elseif(r>c)
            dataTemplate(i,:) = biggerDataTemplate(3:end);
        else
            dataTemplate(i,:) = biggerDataTemplate(2:end-1);
        end
        %dataTemplate(i,:) = samples(windowCentersIndex(i)-(windowLength-1)/2 : windowCentersIndex(i)+(windowLength-1)/2);
        %
        dataMean = mean(dataTemplate(i,:));
        
        dataTemplate(i,:) = dataTemplate(i,:) - dataMean;
        
    end
    
    return
end

