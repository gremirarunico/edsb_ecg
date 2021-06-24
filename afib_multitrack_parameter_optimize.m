addpath './functions'

% Reset workspace
% clear all
% close all
% clc

%allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "105"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "203"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];
allDatasets = ["15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "203"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];
%["35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];
%allDatasets = ["51"; "12"; "43"; "22"; "74"; "58"; "200"; "19"; "119"; "105"];

af = 40;
bf = 40;
% FNt = zeros(af, bf);
% FPt = zeros(af, bf);
% TPt = zeros(af, bf);
% TNt = zeros(af, bf);


for dragonballZ = 1:length(allDatasets)
    disp(allDatasets(dragonballZ));
    
    [points, attributes] = loadphysionet('ecg', convertStringsToChars(allDatasets(dragonballZ)));
    [gold, extras] = loadphysionet('atr', convertStringsToChars(allDatasets(dragonballZ)));
    
    % battiti normali
    %normalBeatsSamples = gold.sample(find(gold.beat=='N'));
    normalBeatsSamples = gold.sample;
    
    % numero di battiti in una finestra
    L = 128;
    
    S = zeros(1, fix(length(normalBeatsSamples)/L)+1);
    sampEntropy = zeros(1, fix(length(normalBeatsSamples)/L)+1);
    
    afibInWindow = zeros(1, fix(length(normalBeatsSamples)/L)+1);
    
    index = 1;
    for i = 1:fix(length(normalBeatsSamples)/L)
        [x, y, x1, x2, SD1, SD2, S(i)] = poincarePlot(normalBeatsSamples(index:index+L), attributes.samplingFrequency, 0);
        
        RRs = x;
        RRs(end) = y(end);
        
        sampEntropy(i) = sampleEntropy(2, 0.2 * std(RRs), RRs);
        
        % indice dei battiti, di L in L
        index = index + L;
    end
    
    thS = 0;
    thE = 0;
    
    z = 0;
    
    FN = zeros(af, bf);
    FP = zeros(af, bf);
    TP = zeros(af, bf);
    TN = zeros(af, bf);
    Sens = zeros(af, bf);
    Spec = zeros(af, bf);
    Acc = zeros(af, bf);
    
    final = af*bf;
    oldPercent = -1;
    for a=1:af
        thS = 0.0045 + a * 0.0005;
        for b=1:bf
            z = z+1;
            percent = round(z/final,2)*100;
            if(percent ~= oldPercent)
                oldPercent = percent;
                disp("Completato al " + round(percent) +"%");
            end
            
            thE = 0.1 + b * 0.04;
            
            %disp("For thS=" + thS + " and thE=" + thE);
            afibInWindow = (S > thS) & (sampEntropy > thE);
            
            annotations = zeros(1, length(gold.sample));
            
            for i = 1:length(afibInWindow)
                if afibInWindow(i)
                    annotations(i*L-L+1:i*L) = 1;
                end
            end
            
            [FN(a,b), FP(a,b), TP(a,b), TN(a,b), Sens(a,b), Spec(a,b), Acc(a,b)] = afibContingency(gold, annotations);
        end
    end
    
    FNt = FNt + FN;
    FPt = FPt + FP;
    TPt = TPt + TP;
    TNt = TNt + TN;
    
end
plotROC(TPt,FPt,TNt,FNt,1);
Sens=TPt./(TPt+FNt);
Spec=TNt./(TNt+FPt);