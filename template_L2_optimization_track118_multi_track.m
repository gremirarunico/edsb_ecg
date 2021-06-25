
% template_optimization.m ottimizzazione dell'algoritmo con template
addpath './functions'

% Reset workspace

allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "30"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];

% dimensione della finestra del template

sampleStart = 100;
nWindows = 50;
a = 9;
b = 9;
% costruisco il template senza filtraggio aggiuntivo
FN = zeros(a,b);
FP = zeros(a,b);
TP = zeros(a,b);
TN = zeros(a,b);
Sens = zeros(a,b);
Spec = zeros(a,b);
Acc = zeros(a,b);
FNt = zeros(a, b);
FPt = zeros(a, b);
TPt = zeros(a, b);
TNt = zeros(a, b);

for dragZ = 1:length(allDatasets)
    totalRep = a*b;
    oldPercent = -1;
    percentCount = 0;
    
    [points, attributes] = loadphysionet('ecg', convertStringsToChars(allDatasets(dragZ)));
    [gold, extras] = loadphysionet('atr', convertStringsToChars(allDatasets(dragZ)));
    filtredSig = filterEcg1and50(points(:,1), attributes.samplingFrequency);

    for i=1:a
        templateSize = 3+2*i;% numeri dispari da 5 a 21
        
        templateMatrix = multiInputTemplateBuilder(["118"; "102"; "115"; "120"; "45"], sampleStart, nWindows, templateSize, 1, 1);
        %templateMatrix = templateDataSelector(filtredSig, gold.sample, sampleStart, nWindows, templateSize);
        templateMatrix = (templateMatrix' ./ max(templateMatrix'))';
        template = mean(templateMatrix);
        
        for j=1:b
            percentCount = percentCount + 1;
            percent = round(percentCount/totalRep*100,2);
            if(oldPercent ~= percent)
                oldPercent = percent;
                disp("Stato simulazione " + percent + "%");
            end
            soglia = -0.5 + 0.05*j;
            % riconoscimento
            [annotations, c] = templateL2Norm(filtredSig, template, soglia);
            
            [FN(i,j), FP(i,j), TP(i,j), TN(i,j), Sens(i,j), Spec(i,j), Acc(i,j)] = contingency(gold.sample, annotations, attributes.totalsamples);
        end
    end
    % contingenza totale su tutte le tracce del training set
    FNt = FNt + FN;
    FPt = FPt + FP;
    TPt = TPt + TP;
    TNt = TNt + TN;
end

plotROC(TPt,FPt,TNt,FNt,1);
Sens=TPt./(TPt+FNt);
Spec=TNt./(TNt+FPt);