% funzione per caricare i dati di physionet

% Questa funzione si occupa di leggere i dati da physionet estratti in file
% di testo.
% Ingresso:
% action stringa che descrive l'azione, cioè i dati da ottenere, può essere
% ecg
% atr
% qrs
% Uscita:
% dataout e info
% Questi dati si differenziano a seconda del tipo di azione

% per azione ecg (segnale acquisito)
% dataout è una array con il valore dell'ampiezza in V dei battiti, una colonna per segnale
% una riga per campione.
% info è una struttura dati contenenti varie informazioni sul segnale:
% * info.signals, numero di segnali
% * info.totalsamples numero di campioni per segnale
% * info.timestart matrice contentenente l'ora di acquisizione di ciascun
%   campione
% * info.date data della registrazione
% * info.duration durata temporale della registrazione (stringa)
% * info.samplingFrequency frequenza di campionamento del segnale
% * info.gain guadagno del segnale, è un array visto che vale per ogni segnale
% * info.base offset in ampiezza del segnale (array)
% * info.exit stato di uscita della funzione, 0 se tutto ok, 1 se errore
% * info.error in caso di errore è definita, fornisce l'errore

% per azione qrs (annotazioni con algoritmo physionet)
% * dataout.sample array of int: campioni QRS (algoritmo physionet)
% * dataout.beat array of string: array contentente il tipo di battito
%   (algoritmo physionet)
% * info.date data di ciascun battito (algoritmo physionet)
% * info.time (array string) riferimento temporale di ciascun battito 

% per azione atr (annotazioni esperti)
% * dataout.sample array of int: campioni QRS (annotazioni esperti)
% * dataout.beat array of string: type of beat
% * dataout.aux array of string: additional info about type of beat
% * info.date array string related to beat indicated date sample
% * info.time array string related to beat indicated time sample

