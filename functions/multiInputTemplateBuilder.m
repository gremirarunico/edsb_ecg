% dataset è del tipo ["108"; "110"]
function dataTemplate = multiInputTemplateBuilder(dataset, startPoint, nWindows, wLength, derivation, filter)
    % parametro facoltativo
    if ~exist('derivation','var')
        derivation = 1;
    end
    
    if ~exist('filter','var')
        filter = 0;
    end
    
    % concateno i template
    dataTemplate = zeros(nWindows*size(dataset,1), wLength);
    for i = 1:size(dataset, 1)
        [points, attributes] = loadphysionet('ecg', convertStringsToChars(dataset(i)));
        [gold, extras] = loadphysionet('atr', convertStringsToChars(dataset(i)));
        
        if filter
            dataTemplate((i-1)*nWindows+1 : (i)*nWindows, :) = templateDataSelector(filterEcg1and50(points(:,derivation), attributes.samplingFrequency), gold.sample, startPoint, nWindows, wLength);
        else
            dataTemplate((i-1)*nWindows+1 : (i)*nWindows, :) = templateDataSelector(points(:,derivation), gold.sample, startPoint, nWindows, wLength);
        end
    end
end

