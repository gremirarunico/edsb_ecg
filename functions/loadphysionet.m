% funzione per caricare i dati di physionet

% Questa funzione si occupa di leggere i dati da physionet estratti in file
% di testo.
% Ingresso:
% action stringa che descrive l'azione, cioè i dati da ottenere, può essere
% ecg
% atr
% qrs
% Uscita
% dataout e info
% Questi dati si differenziano a seconda del tipo di azione
% per azione ecg
% dataout è una array con il valore dei battiti, una colonna per segnale
% una riga per campione.
% info è una struttura dati contenenti varie informazioni sul segnale:
% * info.signals, numero di segnali
% * info.totalsamples numero di campioni per segnale
% * info.samplingFrequency frequenza di campionamento del segnale
% * info.gain guadagno del segnale, è un array visto che vale per ogni segnale
% * info.base linea base del segnale, come gain
% * info.exit stato di uscita della funzione, 0 se tutto ok, 1 se errore
% * info.error in caso di errore è definita, fornisce l'errore

% Type seleziona il tipo di dato e può essere ecg per caricare i battiti
function [dataout, info] = loadphysionet(action, name)
% dummy definitions
path = 'physionetdata/';
suffixData = '_data.txt';
suffixDataMat = '_data.mat';
suffixDatalog = '_datalog.txt';
suffixAtr = '.atr.txt';
suffixHea = '.hea.txt';
suffxQrs = '.qrs.txt';

switch action
    case 'ecg'
        [fLog, fLogerr] = fopen([path, name, suffixDatalog], 'r');
        % If file not found return error
        if not(isempty(fLogerr)) && (strcmp(fLogerr, 'No such file or directory'))
            dataout = 0;
            info.exit = 1;
            info.error = 'No such file or directory';
            return;
        end
        % get files info
        line = 1;
        i = 0;
        while(line ~= -1)
            i = i + 1;
            line = fgets(fLog);
            % first line, file name check
            if i==1
                namefound = findtextbetween('Source: record ', '  Start', line);
                % controllo se il nome coincide
                if namefound ~= name
                    dataout = 0;
                    info.exit = 1;
                    info.error = 'Source file is corrupted';
                    return;
                end
                % second line get signals number and samles number
            elseif i == 2
                info.signals = str2num(findtextbetween('val has ', ' rows (signals)', line));
                info.totalsamples = str2num(findtextbetween('(signals) and ', ' columns (samples', line));
                %forth line get sampling frequency
            elseif i ==4
                info.samplingFrequency = str2num(findtextbetween('Sampling frequency: ', ' Hz  Sampling', line));
                %lines for all signals
                info.gain = [];
                info.base = [];
            % get gain and base for each signal
            elseif i > 5 && i <= 5 + info.signals
                gain = findtextbetween('ECG	', '	', line);
                base = findtextbetween([gain(end),'	'], '	mV', line);
                %disp(str2num(findtextbetween('ECG	', '	', line)));
                info.gain = [info.gain, str2num(gain)];
                info.base = [info.base, str2num(base)];
                %disp(i);
                %disp(line);
            end
        end
        
        fclose(fLog);
        
        % get samples
        % if file is cached as mathlab binary data load it
        if isfile([path, name, suffixDataMat])
            %disp('Found cached data, loading it...');
            load([path, name, suffixDataMat])
        % else i have to laod it form a textfile, it will be extremly slow :(
        else
            oldpercent = 0;
            wbar = waitbar(0, 'Waiting, loading file from txt');
            %disp('File not cached, loading from txt, it will be very slow, be patient (can take more than 2 hours)!');
            [fLog, fLogerr] = fopen([path, name, suffixData], 'r');
            fgets(fLog); % i can miss first line because there is the header
            line = fgets(fLog);
            dataout = zeros(info.totalsamples, info.signals);
            i = 0; % iterator for data check
            last = info.signals + 1; % end term of dataline (don't use end to overtime)
            while(line ~= -1)
                dataline = extractNumFromStr(line);
                if (i ~= dataline(1))
                    fprintf('Error, number samples in data not contiguos, expected %d, found %d, restarting from %d, check for incongruences\n', [i, dataline(1), dataline(1)]);
                    i = dataline(1);
                end
                
                for j = 1:info.signals
                    dataout(i+1,j) = dataline(j+1);
                end
                %dataout = [dataout; dataline(2:last)];
                percent = round(dataline(1)/info.totalsamples, 2);
                if percent ~= oldpercent
                    oldpercent = percent;
                    waitbar(percent,wbar,sprintf('Processing your data from txt... %d%%', round(percent*100)));
                end
                
                line = fgets(fLog);
                i = i+1;
            end
            close(wbar);
            
            %TODO convert dataout in mV using gains
            
            disp('Saving data as a mat file');
            save([path, name, suffixDataMat],'dataout');
            
            
            info.exit = 0;
            info.error = 0;
            % per ottenere l'uscita in mV fare (sample - base)/gain
        end
        
    case 'atr'
        dataout = 0;
        status = 0;
        
    case 'qrs'
        dataout = 0;
        status = 0;
        
    otherwise
        dataout = 0;
        status = 1;
        warning('Unexpected value action in loadphysionet!');
end

end

