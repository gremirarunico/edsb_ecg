% main.m parte principale dello script
addpath './functions'

% Reset workspace
clear all
close all
clc

FNz = zeros(1, 10);
FPz = zeros(1, 10);
TNz = zeros(1, 10);
TPz = zeros(1, 10);

allDatasets = ["00"; "01"; "03"; "05"; "06"; "07"; "08"; "10"; "100"; "101"; "102"; "103"; "104"; "11"; "110"; "111"; "112"; "113"; "114"; "115"; "116"; "117"; "118"; "119"; "12"; "120"; "121"; "122"; "13"; "15"; "16"; "17"; "18"; "19"; "20"; "200"; "201"; "202"; "204"; "205"; "206"; "207"; "208"; "21"; "22"; "23"; "24"; "25"; "26"; "28"; "30"; "32"; "33"; "34"; "35"; "37"; "38"; "39"; "42"; "43"; "44"; "45"; "47"; "48"; "49"; "51"; "53"; "54"; "55"; "56"; "58"; "60"; "62"; "64"; "65"; "68"; "69"; "70"; "71"; "72"; "74"; "75"];

allDatasets = ["22"; "45"; "39"; "110"; "111"; "112"; "113"; "114"; "115"; "116"];


for dragZ = 1:length(allDatasets)
    disp(allDatasets(dragZ));
    [points, attributes] = loadphysionet('ecg', convertStringsToChars(allDatasets(dragZ)));
    [gold, extras] = loadphysionet('atr', convertStringsToChars(allDatasets(dragZ)));
    
    k = 0;
    for i=1:10
        k = k+1;
        k/10*100
        soglia = i/10;
        annotations = waveletRfind(points(:,1), attributes.samplingFrequency, soglia);
        [FN(i), FP(i), TP(i), TN(i), Sens(i), Spec(i), Acc(i)] = contingency(gold.sample, annotations, attributes.totalsamples);
    end
    FNz = FNz + FN;
    FPz = FPz + FP;
    TNz = TNz + TN;
    TPz = TPz + TP;
end
plotROC(TPz,FPz,TNz,FNz,1);
Sens=TPz./(TPz+FNz);
Spec=TNz./(TNz+FPz);