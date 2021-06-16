% detectionEvaluation.m
% fornisce quanto "c'ha preso" l'algoritmo
function [FN, FP, TP, TN, Sens, Spec, Acc] = contingency(gold, annotations, points)
    % trovo la larghezza della finestra di tolleranza a partire dalle
    % annotazioni del medico. Mi prendo la finestra più piccola che
    % contenga un solo QRS secondo il medico.
    qrsDistance = zeros(length(gold)-1, 1);
    for i=2:length(gold)
        qrsDistance(i-1) = gold(i)-gold(i-1);
    end
    
    halfWindowTolerance = fix(min(qrsDistance)/2); % metà fienstra
    
    %vettore campioni delle annotazioni
    binaryAnn = zeros(points + halfWindowTolerance, 1);
    
    % riempio il vettore delle annotazioni. Metto un 1 quando c'è una
    % annotazione dell'algoritmo da confrontare
    binaryAnn(annotations) = 1;
    
    FN = 0;
    FP = 0;
    TP = 0;
    % faccio i confronti
    for i = 1:length(gold)
        % finestra dell'intervallo di tolleranza
        indexWindow = (gold(i)-halfWindowTolerance : gold(i) + halfWindowTolerance);
        
        % controllo che non ci siano indici negativi (finestra troppo
        % vicina a sinistra) per correggere errore sequenza 64
        if(sum(indexWindow <=1))
            indexWindow = indexWindow(sum(indexWindow <=1) : end);
        end
        
        % il numero di battiti nella finestra è pari alla somma degli uno
        % che ci sono nella finestra
        beatsFound = sum(binaryAnn(indexWindow));

        % azzero la finestra, così potrò contare i falsi positivi
        % aggiuntivi che non si trovano in alcuna finestra individuata dal
        % medico
        binaryAnn(indexWindow) = zeros(length(indexWindow), 1);
        % ne dovevo trovare almeno 1 di battito, se non lo trovo è un falso
        % negativo
        if(beatsFound == 0)
            FN = FN + 1;
        % altrimenti c'è almeno un battito (quindi sicuramente un vero
        % negativo e se ce ne sono di più saranno altri falsi positivi
        else
            TP = TP + 1;
            FP = FP + (beatsFound - 1);
        end
    end
    % aggiungo ai falsi positivi altri elementi trovati che non sono stati
    % trovati nella finestra
    FP = FP + sum(binaryAnn);
    
    TN = points - TP - FN - FP;
    
    Sens=TP/(TP+FN);
    Spec=TN/(TN+FP);
    Acc = (TP+TN)/(TP+TN+FP+FN);
end
