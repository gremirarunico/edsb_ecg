% Poincare plot 

% Poincare plot function
function [x, y, x1, x2, SD1, SD2, S] = poincarePlot(allSamples, sf, plot)
    RR = zeros(length(allSamples)-1, 1);
    y = zeros(length(allSamples), 1);
    
    for i = 1:(length(allSamples) - 1)
        RR(i) = allSamples(i+1)-allSamples(i);
    end
    
    RR = RR./sf;
    
    x = RR(1:end-1);
    y = RR(2:end);
    
    x1 = (x-y)/sqrt(2);
    x2 = (x+y)/sqrt(2);
    
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