% Type seleziona il tipo di dato e può essere ecg per caricare i battiti
function [dataout, info] = loadphysionet(action, name)
% dummy definitions
path = 'physionetdata/';
suffixData = '_data.txt';
suffixDataMat = '_data.mat';
suffixDatalog = '_datalog.txt';
suffixAtr = '.atr.txt';
suffixAtrMat = '.atr.mat';
suffixHea = '.hea.txt';
suffixQrs = '.qrs.txt';

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
                % get registration start
                info.timestart = findtextbetween('Start: [', ' ', line);
                info.date = findtextbetween([info.timestart,' '], ']', line);
                % second line get signals number and samles number
            elseif i == 2
                info.signals = str2num(findtextbetween('val has ', ' rows (signals)', line));
                info.totalsamples = str2num(findtextbetween('(signals) and ', ' columns (samples', line));
                %forth line get sampling frequency
            elseif i ==3
                info.duration = findtextbetween('Duration: ', sprintf('\n'), line);
            elseif i ==4
                info.samplingFrequency = str2num(findtextbetween('Sampling frequency: ', ' Hz  Sampling', line));
                %lines for all signals
                info.gain = [];
                info.base = [];
                % get gain and base for each signal
            elseif i > 5 && i <= 5 + info.signals
                gain = findtextbetween('ECG	', '	', line);
                base = findtextbetween([gain(end-1:end),'	'], '	mV', line);
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
            %last = info.signals + 1; % end term of dataline (don't use end to overtime)
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
                    waitbar(percent,wbar,sprintf('Processing your ECG samples from txt... %d%%', round(percent*100)));
                end
                
                line = fgets(fLog);
                i = i+1;
            end
            close(wbar);
            
            
            disp('Saving data as a mat file');
            save([path, name, suffixDataMat],'dataout');
            
            
            info.exit = 0;
            info.error = 0;
            % per ottenere l'uscita in mV fare (sample - base)/gain
        end
        %convert dataout in mV using gains
          [lines, rows] = size(dataout);
          for row = 1:rows
              for line = 1:lines
                  dataout(line, row) = (dataout(line, row) - info.base(row))/info.gain(row);
              end
          end
        
    case 'atr'
        % if cached load it
        if isfile([path, name, suffixAtrMat])
            %disp('Found cached data, loading it...');
            load([path, name, suffixAtrMat])
        % else i have to laod it form a textfile, it will be a bit slow :(
        else
            % load log file
            [fLog, fLogerr] = fopen([path, name, suffixAtr], 'r');
            % If file not found return error
            if not(isempty(fLogerr)) && (strcmp(fLogerr, 'No such file or directory'))
                dataout = 0;
                info.exit = 1;
                info.error = 'No such file or directory';
                return;
            end
            
            % get file lines
            lines = 0;
            while fgetl(fLog)~=-1
                lines = lines + 1;
            end
            lines = lines - 2; %last line is empty and first is header
            %disp(lines);
            
            frewind(fLog);
            
            % load data
            fgets(fLog); % i can miss first line because there is the header
            line = fgets(fLog);
            wbar = waitbar(0, 'Waiting, loading atr from txt');
            
            info.time = strings(lines, 1);
            info.date = strings(lines, 1);
            dataout.sample = zeros(lines, 1);
            dataout.beat = strings(lines, 1);
            dataout.aux = strings(lines, 1);
            i = 1;
            oldpercent = 0;
            while(line ~= -1)
                
                percent = round(i/lines*100);
                if oldpercent ~= percent
                    oldpercent = percent;
                    waitbar(percent/100,wbar,sprintf('Processing your ATR data from txt... %d%%', percent));
                end
                splitted = split(line);
                time = cell2mat(splitted(1));
                info.time(i) = time(2:end);
                
                date = cell2mat(splitted(2));
                info.date(i) = date(1:end-1);
                
                dataout.sample(i) = str2num(cell2mat(splitted(3))) + 1; %+1 is needed because in matlab matrix strart countin form 1 and not 0
                
                dataout.beat(i) = cell2mat(splitted(4));
                
                % extract aux
                if cell2mat(splitted(8)) ~= 0x0
                    if length(cell2mat(splitted(8))) == 1
                        dataout.aux(i) = cell2mat(splitted(9));
                    else
                        dataout.aux(i) = cell2mat(splitted(8));
                        
                    end
                end
                
                line = fgets(fLog);
                
                i = i+1;
            end
            close(wbar);
            save([path, name, suffixAtrMat], 'dataout', 'info');
        end
        info.exit = 0;
        info.error = 0;
        
    % TODO: cache to accelerate
    case 'qrs'
        % load log file
        [fLog, fLogerr] = fopen([path, name, suffixQrs], 'r');
        % If file not found return error
        if not(isempty(fLogerr)) && (strcmp(fLogerr, 'No such file or directory'))
            dataout = 0;
            info.exit = 1;
            info.error = 'No such file or directory';
            return;
        end
        
        % get file lines
        lines = 0;
        while fgetl(fLog)~=-1
            lines = lines + 1;
        end
        lines = lines - 2; %last line is empty and first is header
        %disp(lines);
        
        frewind(fLog);
        
        % load data
        fgets(fLog); % i can miss first line because there is the header
        line = fgets(fLog);
        wbar = waitbar(0, 'Waiting, loading qrs from txt');
        
        info.time = strings(lines, 1);
        info.date = strings(lines, 1);
        dataout.sample = zeros(lines, 1);
        dataout.beat = strings(lines, 1);
        i=0;
        oldpercent = 0;
        while(line ~= -1)
            i = i+1;
            percent = round(i/lines*100);
            if oldpercent ~= percent
                oldpercent = percent;
                waitbar(percent/100,wbar,sprintf('Processing your QRS data from txt... %d%%', percent));
            end
            splitted = split(line);
            time = cell2mat(splitted(1));
            info.time(i) = time(2:end);
            
            date = cell2mat(splitted(2));
            info.date(i) = date(1:end-1);
            
            dataout.sample(i) = str2num(cell2mat(splitted(3)));
            
            dataout.beat(i) = cell2mat(splitted(4));
            
            line = fgets(fLog);
        end
        close(wbar);
        
        info.exit = 0;
        info.error = 0;
    otherwise
        dataout = 0;
        info.exit = 1;
        info.error = 'Unexpected value action in loadphysionet!';
        warning('Unexpected value action in loadphysionet!');
end
