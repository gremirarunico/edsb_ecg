% funzione per calcolare la tabella di contingenza per l'algoritmo di
% rilevazione della fibrillazione atriale.

% Input:
% - gold è la struttura contenente le annotazioni del gold standard
% - annotations è il vettore dei tempi contenente le annotazioni
%   dell'algoritmo AFIB

% Output: FN, FP, TP, TN, sensibilità, specificità, accuratezza
function [FN, FP, TP, TN, Sens, Spec, Acc] = afibContingency(gold, annotations)

    % afibBeats contiene le annotazioni sui battiti AFIB del gold standard
    % (1 ogni volta che il battito è AFIB)
    afibBeats = zeros(1, length(gold.sample));
    isAfib = 0;
    
    % quando in gold.aux compare "(AFIB" in afibBeats viene inserito un 1
    % fintanto che non ritorna "(N"
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
    
    % si sommano tutti gli 1 per trovare il totale
    TP = sum(TP);
    TN = sum(TN);
    FP = sum(FP);
    FN = sum(FN);
    
    Sens=TP/(TP+FN);
    Spec=TN/(TN+FP);
    
    Acc = (TP+TN)/(TP+TN+FP+FN);
    
    % nelle tracce in cui c'è solo AFIB, TN=0, FP=0 quindi Spec is NaN;
    % nelle tracce in cui non c'è AFIB, TP=0, FN=0, quindi Sens is NaN.
    % si corregge facendo in modo che quando non sono definite siano 100% 
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
