function plotROC(TP,FP,TN,FN,newPlot)
Sens=TP./(TP+FN);
Spec=TN./(TN+FP);

if sum(isnan(Sens))
    Sens(find(isnan(Sens))) = 1;
end

if sum(isnan(Spec))
    Spec(find(isnan(Spec))) = 1;
end


% new plot?
if newPlot
    figure
else
    hold on
end

% ROC plot
plot(1-Spec, Sens, 'or', 'MarkerFaceColor', 'r');
xlim([0 1])
ylim([0 1])
xlabel("1 - Spec");
ylabel("Sens");
end

