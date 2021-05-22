function [pos,neg] = predictiveValue(TP,FP,TN,FN)
    pos = TP./(TP+FP);
    neg = TN./(TN+FN);
end

