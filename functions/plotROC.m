function plotROC(TP,FP,TN,FN,newPlot)
Sens=TP./(TP+FN);
Spec=TN./(TN+FP);


% new plot?
if newPlot
    figure
else
    hold on
end

% ROC plot
plot(1-Spec, Sens)
xlim([0 1])
ylim([0 1])
end

