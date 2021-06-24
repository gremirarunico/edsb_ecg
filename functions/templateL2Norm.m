function [annotations, d] = templateL2Norm(signal, template, threshold)
    lSignal = length(signal);
    lTemplate = length(template);
    
    for i = 1 : (lSignal - lTemplate + 1)
        %d(i,1) = sum( (signal(i:i+lTemplate-1)' - template).^2 ) / lTemplate;
        %w = (signal(i:i+lTemplate-1)-mean(signal(i:i+lTemplate-1)))';
        maxim = max(signal(i:i+lTemplate-1));
        if ~maxim
            maxim = 1;
        end
        %w = (signal(i:i+lTemplate-1))'/maxim;
        w = (signal(i:i+lTemplate-1)-mean(signal(i:i+lTemplate-1)))'/maxim; % con filtraggio a media mobile
        d(i,1) = -sum(( w - template).^2 ) / lTemplate;
    end
    
    
    d = [zeros((lTemplate-1)/2,1); d; zeros((lTemplate-1)/2,1)];

%     plot(d);
    
    [peaksValue, annotations] = findpeaks(d, 'MinPeakHeight', threshold);
end

