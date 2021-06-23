% fornisce quanto "c'ha preso" l'algoritmo
function [FN, FP, TP, TN, Sens, Spec, Acc] = afibContingency(gold, annotations)

    % afibBeats array di uno per i battiti con fibrillazione atriale
    afibBeats = zeros(1, length(gold.sample));
    isAfib = 0;
    for i = 1:length(gold.aux)
        if (gold.aux(i) == "(AFIB")
            isAfib = 1;
        elseif (gold.aux(i) == "(N")
            isAfib = 0;
        elseif (gold.aux(i) == "")
            isAfib = isAfib;
        end
        afibBeats(i) = isAfib;
    end
    afibBeats(end) = afibBeats(end-1);
    
    % vettori della contingenza
    TP = afibBeats & annotations;
    TN = ~afibBeats & ~annotations;
    FP = annotations & ~afibBeats;
    FN = ~annotations & afibBeats;
    
    % somme
    TP = sum(TP);
    TN = sum(TN);
    FP = sum(FP);
    FN = sum(FN);
    
    Sens=TP/(TP+FN);
    Spec=TN/(TN+FP);
    
    Acc = (TP+TN)/(TP+TN+FP+FN);
    
    if sum(isnan(Sens))
        Sens(find(isnan(Sens))) = 1;
    end
    
    if sum(isnan(Spec))
        Spec(find(isnan(Spec))) = 1;
    end
    
    if sum(isnan(Acc))
        Acc(find(isnan(Acc))) = 1;
    end
end
