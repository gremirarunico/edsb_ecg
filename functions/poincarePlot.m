% Funzione per il diagramma di Poincaré
% Input: 
% - allSamples, vettore dei tempi contenente i battiti
% - sf, sampling frequency
% - plot è 1 se la funzione deve ritornare il plot 

% Output:
% - x, vettore intervalli RR [RR_1...RR_(N-1)]
% - y, vettore intervalli RR [RR_2...RR_N]
% - x1 = x-y/sqrt(2)
% - x2 = x+y/sqrt(2)
% - SD1, SD2 parametri del plot di Poincaré
% - S = pi*SD1*SD2 paramentro dell'algoritmo

% Poincare plot function
function [x, y, x1, x2, SD1, SD2, S] = poincarePlot(allSamples, sf, plot)
    %inizializzo la matrice degli intervalli RR
    RR = zeros(length(allSamples)-1, 1);
    y = zeros(length(allSamples), 1);
    
    % calcolo il vattore degli intervalli RR in campioni 
    for i = 1:(length(allSamples) - 1)
        RR(i) = allSamples(i+1)-allSamples(i);
    end
    
    % converto gli intervalli RR in secondi
    RR = RR./sf;
    
    % calcolo x e y
    x = RR(1:end-1);
    y = RR(2:end);
    
    % calcolo x1 e x2
    x1 = (x-y)/sqrt(2);
    x2 = (x+y)/sqrt(2);
    
    % calcolo SD1 e SD2
    SD1 = std(x1);
    SD2 = std(x2);
    
    S = pi * SD1 * SD2;
    
    % plot if required
    if plot
        %figure;
        hold on;
        scatter(x,y);
        fplot(@(x) x, 'k-');
        xlim([0, 5]);
        ylim([0, 5]);
    end

end