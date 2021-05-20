% detectionEvaluation.m
% fornisce quanto "c'ha preso" l'algoritmo
function [FN, FP, TP, TN] = contingency(gold, annotations, points)
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
    
    % riempio il vettore delle annotazioni
    binaryAnn(annotations) = 1;
    
    FN = 0;
    FP = 0;
    TP = 0;
    % faccio i confronti
    j = 0;
    for i = 1:length(gold)
        indexWindow = (gold(i)-halfWindowTolerance : gold(i) + halfWindowTolerance);
        beatsFound = sum(binaryAnn(indexWindow));
        %binaryAnn(indexWindow) = zeros(length(indexWindow), 1);
        % ne dovevo trovare almeno 1
        if(beatsFound == 0)
            FN = FN + 1;
        else
            TP = TP + 1;
            FP = FP + (beatsFound - 1);
        end
    end
    FP = FP + sum(binaryAnn);
    
    TN = points - TP - FN - FP;
end
