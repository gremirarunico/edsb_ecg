function [annotations, d] = templateL2Norm(signal, template, threshold)
    lSignal = length(signal);
    lTemplate = length(template);
    
    for i = 1 : (lSignal - lTemplate + 1)
        %d(i,1) = sum( (signal(i:i+lTemplate-1)' - template).^2 ) / lTemplate;
        d(i,1) = -sum( ((signal(i:i+lTemplate-1)-mean(signal(i:i+lTemplate-1)))' - template).^2 ) / lTemplate;
    end
    
    
    d = [zeros((lTemplate-1)/2,1); d; zeros((lTemplate-1)/2,1)];

%     plot(d);
    
    [peaksValue, annotations] = findpeaks(d, 'MinPeakHeight', threshold);
end

