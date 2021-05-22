% plotphhisionet.m (c) Marco
% Disegna un plot da physionet, fornire
% punti, attributi, gold standard e valori aggiuntivi
function status = plotphysionet(points,attributes,gold,extras)
figure
plots = tiledlayout(2,1); % disegna 2 plot in verticale
% Top plot
p1 = nexttile(plots); % plot1
p2 = nexttile(plots); % plot2

% Disegna i grafici delle 2 derivazione x,y con x base dei tempi (in
% secondi), y il valore del campione
plot(p1, ((1:attributes.totalsamples)/attributes.samplingFrequency)', points(:,1), '-');
plot(p2, ((1:attributes.totalsamples)/attributes.samplingFrequency)', points(:,2), '-');

% blocco gli assi x insieme (sulle traslazioni)
linkaxes([p1,p2],'x');

% aggiungo i titoli e le unità di misura
title(p1, 'ECG1');
title(p2, 'ECG2');
xlabel(p1, '[s]');
ylabel(p1, '[int]');
xlabel(p2, '[s]');
ylabel(p2, '[int]');

% abilito lo zoom sull'asse x
pan xon
zoom xon

% aggiungo le annotazioni
% trovo l'indice dei campioni con le annotazioni normali (battiti normali)
NSamples = gold.sample(find(gold.beat=='N'));

% aggiungo un punto rosso sull'annotazione dei QRS ai due grafici
p1.NextPlot = 'add';
plot(p1, ((NSamples)/attributes.samplingFrequency)', points(NSamples,1), '.');

p2.NextPlot = 'add';
plot(p2, ((NSamples)/attributes.samplingFrequency)', points(NSamples,2), '.');

% trovo l'indice dei battiti ventricolari
VSamples = gold.sample(find(gold.beat=='V'));
% aggiungo un punto verde sull'annotazione dei battiti ventricolari
p1.NextPlot = 'add';
plot(p1, ((VSamples)/attributes.samplingFrequency)', points(VSamples,1), '.g');

p2.NextPlot = 'add';
plot(p2, ((VSamples)/attributes.samplingFrequency)', points(VSamples,2), '.g');


% trovo l'indice di inizio o fine gruppo battiti (segnato con +)
pIndex = find(gold.beat=='+');
% di questi mi trovo l'indice del campione nella matrice dei battiti
PSamples = gold.sample(pIndex);
% e quale annotazione fosse
labels = gold.aux(pIndex);

% scelgo la y sulla quale stampare le annotazioni di gruppo
y1 = max(points(:,1));
y2 = max(points(:,2));
%y=300;
% stampo le annotazioni inserendo l'etichetta e disegnando una linea
% orizzontale tra una annotazione e la successiva.
for i = 2:length(pIndex)
    ann = line(p1, [PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[y1,y1]);
    ann.Marker = 'o';
    text(p1, PSamples(i-1)/attributes.samplingFrequency, y1, labels(i-1));
    
    ann = line(p2, [PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[y2,y2]);
    ann.Marker = 'o';
    text(p2, PSamples(i-1)/attributes.samplingFrequency, y2, labels(i-1));
end

line(p1, [PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[y1,y1]);
line(p2, [PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[y2,y2]);
end

